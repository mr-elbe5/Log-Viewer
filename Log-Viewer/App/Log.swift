/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class Log{
    
    private static var logString = ""
    
    private static func log(_ str: String){
        print(Date.now.longTimeString() + " " + str)
        logString += str + "\n"
    }

    static func debug(_ msg: String){
        log("debug: \(msg)")
    }

    static func info(_ msg: String){
        log("info: \(msg)")
    }

    static func warn(_ msg: String){
        log("warn: \(msg)")
    }

    static func error(_ msg: String){
        log("error: \(msg)")
    }

    static func error(_ msg: String, error: Error){
        log("error: \(msg): \(error.localizedDescription)")
    }

    static func error(error: Error){
        log("error: \(error.localizedDescription)")
    }

    static func error(msg: String, error: Error){
        log("error: \(msg): \(error.localizedDescription)")
    }
    
}
