//
//  LogDocumentController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 16.12.20.
//

import Cocoa

class LogDocumentController: NSDocumentController {
    
    override func openUntitledDocumentAndDisplay(_ displayDocument: Bool) throws -> NSDocument {
        print("open untitled")
        return LogDocument.dummyDocument
    }
    
    override func clearRecentDocuments(_ sender: Any?) {
        super.clearRecentDocuments(sender)
        Preferences.shared.resetDocumentPreferences()
        Preferences.shared.save()
    }
    
}
