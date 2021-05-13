//
//  DocumentPreferencesWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 29.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class DocumentPreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    var logDocument : LogDocument
    
    var observer : NSKeyValueObservation? = nil
    
    init(log: LogDocument){
        self.logDocument = log
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 290), styleMask: [.closable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Document Preferences"
        super.init(window: window)
        self.window?.delegate = self
        let controller = DocumentPreferencesViewController()
        controller.logDocument = self.logDocument
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
