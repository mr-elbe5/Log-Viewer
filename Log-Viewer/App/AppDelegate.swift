/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        LogDocumentPool.loadDocumentPool()
        NSColorPanel.setPickerMode(.wheel)
        NSColorPanel.setPickerMask(.wheelModeMask)
        NSColorPanel.shared.showsAlpha = false
        GlobalPreferences.load()
        GlobalPreferences.shared.save() // if defaults have been used
        createMenu()
        Task{
            await Store.shared.load()
        }
        if LogDocumentPool.shared.documentWindowControllers.isEmpty{
            LogDocumentPool.shared.openDocument(sender: nil)
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        GlobalPreferences.shared.save()
    }
    
    func createMenu(){
        let mainMenu = NSMenu()
        
        let appMenu = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        appMenu.submenu = NSMenu(title: "")
        appMenu.submenu?.addItem(withTitle: "About Log-Viewer", action: #selector(openAbout), keyEquivalent: "n")
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(withTitle: "Global Preferences...", action: #selector(openGlobalPreferences), keyEquivalent: "p")
        appMenu.submenu?.addItem(withTitle: "Tip...", action: #selector(openStore), keyEquivalent: "")
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(withTitle: "Hide Me", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.submenu?.addItem({ () -> NSMenuItem in
            let m = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
            m.keyEquivalentModifierMask = [.command, .option]
            return m
        }())
        appMenu.submenu?.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.submenu?.addItem(NSMenuItem.separator())
        let appServicesMenu     = NSMenu()
        NSApp.servicesMenu      = appServicesMenu
        appMenu.submenu?.addItem(withTitle: "Services", action: nil, keyEquivalent: "").submenu = appServicesMenu
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(withTitle: "Quit Log-Viewer", action: #selector(quitApp), keyEquivalent: "q")
        
        let fileMenu = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        fileMenu.submenu = NSMenu(title: "File")
        fileMenu.submenu?.addItem(withTitle: "Open Log File...", action: #selector(openLogFile), keyEquivalent: "")
        fileMenu.submenu?.addItem(NSMenuItem.separator())
        fileMenu.submenu?.addItem(withTitle: "Close", action: #selector(closeFile), keyEquivalent: "w")
        
        let appWindowMenu     = NSMenu(title: "Window")
        NSApp.windowsMenu     = appWindowMenu
        let windowMenu = NSMenuItem(title: "Window", action: nil, keyEquivalent: "")
        windowMenu.submenu = appWindowMenu
        
        let helpMenu = NSMenuItem(title: "Help", action: nil, keyEquivalent: "")
        helpMenu.submenu = NSMenu(title: "Help")
        helpMenu.submenu?.addItem(withTitle: "Log-Viewer Help", action: #selector(openHelp), keyEquivalent: "o")
        
        
        mainMenu.addItem(appMenu)
        mainMenu.addItem(fileMenu)
        mainMenu.addItem(windowMenu)
        mainMenu.addItem(helpMenu)
        
        NSApp.mainMenu = mainMenu
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func openAbout() {
        NSApplication.shared.orderFrontStandardAboutPanel(nil)
    }
    
    @objc func openGlobalPreferences() {
        let controller = GlobalPreferencesWindowController()
        controller.window?.center()
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func openStore() {
        if Store.shared.loaded{
            let controller = StoreWindowController()
            controller.window?.center()
            NSApp.runModal(for: controller.window!)
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc func openLogFile() {
        LogDocumentPool.shared.openDocument(sender: nil)
    }
    
    @objc func closeFile() {
        
    }
    
    @objc func openHelp() {
        if let windowsController = LogDocumentPool.shared.mainWindowController{
            windowsController.openHelp()
        }
    }
    
}

