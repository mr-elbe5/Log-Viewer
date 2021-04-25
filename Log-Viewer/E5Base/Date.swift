//
//  Date.swift
//  tomcatctrl
//
//  Created by Michael Rönnau on 30.11.20.
//

import Foundation

extension Date{
    
    func startOfDay() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal.startOfDay(for: self)
    }
    
    func startOfMonth() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let components = cal .dateComponents([.month, .year], from: self)
        return cal.date(from: components)!
    }
    
    func dateString() -> String{
        return DateFormats.dateOnlyFormatter.string(from: self)
    }
    
    func dateTimeString() -> String{
        return DateFormats.dateTimeFormatter.string(from: self)
    }
    
    func fileDate() -> String{
        return DateFormats.fileDateFormatter.string(from: self)
    }
    
    func timeString() -> String{
        return DateFormats.timeOnlyFormatter.string(from: self)
    }
    
}

extension Date {
 
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

class DateFormats{
    
    static var dateOnlyFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter
        }
    }
    
    static var timeOnlyFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return dateFormatter
        }
    }
    
    static var dateTimeFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter
        }
    }
    
    static var fileDateFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .none
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            return dateFormatter
        }
    }
    
}
