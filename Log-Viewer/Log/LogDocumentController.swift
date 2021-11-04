//
//  LogDocumentController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 16.12.20.
//

import Cocoa


class LogDocumentController: NSDocumentController {
    
    public static var sharedController : LogDocumentController{
        get{
            NSDocumentController.shared as! LogDocumentController
        }
    }
    
    override func clearRecentDocuments(_ sender: Any?) {
        super.clearRecentDocuments(sender)
        GlobalPreferences.shared.resetDocumentPreferences()
        GlobalPreferences.shared.save()
    }
    
    public func showSelectDialog() -> URL?{
        let controller = LogSelectWindowController()
        if NSApp.runModal(for: controller.window!) == .OK{
            return controller.url
        }
        return nil
    }
    
}
