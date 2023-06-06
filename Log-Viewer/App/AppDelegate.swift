/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

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

