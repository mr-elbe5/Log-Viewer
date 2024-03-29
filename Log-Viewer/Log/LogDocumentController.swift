/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

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
