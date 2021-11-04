/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

extension NSWindowController{
    
    convenience init(frameRect: CGRect = CGRect(), styleMask: NSWindow.StyleMask = [.titled, .closable, .resizable, .miniaturizable]){
        let window = NSWindow(
            contentRect: frameRect,
            styleMask: styleMask,
            backing: .buffered,
            defer: false)
        self.init(window: window)
        setup()
    }
    
    @objc func setup(){
        //overridable for init
    }
    
    func centerInWindow(outerWindow: NSWindow?){
        if let win = outerWindow{
            let outerFrame = win.frame
            if let ownPosition = window?.frame{
                let newTopLeft = NSMakePoint(outerFrame.minX + outerFrame.width/2 - ownPosition.width/2, outerFrame.minY + outerFrame.height/2 + ownPosition.height/2)
                window?.setFrameTopLeftPoint(newTopLeft)
            }
        }
        else{
            window?.center()
        }
    }
    
}
