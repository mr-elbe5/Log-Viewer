//
//  SplashWindowController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 27.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class SplashWindowController: PopupWindowController {

    override func loadWindow() {
        let window = popupWindow()
        window.title = "Log-Viewer - Open file"
        window.delegate = self
        contentViewController = SplashViewController()
        self.window = window
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.orderFront(nil)
    }

    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }

}
