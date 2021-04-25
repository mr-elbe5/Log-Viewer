//
//  PopupWindow.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 10.12.20.
//

import Cocoa

class PopupWindow: NSWindow {
    
    var parentFrame : NSRect? = nil
    
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
