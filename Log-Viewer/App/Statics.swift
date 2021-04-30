//
//  Statics.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Foundation

class Statics{
    
    static var title = "Log-Viewer"
    
    static var startSize = NSMakeSize(900, 600)
    
    static var isDarkMode : Bool{
        get{
            return UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        }
    }
    
}
