/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

protocol LogWindowDelegate{
    func openDocument(sender: LogWindowController?)
    func newWindowForTab(from: LogWindowController)
}

class LogWindowController: NSWindowController {
    
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

    var delegate : LogWindowDelegate? = nil
    
    var logDocument : LogFile
    
    var documentViewController : LogViewController {
        get{
            contentViewController as! LogViewController
        }
    }
    
    init(document: LogFile){
        logDocument = document
        let window = NSWindow(contentRect: LogPool.defaultRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
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
        let viewController = LogViewController(logDocument: logDocument)
        contentViewController = viewController
        DispatchQueue.main.async{
            self.logDocument.load()
            self.documentViewController.updateFromDocument()
        }
    }
    
}

extension LogWindowController: NSWindowDelegate{
    
    func windowWillClose(_ notification: Notification) {
        if GlobalPreferences.shared.rememberWindowFrame{
            window?.saveFrame(usingName: logDocument.preferences.id)
        }
    }
    
    override public func newWindowForTab(_ sender: Any?) {
        delegate?.newWindowForTab(from: self)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        updateStartPause()
    }
}

