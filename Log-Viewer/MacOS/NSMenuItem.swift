/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

extension NSMenuItem {

    convenience init(title string: String, target: AnyObject = NSMenuItem.self as AnyObject, action selector: Selector?, keyEquivalent charCode: String, modifier: NSEvent.ModifierFlags = .command) {
        self.init(title: string, action: selector, keyEquivalent: charCode)
        keyEquivalentModifierMask = modifier
        self.target = target
    }

    convenience init(title string: String, submenuItems: [NSMenuItem]) {
        self.init(title: string, action: nil, keyEquivalent: "")
        self.submenu = NSMenu()
        self.submenu?.items = submenuItems
    }
}
