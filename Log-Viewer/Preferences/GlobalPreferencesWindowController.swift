//
//  PreferencesWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class GlobalPreferencesWindowController: PopupWindowController {
    
    override func loadWindow() {
        let window = popupWindow()
        window.title = "Global Preferences"
        window.delegate = self
        let controller = GlobalPreferencesViewController()
        contentViewController = controller
        self.window = window
    }

    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }

}
