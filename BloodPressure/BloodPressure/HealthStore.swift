//
//  HealthStore.swift
//  BloodPressureV4
//
//  Created by Jorge-Alberto Reich on 24.05.21.
//

import Foundation
import HealthKit

class HealthStore {

    var healthStore: HKHealthStore?
    var query: HKStatisticsQuery?
    
    //https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject
    
    
    @Published var systolicValue: HKQuantity?
    @Published var diastolicValue: HKQuantity?

    init() {
        
        if HKHealthStore.isHealthDataAvailable() {
            print("HealthStore ok")
            healthStore = HKHealthStore()
        }
    }

    func setUpHealthStore() {
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        ]

        healthStore?.requestAuthorization(toShare: nil, read: typesToRead, completion: { success, error in
            if success {
                print("requestAuthrization")
                self.calculateBloodPressureSystolic()
                self.calculateBloodPressureDiastolic()
            }
        })

    }

    func calculateBloodPressureSystolic() {
        guard let bloodPressureSystolic = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) else {
                    // This should never fail when using a defined constant.
                    fatalError("*** Unable to get the bloodPressure count ***")
        }
        query = HKStatisticsQuery(quantityType: bloodPressureSystolic,
                                  quantitySamplePredicate: nil,
                                  options: .discreteAverage) {
            query, statistics, error in

            DispatchQueue.main.async{
                self.systolicValue = statistics?.averageQuantity()
            }
        }

        healthStore!.execute(query!)
    }
    
    func calculateBloodPressureDiastolic() {
        guard let bloodPressureDiastolic = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the bloodPressure count ***")
        }
        query = HKStatisticsQuery(quantityType: bloodPressureDiastolic,
                                  quantitySamplePredicate: nil,
                                  options: .discreteAverage) {
            query, statistics, error in

            DispatchQueue.main.async{
                self.diastolicValue = statistics?.averageQuantity()
            }
        }

        healthStore!.execute(query!)
    }
    
    func calculateBloodPressureDiastolicTest(startDate : Date, endDate : Date) {
        guard let bloodPressureDiastolic = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the bloodPressure count ***")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        query = HKStatisticsQuery(quantityType: bloodPressureDiastolic,
                                  quantitySamplePredicate: predicate,
                                  options: .discreteAverage) {
            query, statistics, error in

            DispatchQueue.main.async{
                
                self.diastolicValue = statistics?.averageQuantity()
//                print(self.diastolicValue)
            }
        }

        healthStore!.execute(query!)
    }
    
    func calculateBloodPressureSystolicTest(startDate : Date, endDate : Date) {
        
        print("calcSystolic")
        guard let bloodPressureSystolic = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic) else {
                    // This should never fail when using a defined constant.
                    fatalError("*** Unable to get the bloodPressure count ***")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        query = HKStatisticsQuery(quantityType: bloodPressureSystolic,
                                  quantitySamplePredicate: predicate,
                                  options: .discreteAverage) {
            query, statistics, error in

            DispatchQueue.main.async{
                
                self.systolicValue = statistics?.averageQuantity()
//                print(self.systolicValue)
            }
        }

        healthStore!.execute(query!)
    }
}

