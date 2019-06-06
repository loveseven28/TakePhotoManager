//
//  Date-Helper.swift
//  PhucLocTho
//
//  Created by Mac Mini on 4/16/18.
//  Copyright © 2018 Mac Mini. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfBetweenTwoDate(date:Date) -> Bool{
        
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        if components.day == 0 {
            return true
        }
        return false
    }
    
    func isTodayString(date:Date)-> String {
        
        if self.dayOfBetweenTwoDate(date: date) {
            return "Hôm nay"
        }
        return date.stringWithFormat(format: "dd/MM/yyyy")
    }
    
    func timeString() -> String {
        return self.stringWithFormat(format: "hh:mm")
    }
    
    func toString() -> String {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return "Ngày \(day) tháng \(month) \(year)"
    }
    
    func stringWithFormat(format:String = "yyyy-MM-dd'T'HH:mm:ss.SSS") -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.string(from: self)
        
    }
    
}
