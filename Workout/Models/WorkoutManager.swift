//
//  WorkoutManager.swift
//  Workout
//
//  Created by 강인희 on 2021/12/07.
//

import Foundation

class WorkoutManager {
  static let shared = WorkoutManager()
  
  private let networkConnecter = WorkoutNetworkConnecter()
  private var workoutCodeDictionary = [String: Workout]()
  
  private init() { }
  
  func readWorkoutData() {
    networkConnecter.fetchWorkoutData { workoutDictionary, error in
      if let error = error {
        NotificationCenter.default.post(name: Notification.Name("ReadWorkoutData"), object: nil, userInfo: ["error" : error])
        return
      }
      
      if let workoutDictionary = workoutDictionary {
        self.workoutCodeDictionary = workoutDictionary
      }
      
      for element in self.workoutCodeDictionary {
        element.value.configureId(with: element.key)
      }
    }
  }
  
  func numberOfWorkoutList() -> Int {
    return workoutCodeDictionary.count
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
  }
  
  func updateWorkout(_ code: String, _ name: String, _ weightUnit: WeightUnit, _ bodySection: BodySection) {
    guard let updatingWorkout = workoutCodeDictionary[code] else { return }
    updatingWorkout.update(name, bodySection, weightUnit)
    networkConnecter.updateWorkoutData(workout: updatingWorkout, key: code)
  }
  
  func updateWorkoutRegistration(_ code: String, _ registeredDate: Set<DateInformation>) {
    networkConnecter.updateWorkoutRegistrationDate(code: code, date: registeredDate)
  }
  
  func checkNameValidation(_ previousName: String, _ name: String) -> Bool {
    let nameList = Set(self.workoutCodeDictionary.values.map { $0.displayName() }.filter{ $0 != previousName })
    return !nameList.contains(name)
  }
  
  func filteredWorkout(by bodySection: BodySection) -> [Workout] {
    let filteredList = workoutCodeDictionary.values.filter { workout in
      workout.bodySection == bodySection
    }

    return filteredList
  }
  
  func searchWorkouts(by text: String) -> [Workout] {
    let filteredList = workoutCodeDictionary.values.filter { workout in
      workout.displayName().localizedCaseInsensitiveContains(text)
    }
    
    return filteredList
  }
  
  func totalWorkoutsCount() -> Int {
    return workoutCodeDictionary.count
  }
}

let workoutManager = WorkoutManager.shared
