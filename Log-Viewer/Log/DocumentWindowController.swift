/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

protocol DocumentWindowDelegate{
    func openDocument(sender: DocumentWindowController?)
    func newWindowForTab(from: DocumentWindowController)
}

class DocumentWindowController: NSWindowController {
    
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

    var delegate : DocumentWindowDelegate? = nil
    
    var logDocument : LogDocument
    
    var documentViewController : DocumentViewController {
        get{
            contentViewController as! DocumentViewController
        }
    }
    
    init(document: LogDocument){
        logDocument = document
        let window = NSWindow(contentRect: LogDocumentPool.shared.frameRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
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
        let viewController = DocumentViewController(logDocument: logDocument)
        contentViewController = viewController
        DispatchQueue.main.async{
            self.logDocument.load()
            self.documentViewController.updateFromDocument()
        }
    }
    
}

extension DocumentWindowController: NSWindowDelegate{
    
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

