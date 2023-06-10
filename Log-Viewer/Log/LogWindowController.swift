/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class LogWindowController: NSWindowController, NSWindowDelegate {
    
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
    let toolbarItemOpen = NSToolbarItem.Identifier("ToolbarOpenItem")
    let toolbarItemClear = NSToolbarItem.Identifier("ToolbarClearItem")
    let toolbarItemReload = NSToolbarItem.Identifier("ToolbarReloadItem")
    let toolbarItemStart = NSToolbarItem.Identifier("ToolbarStartItem")
    let toolbarItemPause = NSToolbarItem.Identifier("ToolbarPauseItem")
    let toolbarItemGlobalPreferences = NSToolbarItem.Identifier("ToolbarGlobalPreferencesItem")
    let toolbarItemDocumentPreferences = NSToolbarItem.Identifier("ToolbarDocumentPreferencesItem")
    let toolbarItemStore = NSToolbarItem.Identifier("ToolbarStoreItem")
    let toolbarItemHelp = NSToolbarItem.Identifier("ToolbarHelpItem")

    var delegate : TabbedLogWindowsDelegate? = nil
    
    var logDocument : LogDocument
    var logViewController : LogViewController {
        get{
            contentViewController as! LogViewController
        }
    }

    // Window delegate
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    override public func newWindowForTab(_ sender: Any?) {
        let window = NSWindow()
        window.delegate = self
        window.windowController = self
        contentViewController = LogViewController()
        self.window!.addTabbedWindow(window, ordered: .above)
    }
    
    init(document: LogDocument){
        logDocument = document
        let window = NSWindow(contentRect: LogWindowPool.shared.frameRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        window.title = "Log-Viewer"
        window.tabbingMode = GlobalPreferences.shared.useTabs ? .preferred : .automatic
        super.init(window: window)
        self.window?.delegate = self
        addToolbar()
        setupViewController()
        if GlobalPreferences.shared.rememberWindowFrame{
            self.window?.setFrameUsingName(logDocument.preferences.id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewController(){
        let viewController = LogViewController()
        viewController.logDocument = logDocument
        contentViewController = viewController
        logViewController.updateFromDocument()
    }
    
    func windowWillClose(_ notification: Notification) {
        logDocument.releaseLogSource()
        if GlobalPreferences.shared.rememberWindowFrame{
            window?.saveFrame(usingName: logDocument.preferences.id)
        }
    }
    
    // Window delegate
    
    func windowDidBecomeKey(_ notification: Notification) {
        updateStartPause()
    }
    
}

