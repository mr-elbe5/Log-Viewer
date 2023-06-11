/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class LogDocumentPool: NSObject, Codable {
    
    static var defaultSize: NSSize = NSMakeSize(900, 600)
    static var defaultRect: NSRect{
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - defaultSize.width/2
            y = screen.frame.height/2 - defaultSize.height/2
        }
        return NSMakeRect(x, y, LogDocumentPool.defaultSize.width, LogDocumentPool.defaultSize.height)
    }
    
    static var shared = LogDocumentPool()
    
    static func loadDocumentPool(){
        if let storedString = UserDefaults.standard.value(forKey: "appState") as? String {
            if let state : LogDocumentPool = LogDocumentPool.fromJSON(encoded: storedString){
                LogDocumentPool.shared = state
            }
        }
        else{
            print("no saved data available for app state")
            LogDocumentPool.shared = LogDocumentPool()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case frameRect
        case documentHistory
    }
    
    var frameRect: NSRect
    var documentHistory = Array<LogDescriptor>()
    
    var documentWindowControllers = Array<DocumentWindowController>()
    
    var mainWindowController: DocumentWindowController? {
        if documentWindowControllers.isEmpty{
            return nil
        }
        var controller = documentWindowControllers.first { $0.window?.isMainWindow ?? false}
        if controller == nil{
            controller = documentWindowControllers.first
        }
        return controller
    }
    
    var mainWindow: NSWindow? {
        mainWindowController?.window
    }
    
    var mainDocument: LogDocument? {
        mainWindowController?.logDocument
    }
    
    override init(){
        frameRect = LogDocumentPool.defaultRect
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        frameRect = try values.decodeIfPresent(NSRect.self, forKey: .frameRect) ?? LogDocumentPool.defaultRect
        documentHistory = try values.decodeIfPresent(Array<LogDescriptor>.self, forKey: .documentHistory) ?? Array<LogDescriptor>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frameRect, forKey: .frameRect)
        try container.encode(documentHistory, forKey: .documentHistory)
    }
    
    func addToHistory(_ descriptor: LogDescriptor){
        if !documentHistory.contains(descriptor){
            documentHistory.append(descriptor)
            save()
        }
    }
    
    func save(){
        let storeString = toJSON()
        UserDefaults.standard.set(storeString, forKey: "appState")
    }
    
    func clearRecentDocuments(_ sender: Any?) {
        GlobalPreferences.shared.resetDocumentPreferences()
        GlobalPreferences.shared.save()
    }
    
    func removeController(controller: DocumentWindowController){
        controller.logDocument.releaseLogSource()
        documentWindowControllers.remove(obj: controller)
        if documentWindowControllers.isEmpty{
            NSApplication.shared.terminate(self)
        }
    }
    
    func removeController(forWindow: NSWindow){
        for controller in documentWindowControllers{
            if controller.window == forWindow{
                removeController(controller: controller)
                break
            }
        }
    }
    
}

extension LogDocumentPool: DocumentWindowDelegate{
    
    func openDocument(sender: DocumentWindowController?) {
        let dialog = OpenDocumentDialog()
        NSApp.runModal(for: dialog.window!)
        if let url = dialog.url{
            var document : LogDocument
            switch dialog.type{
            case .remote: document = LogRemoteDocument()
            case .file: document = LogFileDocument()
            }
            document.url = url
            let controller = DocumentWindowController(document: document)
            controller.delegate = self
            guard let window = controller.window else {return}
            NotificationCenter.default.addObserver(forName:NSWindow.willCloseNotification, object: window, queue: nil){ [unowned self] notification in
                guard let window = notification.object as? NSWindow else { return }
                self.removeController(forWindow: window)
            }
            documentWindowControllers.append(controller)
            addToHistory(LogDescriptor(type: dialog.type, path: url.path))
            if GlobalPreferences.shared.useTabs, let sender = sender{
                sender.window!.addTabbedWindow(controller.window!, ordered: .above)
            }
            else{
                controller.showWindow(nil)
            }
        }
    }
    
    func newWindowForTab(from: DocumentWindowController) {
        var url : URL? = nil
        let dialog = OpenDocumentDialog()
        if NSApp.runModal(for: dialog.window!) != .OK{
            return
        }
        url = dialog.url
        let document = LogDocument()
        document.url = url
        let controller = DocumentWindowController(document: document)
        from.window!.addTabbedWindow(controller.window!, ordered: .above)
    }
    
}

final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}
