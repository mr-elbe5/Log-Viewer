/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

protocol TabbedLogWindowsDelegate: AnyObject {
    func createTab(windowController: LogWindowController, window: LogWindow)
}

class TabbedLogWindows: TabbedLogWindowsDelegate{

    fileprivate(set) var tabbedLogWindows = Array<TabbedLogWindow>()
    
    var mainWindow: LogWindow? {
        let mainManagedWindow = tabbedLogWindows.first { $0.window.isMainWindow }
        assert(mainManagedWindow != nil || tabbedLogWindows.isEmpty)
        return (mainManagedWindow ?? tabbedLogWindows.first).map { $0.window }
    }

    init(initialWindowController: LogWindowController) {
        precondition(addWindow(windowController: initialWindowController) != nil)
    }

    func createTab(windowController: LogWindowController, window: LogWindow){
        guard let newWindow = addWindow(windowController: windowController)?.window else { preconditionFailure() }
        window.addTabbedWindow(newWindow, ordered: .above)
        newWindow.makeKeyAndOrderFront(nil as LogWindow?)
    }

    private func addWindow(windowController: LogWindowController) -> TabbedLogWindow? {
        guard let window = windowController.window as? LogWindow else { return nil }
        let subscription = NotificationCenter.default.observe(name: NSWindow.willCloseNotification, object: window) { [unowned self] notification in
            guard let window = notification.object as? LogWindow else { return }
            self.removeTabbedWindow(forWindow: window)
        }
        let tabbedWindow = TabbedLogWindow(windowController: windowController, window: window, closingSubscription: subscription)
        tabbedLogWindows.append(tabbedWindow)
        windowController.delegate = self
        return tabbedWindow
    }

    private func removeTabbedWindow(forWindow window: LogWindow) {
        tabbedLogWindows.removeAll(where: { $0.window === window })
    }
    
}

struct TabbedLogWindow{
    let windowController: LogWindowController
    let window: LogWindow
    let closingSubscription: NotificationToken
}
