//
//  LogWindow.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 09.06.23.
//

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

