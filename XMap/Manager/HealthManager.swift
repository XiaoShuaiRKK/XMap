//
//  HealtchManager.swift
//  XMapWidgetExtension
//
//  Created by Xiao Shuai on 2025/1/13.
//

import Foundation
import HealthKit

class HealthManager {
    private let healthStore = HKHealthStore()
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    private let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
    
    init() {
        print("health manager init")
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        let allTypes: Set = [stepType, distanceType]
        healthStore.requestAuthorization(toShare: nil, read: allTypes) { success, error in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
            } else if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }
    
    func fetchTodayStepsAndDistance(completion: @escaping (Int, Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let stepsQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            let stepsInt = Int(steps)
            
            let distanceQuery = HKStatisticsQuery(quantityType: self.distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                let distanceKm = distance / 1000.0
                completion(stepsInt, distanceKm)
            }
            self.healthStore.execute(distanceQuery)
        }
        
        healthStore.execute(stepsQuery)
    }
}
