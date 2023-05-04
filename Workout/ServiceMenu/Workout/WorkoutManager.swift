//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation

protocol WorkoutViewDelegate: AnyObject {
  func workoutAdded()
}

class WorkoutManager {
  static let shared = WorkoutManager()
  
  private let networkConnecter = WorkoutNetworkConnecter()
  private var workouts = [Workout]()
  private var workoutCodeDictionary = [String : Workout]()
  
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
      self.networkConnecter.updateWorkoutData(workout: workout, key: key)
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
  
  func removeWorkout(_ workout: Workout) {
    if let removingCode = workout.id {
      workoutCodeDictionary[removingCode] = nil
      workout.removeRegisteredRoutine()
      networkConnecter.removeWorkoutData(workout: workout)
    }
    
    // 아직 workouts 배열에선 workout 제거 안됨, 수정 필요
  }
  
  func updateWorkout(_ code: String, _ name: String, _ weightUnit: WeightUnit, _ bodySection: BodySection) {
    guard let updatingWorkout = workoutByCode(code) else { return }
    updatingWorkout.update(name, bodySection, weightUnit)
    networkConnecter.updateWorkoutData(workout: updatingWorkout, key: code)
  }
  
  func updateWorkoutRegistration(_ code: String, _ registeredDate: Set<DateInformation>) {
    networkConnecter.updateWorkoutRegistrationDate(code: code, date: registeredDate)
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
    guard let id = workout.id else { return }
    workoutCodeDictionary[id] = workout
    workouts.append(workout)
    self.workoutViewDelegate?.workoutAdded()
  }
}

let workoutManager = WorkoutManager.shared
