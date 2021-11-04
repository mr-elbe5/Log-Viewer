//
//  PreferencesWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa


class GlobalPreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 390), styleMask: [.closable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Global Preferences"
        super.init(window: window)
        self.window?.delegate = self
        let controller = GlobalPreferencesViewController()
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
