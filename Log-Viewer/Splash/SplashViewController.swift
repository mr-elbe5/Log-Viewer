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
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 270)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        let leftPanel = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        view.addSubview(leftPanel)
        leftPanel.placeAfter(anchor: view.leadingAnchor)
        leftPanel.trailing(view.centerXAnchor)
        
        var vw = NSTextField(labelWithString: "Test")
        leftPanel.addSubview(vw)
        vw.placeBelow(anchor: leftPanel.topAnchor)
        
        let rightScrollView = NSScrollView()
        rightScrollView.hasVerticalScroller = true
        rightScrollView.hasHorizontalScroller = false
        rightScrollView.autohidesScrollers = false
        view.addSubview(rightScrollView)
        rightScrollView.placeBefore(anchor: view.trailingAnchor)
        rightScrollView.leading(view.centerXAnchor)
        
        let clipView = NSClipView()
        rightScrollView.contentView = clipView
        clipView.fillView(view: rightScrollView)
        
        let rightPanel = NSView()
        rightScrollView.documentView = rightPanel
        rightPanel.setAnchors()
        rightPanel.leading(clipView.leadingAnchor)
        rightPanel.top(clipView.topAnchor)
        rightPanel.trailing(clipView.trailingAnchor)
    
        
        var lastAnchor =  rightPanel.topAnchor
        for i in 0..<50{
            vw = NSTextField(labelWithString: "Test \(i)")
            rightPanel.addSubview(vw)
            vw.placeBelow(anchor: lastAnchor)
            lastAnchor = vw.bottomAnchor
        }
        rightPanel.bottom(lastAnchor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
