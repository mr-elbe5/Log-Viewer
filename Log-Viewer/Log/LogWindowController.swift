//
//  LogWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa

class LogWindowController: NSWindowController, NSWindowDelegate, NSToolbarDelegate {
    
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
    
    let toolbarItemStart = NSToolbarItem.Identifier("ToolbarStartItem")
    let toolbarItemPause = NSToolbarItem.Identifier("ToolbarPauseItem")
    let toolbarItemPreferences = NSToolbarItem.Identifier("ToolbarPreferencesItem")
    let toolbarItemHelp = NSToolbarItem.Identifier("ToolbarHelpItem")
    
    var logDocument : LogDocument!
    var logViewController : LogViewController {
        get{
            return contentViewController as! LogViewController
        }
    }
    var observer : NSKeyValueObservation? = nil
    
    convenience init() {
        self.init(windowNibName: "")
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
        toolbar.displayMode = .iconOnly
        
        window.toolbar = toolbar
        window.toolbar?.validateVisibleItems()
        self.window = window
        logViewController.updateFromDocument()
        observer = NSApp.observe(\.effectiveAppearance){
            (app, _) in
            self.logViewController.appearanceChanged()
        }
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
            toolbarItem.label = "Start"
            toolbarItem.paletteLabel = "Start"
            toolbarItem.toolTip = "Start following the log file"
            toolbarItem.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemPause {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(pause)
            toolbarItem.label = "Pause"
            toolbarItem.paletteLabel = "Pause"
            toolbarItem.toolTip = "Pause following the log file"
            toolbarItem.image = NSImage(systemSymbolName: "pause.circle", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemPreferences {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openPreferences)
            toolbarItem.label = "Preferences"
            toolbarItem.paletteLabel = "Preferences"
            toolbarItem.toolTip = "Set log preferences and colors"
            toolbarItem.image = NSImage(systemSymbolName: "gear", accessibilityDescription: "")
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
            self.toolbarItemPreferences,
            self.toolbarItemHelp
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        return [self.toolbarItemStart,
                self.toolbarItemPause,
                self.toolbarItemPreferences,
                self.toolbarItemHelp,
                NSToolbarItem.Identifier.space,
                NSToolbarItem.Identifier.flexibleSpace]
    }
    
    @objc func openPreferences() {
        let controller = PreferencesWindowController()
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

