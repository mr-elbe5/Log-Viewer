//
//  AppDelegate.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        print("will launch")
        let _ = LogDocumentController()
        NSColorPanel.setPickerMode(.wheel)
        NSColorPanel.setPickerMask(.wheelModeMask)
        NSColorPanel.shared.showsAlpha = false
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Preferences.load()
        print("did launch")
        if Preferences.shared.showSplash{
            let splashController = SplashWindowController()
            splashController.window!.center()
            NSApp.runModal(for: splashController.window!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        Preferences.shared.save()
    }

    @IBAction func openPreferences(_ sender: Any) {
        openGlobalPreferences()
    }
    
    @IBAction func openHelp(_ sender: Any) {
        if let doc = NSDocumentController.shared.currentDocument as? LogDocument{
            doc.windowController.openHelp()
        }
    }
    
    @objc func openGlobalPreferences() {
        let controller = GlobalPreferencesWindowController()
        controller.presentingWindow = nil
        NSApp.runModal(for: controller.window!)
    }
    
}

