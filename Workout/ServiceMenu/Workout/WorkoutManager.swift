//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation

protocol WorkoutViewDelegate: AnyObject {
  func workoutAdded()
  func workoutChanged()
  func workoutRemoved(at indexPath: IndexPath)
}

class WorkoutManager {
  static let shared = WorkoutManager()
  
  private let networkConnecter = WorkoutNetworkConnecter()
  private var workoutCodeDictionary = [String : Workout]()
  private var workouts: [Workout] {
    return workoutCodeDictionary.map { $0.value }
  }
  private var targetIndexPath: IndexPath?
  
  weak var workoutViewDelegate: WorkoutViewDelegate?
  
  private init() {
    networkConnecter.workoutDelegate = self
  }
  
  func test() {
    
  }
  
  func register(workout: Workout) {
    networkConnecter.createWorkoutId(workout: workout) { key in
      workout.configureId(with: key)
      self.workoutCodeDictionary[key] = workout
      self.networkConnecter.updateWorkoutData(workout: workout)
    }
  }
  
  func workout(at indexPath: IndexPath) -> Workout {
    let section = BodySection.allCases[indexPath.section]
    let filteredWorkout = filteredWorkout(by: section)
    
    return filteredWorkout[indexPath.row]
  }
  
  func workoutByCode(_ code: String) -> Workout? {
    return workoutCodeDictionary[code]
  }
  
  func removeWorkout(at indexPath: IndexPath) {
    let removingWorkout = workout(at: indexPath)
    
    self.targetIndexPath = indexPath
    networkConnecter.removeWorkoutData(workout: removingWorkout)
  }
  
  func updateWorkout(_ code: String, _ name: String, _ weightUnit: WeightUnit, _ bodySection: BodySection) {
    guard let updatingWorkout = workoutByCode(code) else { return }
    updatingWorkout.update(name, bodySection, weightUnit)
    networkConnecter.updateWorkoutData(workout: updatingWorkout)
  }
  
  func updateWorkoutRegistration(_ code: String, _ registeredDate: DateInformation) {
    guard let workout = workoutByCode(code),
          let updatedWorkoutRegisteredDate = workout.addRegisteredDate(on: registeredDate) else { return }
    
    networkConnecter.updateWorkoutRegistrationDate(code: code, dateSet: updatedWorkoutRegisteredDate)
  }
  
  func removeWorkoutRegistration(_ code: String, _ registeredDate: DateInformation) {
    guard let workout = workoutByCode(code),
          let updatedWorkoutRegisteredDate = workout.removeRegisteredDate(on: registeredDate) else { return }
    
    networkConnecter.updateWorkoutRegistrationDate(code: code, dateSet: updatedWorkoutRegisteredDate)
  }
  
  func checkNameValidation(_ previousName: String, _ name: String) -> Bool {
    let nameList = Set(self.workouts.map { $0.displayName() }.filter{ $0 != previousName })
    return !nameList.contains(name)
  }
  
  func filteredWorkout(by bodySection: BodySection) -> [Workout] {
    let filteredList = workouts.filter { workout in
      workout.bodySection == bodySection
    }
    
    return filteredList
  }
  
  func searchWorkouts(by text: String) -> [Workout] {
    let filteredList = workouts.filter { workout in
      workout.displayName().localizedCaseInsensitiveContains(text)
    }
    
    return filteredList
  }
  
  func totalWorkoutsCount() -> Int {
    return workouts.count
  }
}
extension WorkoutManager: WorkoutDelegate {
  func childAdded(_ workout: Workout) {
    guard let workoutId = workout.id else { return }
    workoutCodeDictionary[workoutId] = workout
    
    self.workoutViewDelegate?.workoutAdded()
  }
  
  func childRemoved(_ workoutId: String) {
    guard let removingWorkout = workoutCodeDictionary[workoutId] else { return }
    removingWorkout.removeRegisteredRoutine()
    
    workoutCodeDictionary[workoutId] = nil
    
    guard let targetIndexPath = targetIndexPath else { return }
    self.workoutViewDelegate?.workoutRemoved(at: targetIndexPath)
    
    self.targetIndexPath = nil
  }
  
  func childChanged(_ workoutId: String, _ workout: Workout) {
    workoutCodeDictionary[workoutId] = workout
    
    self.workoutViewDelegate?.workoutChanged()
  }
}

let workoutManager = WorkoutManager.shared
