//
//  SplashWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 27.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class SplashWindowController: NSWindowController, NSWindowDelegate {
    
    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 100), styleMask: [.closable, .miniaturizable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Log-Viewer - Open file"
        super.init(window: window)
        self.window?.delegate = self
        let controller = SplashViewController()
        contentViewController = controller
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.orderFront(nil)
    }

    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }

}
