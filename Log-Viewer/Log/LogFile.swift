/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class LogFile: NSObject, PreferencesDelegate{
    
    var preferences =  DocumentPreferences()
    
    var windowController : LogWindowController? = nil
    
    var viewController : LogViewController?{
        get{
            windowController?.documentViewController
        }
    }
    
    var chunks = [LogChunk]()
    
    deinit {
        releaseLogSource()
    }
    
    func releaseLogSource(){
    }
    
    func load(){
        
    }
    
    func savePreferences(){
        GlobalPreferences.shared.save()
    }

    func preferencesChanged(){
        viewController?.reset()
        for chunk in chunks{
            chunk.displayed = false
        }
        viewController?.updateFromDocument()
    }

    func markPatternChanged(){
        viewController?.reset()
        for chunk in chunks{
            chunk.displayed = false
        }
    }
      

}

class LogChunk{
    
    var string : String
    var displayed : Bool = false
    
    init(_ string: String){
        self.string = string
    }
    
}
