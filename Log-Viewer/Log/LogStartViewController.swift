//
//  LogStartViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 13.05.21.
//

import Foundation
import Cocoa
import SwiftyMacViewExtensions

public class LogStartViewController: ViewController {
    
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
            self.url = URL(fileURLWithPath: button.title)
            self.view.window?.close()
        }
    }
    
    @objc open func open(){
        LogDocumentController.sharedController.openDocument(self)
        self.view.window?.close()
    }
    
}
