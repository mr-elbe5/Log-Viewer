//
//  AppDelegate.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let _ = LogDocumentController()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Preferences.load()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Preferences.shared.save()
    }

    @IBAction func openPreferences(_ sender: Any) {
        if let doc = NSDocumentController.shared.currentDocument as? LogDocument{
            doc.windowController.openPreferences()
        }
    }
    
    @IBAction func openHelp(_ sender: Any) {
        if let doc = NSDocumentController.shared.currentDocument as? LogDocument{
            doc.windowController.openHelp()
        }
    }
    
    
}

