/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

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
        DateFormats.dateOnlyFormatter.string(from: self)
    }
    
    func dateTimeString() -> String{
        DateFormats.dateTimeFormatter.string(from: self)
    }
    
    func fileDate() -> String{
        DateFormats.fileDateFormatter.string(from: self)
    }
    
    func timeString() -> String{
        DateFormats.timeOnlyFormatter.string(from: self)
    }
    
    func longTimeString() -> String{
        DateFormats.longTimeFormatter.string(from: self)
    }
    
}

extension Date {
 
    var millisecondsSince1970:Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
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
    
    static var longTimeFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
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

