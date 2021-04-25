//
//  PreferencesWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa

class PreferencesWindowController: PopupWindowController, NSWindowDelegate {
    
    var logDocument : LogDocument? = nil
    
    var observer : NSKeyValueObservation? = nil
    
    convenience init() {
        self.init(windowNibName: "")
    }
    
    override func loadWindow() {
        let window = popupWindow()
        window.title = "Preferences"
        window.delegate = self
        let controller = PreferencesViewController()
        controller.logDocument = self.logDocument
        contentViewController = controller
        self.window = window
        observer = NSApp.observe(\.effectiveAppearance){
            (app, _) in
            controller.appearanceChanged()
        }
    }

    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }

}
