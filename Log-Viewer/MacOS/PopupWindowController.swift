/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class PopupWindowController: WindowController {

    var presentingWindow : NSWindow? = nil

    func popupWindow(styleMask: NSWindow.StyleMask = [.titled, .closable]) -> PopupWindow{
        let window = PopupWindow(
            contentRect: CGRect(),
            styleMask: styleMask,
            backing: .buffered,
            defer: false)
        window.parentFrame = presentingWindow?.frame
        return window
    }
    
}
