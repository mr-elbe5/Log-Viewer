//
//  HelpWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 10.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class HelpWindowController: NSWindowController, NSWindowDelegate {

    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 270), styleMask: [.closable, .miniaturizable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Help"
        super.init(window: window)
        self.window?.delegate = self
        let controller = HelpViewController()
        contentViewController = controller
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }

}
