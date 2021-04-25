//
//  PopupWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 10.12.20.
//

import Cocoa

class PopupWindowController: NSWindowController {
    
    var presentingWindow : NSWindow? = nil
    
    func popupWindow() -> PopupWindow{
        let window = PopupWindow(
            contentRect: CGRect(),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false)
        window.parentFrame = presentingWindow?.frame
        return window
    }
    
}
