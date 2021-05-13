//
//  LogWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 07.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class LogWindowController: NSWindowController, NSWindowDelegate, NSToolbarDelegate {
    
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
    
    let toolbarItemStart = NSToolbarItem.Identifier("ToolbarStartItem")
    let toolbarItemPause = NSToolbarItem.Identifier("ToolbarPauseItem")
    let toolbarItemGlobalPreferences = NSToolbarItem.Identifier("ToolbarGlobalPreferencesItem")
    let toolbarItemDocumentPreferences = NSToolbarItem.Identifier("ToolbarDocumentPreferencesItem")
    let toolbarItemHelp = NSToolbarItem.Identifier("ToolbarHelpItem")

    var defaultSize = NSMakeSize(900, 600)
    
    var logDocument : LogDocument
    var logViewController : LogViewController {
        get{
            return contentViewController as! LogViewController
        }
    }
    
    init(document: LogDocument){
        self.logDocument = document
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - defaultSize.width/2
            y = screen.frame.height/2 - defaultSize.height/2
        }
        let window = NSWindow(contentRect: NSMakeRect(x, y, defaultSize.width, defaultSize.height), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        window.title = "Log-Viewer"
        window.tabbingMode = GlobalPreferences.shared.useTabs ? .preferred : .automatic
        super.init(window: window)
        self.window?.delegate = self
        let toolbar = NSToolbar(identifier: self.mainWindowToolbarIdentifier)
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconAndLabel
        self.window?.toolbar = toolbar
        self.window?.toolbar?.validateVisibleItems()
        let viewController = LogViewController()
        viewController.logDocument = logDocument
        contentViewController = viewController
        logViewController.updateFromDocument()
        if GlobalPreferences.shared.rememberWindowFrame{
            self.window?.setFrameUsingName(logDocument.preferences.id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func windowWillClose(_ notification: Notification) {
        logDocument.releaseEventSource()
        if GlobalPreferences.shared.rememberWindowFrame{
            self.window?.saveFrame(usingName: logDocument.preferences.id)
        }
    }
    
    // Window delegate
    
    func windowDidBecomeKey(_ notification: Notification) {
        updateStartPause()
    }
    
    override public func newWindowForTab(_ sender: Any?) {
        if let url = LogDocumentController.sharedController.showStartDialog(){
            LogDocumentController.sharedController.openDocument(withContentsOf: url, display: true){ doc, wasOpen, error in
            }
        }
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
            if #available(macOS 11.0, *){
                toolbarItem.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "")
            }
            else{
                toolbarItem.image = NSImage(named: "play.circle")
            }
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemPause {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(pause)
            toolbarItem.label = "Pause Logging"
            toolbarItem.paletteLabel = "Pause Logging"
            toolbarItem.toolTip = "Pause following the log file"
            if #available(macOS 11.0, *){
                toolbarItem.image = NSImage(systemSymbolName: "pause.circle", accessibilityDescription: "")
            }
            else{
                toolbarItem.image = NSImage(named: "pause.circle")
            }
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemGlobalPreferences {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openGlobalPreferences)
            toolbarItem.label = "Global Preferences"
            toolbarItem.paletteLabel = "Global Preferences"
            toolbarItem.toolTip = "Set global preferences and colors"
            if #available(macOS 11.0, *){
                toolbarItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "")
            }
            else{
                toolbarItem.image = NSImage(named: "gearshape")
            }
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemDocumentPreferences {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openDocumentPreferences)
            toolbarItem.label = "Document Preferences"
            toolbarItem.paletteLabel = "Document Preferences"
            toolbarItem.toolTip = "Set document log preferences"
            if #available(macOS 11.0, *){
                toolbarItem.image = NSImage(systemSymbolName: "doc.badge.gearshape", accessibilityDescription: "")
            }
            else{
                toolbarItem.image = NSImage(named: "doc.badge.gearshape")
            }
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemHelp {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(openHelp)
            toolbarItem.label = "Help"
            toolbarItem.paletteLabel = "Help"
            toolbarItem.toolTip = "Help"
            if #available(macOS 11.0, *){
                toolbarItem.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "")
            }
            else{
                toolbarItem.image = NSImage(named: "questionmark.circle")
            }
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
        controller.centerInWindow(outerWindow: self.window)
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func openDocumentPreferences() {
        let controller = DocumentPreferencesWindowController(log: logDocument)
        controller.centerInWindow(outerWindow: self.window)
        NSApp.runModal(for: controller.window!)
    }
    
    @objc func openHelp() {
        let controller = HelpWindowController()
        controller.centerInWindow(outerWindow: self.window)
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
    
    func updateStartPause(){
        if let toolbar = window?.toolbar{
            toolbar.removeItem(at: 0)
            if logViewController.follow{
                toolbar.insertItem(withItemIdentifier: toolbarItemPause, at: 0)
            }
            else{
                toolbar.insertItem(withItemIdentifier: toolbarItemStart, at: 0)
            }
        }
    }
    
}

