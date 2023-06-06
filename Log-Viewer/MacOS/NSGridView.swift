/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

extension NSGridView{
    
    @discardableResult
    func addLabeledRow(label: String, views: [NSView]) -> NSGridRow{
        var arr = [NSView]()
        arr.append(NSTextField(labelWithString: label))
        arr.append(contentsOf: views)
        return addRow(with: arr)
    }
    
    @discardableResult
    func addLabeledRow(label: String, view: NSView) -> NSGridRow{
        var arr = [NSView]()
        arr.append(NSTextField(labelWithString: label))
        arr.append(view)
        return addRow(with: arr)
    }
    
    func addSeparator(padding: CGFloat = 8){
        let numCols = self.numberOfColumns
        let arr = [NSBox().asSeparator()]
        let row = addRow(with: arr)
        row.mergeCells(in: NSRange(location: 0, length: numCols))
        row.topPadding = padding
        row.bottomPadding = padding
    }
    
}

extension NSGridRow{
    
    func mergeCells(from: Int, to: Int){
        mergeCells(in: NSRange(location: from, length: to - from + 1))
    }
    
    func mergeCells(from: Int){
        let numCols = gridView?.numberOfColumns ?? 1
        mergeCells(in: NSRange(location: from, length: numCols - from))
    }
    
}
