//
//  SplashViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 27.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class SplashViewController: ViewController {
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 100)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        let headerField = NSTextField(labelWithString: "Open recent:")
        headerField.alignment = .center
        view.addSubview(headerField)
        headerField.placeBelow(anchor: view.topAnchor)
        
        let urls = NSDocumentController.shared.recentDocumentURLs
        var lastView : NSView = headerField
        for url in urls{
            let button = NSButton(title: url.path, target: self, action: #selector(openRecent(sender:)))
            view.addSubview(button)
            button.placeBelow(anchor: lastView.bottomAnchor)
            button.refusesFirstResponder = true
            lastView = button
        }
        
        let openButton = NSButton(title: "Open...", target: self, action: #selector(open))
        view.addSubview(openButton)
        openButton.placeBelow(view: lastView)
        openButton.refusesFirstResponder = true
        
        let showSplashCheck = NSButton(checkboxWithTitle: "Show this window on application start", target: self, action: #selector(showSplashChanged(sender:)))
        showSplashCheck.state = Preferences.shared.showSplash ? .on : .off
        view.addSubview(showSplashCheck)
        showSplashCheck.placeBelow(view: openButton)
        showSplashCheck.refusesFirstResponder = true
        showSplashCheck.bottom(view.bottomAnchor,inset: Insets.defaultInset)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func openRecent(sender: Any){
        if let button = sender as? NSButton{
            if let url = URL(string: "file://" + button.title){
                NSDocumentController.shared.openDocument(withContentsOf: url, display: true){ document, documentWasAlreadyOpen, error in
                    self.view.window?.close()
                }
            }
        }
    }
    
    @objc func open(){
        self.view.window?.close()
        NSDocumentController.shared.openDocument(nil)
    }
    
    @objc func showSplashChanged(sender: Any){
        if let button = sender as? NSButton{
            Preferences.shared.showSplash = button.state == .on
            Preferences.shared.save()
        }
    }
    
}
