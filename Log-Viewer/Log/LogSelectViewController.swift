/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class LogSelectViewController: ViewController {
    
    var url : URL? = nil
    
    override public func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        
        let scrollView = NSScrollView()
        let contentView = NSView()
        scrollView.asVerticalScrollView(inView: view, contentView: contentView)
        
        var lastView: NSView? = nil
        let documents = LogDocumentController.sharedController.recentDocumentURLs
        if documents.isEmpty{
            let label = NSTextField(labelWithString: "There are no recent files")
            contentView.addSubview(label)
            label.placeBelow(anchor: contentView.topAnchor, insets: Insets.defaultInsets)
            lastView = label
        }
        else{
            for document in documents{
                let button = NSButton(title: document.path, target: self, action: #selector(openRecent(sender:)))
                contentView.addSubview(button)
                button.placeBelow(anchor: lastView?.bottomAnchor ?? contentView.topAnchor, insets: Insets.defaultInsets)
                button.refusesFirstResponder = true
                lastView = button
            }
        }
        lastView!.bottom(contentView.bottomAnchor, inset: Insets.defaultInset)
        
        let openButton = NSButton(title: "Open...", target: self, action: #selector(open))
        view.addSubview(openButton)
        openButton.placeBelow(anchor: scrollView.bottomAnchor, insets: Insets.defaultInsets)
        openButton.refusesFirstResponder = true
        openButton.bottom(view.bottomAnchor, inset: Insets.defaultInset)
    }
    
    @objc open func openRecent(sender: Any){
        if let button = sender as? NSButton{
            url = URL(fileURLWithPath: button.title)
            view.window?.close()
        }
    }
    
    @objc open func open(){
        LogDocumentController.sharedController.openDocument(self)
        view.window?.close()
    }
    
}
