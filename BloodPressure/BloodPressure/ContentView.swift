//
//  ContentView.swift
//  BloodPressure
//
//  Created by Jorge-Alberto Reich on 21.11.21.
//

import SwiftUI

//extension Date {
//
//    func toString(format: String = "yyyy-MM-dd") -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//
//    }
//}

struct ContentView: View {
    
    @State var date1 = Date.now
    @State var date2 = Date.now
    
    @State var systolic : String = "--"
    @State var diastolic : String = "--"

//    @ObservedObject var dateModel = DateModel()
    var dateModel = DateModel()
    var healthStore = HealthStore()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {

        NavigationView{

            Form{
                
                Section{
                    
                    DatePicker("start date", selection: $date1, displayedComponents: [.date])
                    DatePicker("final date", selection: $date2, displayedComponents: [.date])
   
                    
                } header: {
                    Text("dates")
                } footer: {
                    Text("choose dates")
                }
                
                Section{
                    
                    VStack {
                        Text("\(date1, formatter: dateFormatter) - \(date2, formatter: dateFormatter)")
                            .bold()
                        Divider()
                        Text ("\(systolic) / \(diastolic) ")
                            .bold()
                    }
                } header: {
                    Text("Blood Pressure")
                }
                
                
                
                Section {
                    
                    Button(action: {
                        
                        if date1 > date2 {
                            date1 = date2
                        }

                        dateModel.startDate = date1
                        dateModel.endDate = date2
                        
//                        print(dateModel.startDate)
//                        print(dateModel.endDate)

                        healthStore.calculateBloodPressureSystolicTest(startDate: dateModel.startDate, endDate: dateModel.endDate)
                        
                        healthStore.calculateBloodPressureDiastolicTest(startDate: dateModel.startDate, endDate: dateModel.endDate)
                        
                        systolic = "\(healthStore.systolicValue!)"
                        diastolic = "\(healthStore.diastolicValue!)"
                        
                    }) {
                        Text("calc blood pressure average")
                    }

                }
                
            }
            .navigationBarTitle("Blood Pressure Average")
            .onAppear {
                healthStore.setUpHealthStore()
            }
            
        }

    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
