/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class LogPool {
    
    static var defaultSize: NSSize = NSMakeSize(900, 600)
    static var defaultRect: NSRect{
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - defaultSize.width/2
            y = screen.frame.height/2 - defaultSize.height/2
        }
        return NSMakeRect(x, y, LogPool.defaultSize.width, LogPool.defaultSize.height)
    }
    
    static var shared = LogPool()
    
    var documentWindowControllers = Array<LogWindowController>()
    
    var mainWindowController: LogWindowController? {
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
    
    var mainDocument: LogFile? {
        mainWindowController?.logDocument
    }
    
    func clearRecentDocuments(_ sender: Any?) {
        GlobalPreferences.shared.resetDocumentPreferences()
        GlobalPreferences.shared.save()
    }
    
    func removeController(controller: LogWindowController){
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

extension LogPool: LogWindowDelegate{
    
    func openDocument(sender: LogWindowController?) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        if NSApp.runModal(for: panel) == .OK, let url = panel.urls.first{
            let document = LocalLogFile(url: url)
            let controller = LogWindowController(document: document)
            controller.delegate = self
            guard let window = controller.window else {return}
            NotificationCenter.default.addObserver(forName:NSWindow.willCloseNotification, object: window, queue: nil){ [unowned self] notification in
                guard let window = notification.object as? NSWindow else { return }
                self.removeController(forWindow: window)
            }
            documentWindowControllers.append(controller)
            if GlobalPreferences.shared.useTabs, let sender = sender{
                sender.window!.addTabbedWindow(controller.window!, ordered: .above)
            }
            else{
                controller.showWindow(nil)
            }
        }
    }
    
    func newWindowForTab(from: LogWindowController) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        if NSApp.runModal(for: panel) == .OK, let url = panel.urls.first{
            let document = LocalLogFile(url: url)
            let controller = LogWindowController(document: document)
            from.window!.addTabbedWindow(controller.window!, ordered: .above)
        }
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
