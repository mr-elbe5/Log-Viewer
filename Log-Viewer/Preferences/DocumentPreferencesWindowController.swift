//
//  DocumentPreferencesWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 29.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class DocumentPreferencesWindowController: PopupWindowController {
    
    var logDocument : LogDocument? = nil
    
    var observer : NSKeyValueObservation? = nil
    
    override func loadWindow() {
        let window = popupWindow()
        window.title = "Document Preferences"
        window.delegate = self
        let controller = DocumentPreferencesViewController()
        controller.logDocument = self.logDocument
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
