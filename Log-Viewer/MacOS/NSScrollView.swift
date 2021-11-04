/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

final class FlippedClipView: NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
}

extension NSScrollView{
    
    func asVerticalScrollView(inView parentView: NSView, contentView: NSView, insets : NSEdgeInsets = Insets.defaultInsets){
        self.hasVerticalScroller = true
        self.hasHorizontalScroller = false
        parentView.addSubview(self)
        self.placeBelow(anchor: parentView.topAnchor)
        let clipView = FlippedClipView()
        self.contentView = clipView
        clipView.fillSuperview()
        self.documentView = contentView
        contentView.setAnchors()
        contentView.leading(clipView.leadingAnchor, inset: insets.left)
        contentView.top(clipView.topAnchor, inset: insets.top)
        contentView.trailing(clipView.trailingAnchor, inset: insets.right)
    }
    
}
