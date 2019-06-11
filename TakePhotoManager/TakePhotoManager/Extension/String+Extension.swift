//
//  String+Extension.swift
//  ChubbLife
//
//  Created by MacMini_1 on 8/2/18.
//  Copyright © 2018 MacMini_1. All rights reserved.
//

import UIKit
import AVFoundation
//MARK: make a call
extension String {
    func validEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func convertToUrl() -> URL? {
        return URL(string: self) 
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
	
	var forSorting: String {
		let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
		let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
		return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
	}

//SEARCH LOCAL
//    let array = dataSourceCopy.filter( {
//       let item = $0.fullName
//       return item.lowercased().trim().forSorting.contains(searchText.lowercased().trim().forSorting)
//    })
    
    func smartContains(_ other: String) -> Bool {
        let array : [String] = other.lowercased().components(separatedBy: " ").filter { !$0.isEmpty }
        return array.reduce(true) { !$0 ? false : (self.lowercased().range(of: $1) != nil ) }
    }
    
    //MARK: String to date
    func convertStringToDate(format: String = "yyyy-MM-dd HH:mm:ss.zzz") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: self) //according to date format your date string
        return date
    }

    func convertStringToDateWithTimeZone(format: String, timeZone: String = "GMT+0:00") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone) //Current time zone
        let date = dateFormatter.date(from: self) //according to date format your date string
        return date
    }
    
}


//MARK: Number of string
extension String {
    func numberOfString() -> Int {
        let stringArray = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Int(item) {
                return number
            }
        }
        return 0
    }
}

extension Date {
    func stringWithFormat(formatString:String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
}

//MARK: convert html to string
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    
    static func formatStringTime(_ curTime: CMTime, durTime : CMTime) -> String {
        let secondOneHour = 3600.0
        let secondTenMinutes = 600.0
        var isGreaterOneHour = false
        var isGreaterTenMinutes = false
        var result = "0:00"
        var minusFlag = false
        var durSecond = durTime.getSeconds()
        var curSecond = floorf(Float(curTime.getSeconds()))
        if durSecond < 0 {
            durSecond = -durSecond
        }
        if curSecond < 0 {
            minusFlag = true
            curSecond = -curSecond
        }
        let hours = Int(curSecond / 3600.0)
        let mins = Int((curSecond - Float(hours * 3600)) / 60.0)
        let theSecs = Int(curSecond + 0.0001) % 60
        if durSecond > secondOneHour{
            isGreaterOneHour = true
        }else{
            if durSecond > secondTenMinutes {
                isGreaterTenMinutes = true
            }
        }
        if isGreaterOneHour{
            result = String(format: "%@%i:%.2i:%.2i", minusFlag ? "-" : "", hours,mins,theSecs)
        }
        if isGreaterTenMinutes{
            result = String(format: "%@%.2i:%.2i", minusFlag ? "-" : "",mins,theSecs)
        }else{
            if !isGreaterOneHour && !isGreaterTenMinutes{
                result = String(format: "%@%i:%.2i", minusFlag ? "-" : "",mins,theSecs)
            }
        }
        return result
    }
}

extension CMTime {
    func getSeconds() -> Float64 {
        guard CMTIME_IS_VALID(self) else { return 0 }
        guard !CMTIME_IS_INDEFINITE(self) else { return 0 }
        return CMTimeGetSeconds(self)
    }
}

//MARK: time lapse
extension String {
    func checkIsNew(_ date: Date, currentDate: Date) -> Bool {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 1) {
            return false
        }
        
        if (components.month! >= 1) {
            return false
        }
        
        if (components.weekOfYear! >= 1) {
            return false
        }
        
        if (components.day! <= 3) {
            return true
        }
        
        return false
    }
    
    func timeAgoSinceDate(_ date: Date, currentDate: Date = Date(), numericDates: Bool = true) -> String {
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .weekday, .month, .year], from: date, to: currentDate)
        let componentsTime = Calendar.current.dateComponents([.hour, .minute], from: date)
        let timeDisplay = String(format: "%02d:%02d", componentsTime.hour!, componentsTime.minute!)
        if (components.year! >= 2) {
            return "\(components.year!) năm trước"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 năm trước"
            } else {
                return "Năm trước"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) tháng trước"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 tháng trước lúc \(timeDisplay)"
            } else {
                return "Tháng trước lúc \(timeDisplay)"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) tuần trước lúc \(timeDisplay)"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 tuần trước lúc \(timeDisplay)"
            } else {
                return "tuần trước lúc \(timeDisplay)"
            }
        } else if (components.day! >= 2) {
            if (components.day! >= 7) {
                return "\(components.day!) tháng \(components.month!) lúc \(timeDisplay)"
            } else {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "EEEE"
                let locate = Locale(identifier: "vi_VN")
                dateFormater.locale = locate
                let temp = dateFormater.string(from: date)
                return "\(temp) lúc \(timeDisplay)"
            }
        } else if (components.day! >= 1){
            if (numericDates) {
                return "1 ngày lúc \(timeDisplay)"
            } else {
                return "Hôm qua lúc \(timeDisplay)"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) giờ " + (components.minute! > 0 ?  "\(components.minute!) phút trước" : "trước")
        } else if (components.hour! >= 1){
            if (numericDates) {
                return "1 giờ \(String(format: "%02d", components.minute!)) phút trước"
            } else {
                return "Một giờ \(String(format: "%02d", components.minute!)) phút trước"
            }
        } else if (components.minute! >= 2) {
            return "\(String(format: "%02d", components.minute!)) phút trước"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 phút trước"
            } else {
                return "Một phút trước"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) giây"
        } else {
            return "Vừa mới đây"
        }
        
    }
    
    func getYearDataSource(minYear: Int) -> String {
        var dataYear = ""
        let year = Calendar.current.component(.year, from: Date())
        for i in minYear...year {
            if i == year {
                dataYear += "\(i)"
            } else {
                dataYear += "\(i);"
            }
        }
        
        return dataYear
    }
    
}

//MARK: Make a call
extension String {
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isPhoneNumber() -> Bool {
        return isValid(regex: .phone)
    }
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() -> Bool {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:]) { (status) in
                        print(status)
                    }
                } else {
                    UIApplication.shared.openURL(url)
                    print(self)
                }
                return true
            }
            
            return false
        }
        
        return false
    }
}

//MARK: Get word first
extension String {
    
    var byWords: [String] {
        var byWords:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            print($1,$2,$3)
            byWords.append(word)
        }
        return byWords
    }
    func firstWords(_ max: Int) -> [String] {
        return Array(byWords.prefix(max))
    }
    var firstWord: String {
        return byWords.first ?? ""
    }
    func lastWords(_ max: Int) -> [String] {
        return Array(byWords.suffix(max))
    }
    var lastWord: String {
        return byWords.last ?? ""
    }
}


//MARK: size pf string
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
