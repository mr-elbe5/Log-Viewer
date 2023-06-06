/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class PopupWindow: NSWindow {

    var parentFrame : NSRect? = nil

    // positions itself centered in frame of calling window
    override func center() {
        if let frame = parentFrame{
            let ownPosition = self.frame
            let newTopLeft = NSMakePoint(frame.minX + frame.width/2 - ownPosition.width/2, frame.minY + frame.height/2 + ownPosition.height/2)
            self.setFrameTopLeftPoint(newTopLeft)
            return
        }
        super.center()
    }
    
}
