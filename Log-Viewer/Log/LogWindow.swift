//
//  LogWindow.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa

class LogWindow: NSWindow, NSWindowDelegate {
    
    convenience init(){
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - Statics.startSize.width/2
            y = screen.frame.height/2 - Statics.startSize.height/2
        }
        self.init(contentRect: NSMakeRect(x, y, Statics.startSize.width, Statics.startSize.height), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        self.tabbingMode = .disallowed
        self.title = Statics.title
    }
    
    func note(_ string: String){
        print(string)
    }
    
}
