//
//  LogWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class LogWindowController: WindowController, NSToolbarDelegate {
    
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
    
    let toolbarItemStart = NSToolbarItem.Identifier("ToolbarStartItem")
    let toolbarItemPause = NSToolbarItem.Identifier("ToolbarPauseItem")
    let toolbarItemGlobalPreferences = NSToolbarItem.Identifier("ToolbarGlobalPreferencesItem")
    let toolbarItemDocumentPreferences = NSToolbarItem.Identifier("ToolbarDocumentPreferencesItem")
    let toolbarItemHelp = NSToolbarItem.Identifier("ToolbarHelpItem")
    
    var logDocument : LogDocument!
    var logViewController : LogViewController {
        get{
            return contentViewController as! LogViewController
        }
    }
    
    func setup(doc: LogDocument){
        self.logDocument = doc
        let viewController = LogViewController()
        viewController.logDocument = logDocument
        contentViewController = viewController
    }
    
    override func loadWindow() {
        let window = LogWindow()
        window.title = Statics.title
        window.delegate = self
        let toolbar = NSToolbar(identifier: self.mainWindowToolbarIdentifier)
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconAndLabel
        
        window.toolbar = toolbar
        window.toolbar?.validateVisibleItems()
        self.window = window
        logViewController.updateFromDocument()
    }
    
    func windowWillClose(_ notification: Notification) {
        logDocument.releaseEventSource()
    }
    
    // Window delegate
    
    func windowDidBecomeKey(_ notification: Notification) {
        window?.makeFirstResponder(nil)
    }
    
    // Toolbar Delegate
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
    {
        if  itemIdentifier == self.toolbarItemStart {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(start)
            toolbarItem.label = "Start Logging"
            toolbarItem.paletteLabel = "Start Logging"
            toolbarItem.toolTip = "Start following the log file"
            toolbarItem.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemPause {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(pause)
            toolbarItem.label = "Pause Logging"
            toolbarItem.paletteLabel = "Pause Logging"
            toolbarItem.toolTip = "Pause following the log file"
            toolbarItem.image = NSImage(systemSymbolName: "pause.circle", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemGlobalPreferences {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openGlobalPreferences)
            toolbarItem.label = "Global Preferences"
            toolbarItem.paletteLabel = "Global Preferences"
            toolbarItem.toolTip = "Set global preferences and colors"
            toolbarItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemDocumentPreferences {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openDocumentPreferences)
            toolbarItem.label = "Document Preferences"
            toolbarItem.paletteLabel = "Document Preferences"
            toolbarItem.toolTip = "Set document log preferences"
            toolbarItem.image = NSImage(systemSymbolName: "doc.badge.gearshape", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemHelp {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openHelp)
            toolbarItem.label = "Help"
            toolbarItem.paletteLabel = "Help"
            toolbarItem.toolTip = "Help"
            toolbarItem.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "")
            return toolbarItem
        }
    
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        return [
            self.toolbarItemPause,
            self.toolbarItemGlobalPreferences,
            self.toolbarItemDocumentPreferences,
            self.toolbarItemHelp
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        return [self.toolbarItemStart,
                self.toolbarItemPause,
                self.toolbarItemGlobalPreferences,
                self.toolbarItemDocumentPreferences,
                self.toolbarItemHelp,
                NSToolbarItem.Identifier.space,
                NSToolbarItem.Identifier.flexibleSpace]
    }
    
    @objc func openGlobalPreferences() {
        let controller = GlobalPreferencesWindowController()
        controller.presentingWindow = self.window
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func openDocumentPreferences() {
        let controller = DocumentPreferencesWindowController()
        controller.presentingWindow = self.window
        controller.logDocument = logDocument
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func openHelp() {
        let controller = HelpWindowController()
        controller.presentingWindow = self.window
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func start() {
        logViewController.follow = true
        logViewController.updateFromDocument()
        if let toolbar = window?.toolbar{
            toolbar.removeItem(at: 0)
            toolbar.insertItem(withItemIdentifier: toolbarItemPause, at: 0)
        }
    }
    
    @objc func pause() {
        logViewController.follow = false
        if let toolbar = window?.toolbar{
            toolbar.removeItem(at: 0)
            toolbar.insertItem(withItemIdentifier: toolbarItemStart, at: 0)
        }
    }
    
}

