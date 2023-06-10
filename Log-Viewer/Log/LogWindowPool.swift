/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa


class LogWindowPool: NSObject, Codable {
    
    static var defaultSize: NSSize = NSMakeSize(900, 600)
    static var defaultRect: NSRect{
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - defaultSize.width/2
            y = screen.frame.height/2 - defaultSize.height/2
        }
        return NSMakeRect(x, y, LogWindowPool.defaultSize.width, LogWindowPool.defaultSize.height)
    }
    
    static var shared = LogWindowPool()
    
    static func loadAppState(){
        if let storedString = UserDefaults.standard.value(forKey: "appState") as? String {
            if let state : LogWindowPool = LogWindowPool.fromJSON(encoded: storedString){
                LogWindowPool.shared = state
            }
        }
        else{
            print("no saved data available for app state")
            LogWindowPool.shared = LogWindowPool()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case frameRect
        case logHistory
    }
    
    var frameRect: NSRect
    var logHistory = Array<LogDescriptor>()
    
    var logWindows = Array<LogWindowController>()
    
    override init(){
        frameRect = LogWindowPool.defaultRect
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        frameRect = try values.decodeIfPresent(NSRect.self, forKey: .frameRect) ?? LogWindowPool.defaultRect
        logHistory = try values.decodeIfPresent(Array<LogDescriptor>.self, forKey: .logHistory) ?? Array<LogDescriptor>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frameRect, forKey: .frameRect)
        try container.encode(logHistory, forKey: .logHistory)
    }
    
    func save(){
        let storeString = toJSON()
        UserDefaults.standard.set(storeString, forKey: "appState")
    }
    
}
