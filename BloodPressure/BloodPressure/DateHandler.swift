//
//  DateHandler.swift
//  BloodPressure
//
//  Created by Jorge-Alberto Reich on 21.11.21.
//

import Foundation

extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)

    }
}

class DateModel{
    
    var date1 : Date
    var date2 : Date
    
    var startDate:Date {
        get{
            date1
        }
        set(newValue){
            date1 = toLocalTime(date: newValue)
        }
        
    }
    
    
    var endDate:Date {
        get{
            date2
        }
        set(newValue){
            date2 = addOneDay(date: toLocalTime(date: newValue))
        }
        
    }
    
    init(){
        date1 = Date.now
        date2 = Date.now
    }
    
    //Customize time zone
    func toLocalTime(date : Date) -> Date {
    
        //Selection of the current calendar
        let calendar = Calendar.current
        
        //Time zone selection
        let timezone = TimeZone.current
        
        //Determine number of seconds between time zone and GMT
        let seconds = TimeInterval(timezone.secondsFromGMT(for: date))
        
        //Adjusting the input value
        let newDate = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: date)
        let dateLocalTimezone = Date(timeInterval: seconds, since: newDate!)

        return dateLocalTimezone
    }
    
    //Function to add a day
    func addOneDay(date : Date) -> Date {

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
        return tomorrow!
    
    }

}
