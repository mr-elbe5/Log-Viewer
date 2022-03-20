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
        NSColorPanel.setPickerMode(.wheel)
        NSColorPanel.setPickerMask(.wheelModeMask)
        NSColorPanel.shared.showsAlpha = false
        GlobalPreferences.load()
        GlobalPreferences.shared.save() // if defaults have been used
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }
    
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool{
        if let url = LogDocumentController.sharedController.showSelectDialog(){
            LogDocumentController.sharedController.openDocument(withContentsOf: url, display: true){ doc, wasOpen, error in
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        return false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        GlobalPreferences.shared.save()
    }

    @IBAction func openPreferences(_ sender: Any) {
        openGlobalPreferences()
    }
    
    @IBAction func openHelp(_ sender: Any) {
        if let doc = NSDocumentController.shared.currentDocument as? LogDocument{
            doc.windowController?.openHelp()
        }
    }
    
    @objc func openGlobalPreferences() {
        let controller = GlobalPreferencesWindowController()
        controller.window?.center()
        NSApp.runModal(for: controller.window!)
    }
    
}

