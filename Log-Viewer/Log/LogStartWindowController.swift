//
//  LogStartWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 13.05.21.
//

import Cocoa
import SwiftyMacViewExtensions

public class LogStartWindowController: NSWindowController, NSWindowDelegate {
    
    var url : URL?{
        get{
            (contentViewController as! LogStartViewController).url
        }
    }
    
    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), styleMask: [.closable, .miniaturizable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Open file"
        super.init(window: window)
        self.window?.delegate = self
        let controller = LogStartViewController()
        contentViewController = controller
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func windowWillClose(_ notification: Notification) {
        NSApp.stopModal(withCode: url != nil ? .OK : .cancel)
    }

}

