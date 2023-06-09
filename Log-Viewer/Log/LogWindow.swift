/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class LogWindow: NSWindow {
    
    convenience init(){
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - 800.0/2
            y = screen.frame.height/2 - 600.0/2
        }
        self.init(contentRect: NSMakeRect(x, y, 800.0, 600.0), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        title = "Title"
        tabbingMode = .preferred
    }
    
}

