//
//  DocumentPreferencesViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 29.04.21.
//

import Cocoa
import SwiftyMacViewExtensions

class DocumentPreferencesViewController:NSViewController {
    
    var logDocument : LogDocument? = nil
    
    var fullLineColoringField = NSButton(checkboxWithTitle: "On", target: nil, action: nil)
    var patternFields = [NSTextField]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        for _ in 0..<Preferences.numPatterns{
            patternFields.append(NSTextField())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 290)
        
        if let prefs = logDocument?.preferences{
            fullLineColoringField.state = prefs.fullLineColoring ? .on : .off
            for i in 0..<Preferences.numPatterns{
                patternFields[i].stringValue = prefs.patterns[i]
            }
        }
        setColors()
        
        let resetButton = NSButton(title: "Reset", target: self, action: #selector(resetDocumentPreferences))
        let okButton = NSButton(title: "Ok", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Full line coloring (first pattern wins):", views: [fullLineColoringField])
        for i in 0..<patternFields.count{
            grid.addLabeledRow(label: "Text to mark:", views: [patternFields[i]]).rowAlignment = .firstBaseline
        }
        grid.addSeparator()
        grid.addRow(with: [resetButton, okButton])
        grid.column(at: 1).xPlacement = .trailing

        view.addSubview(grid)
        grid.placeBelow(anchor: view.topAnchor)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func appearanceChanged(){
        setColors()
    }
    
    private func setColors(){
        for i in 0..<Preferences.numPatterns{
            patternFields[i].textColor = Preferences.shared.textColors[i].color
            patternFields[i].backgroundColor = Preferences.shared.backgroundColors[i].color
        }
    }
    
    @objc func resetDocumentPreferences(){
        fullLineColoringField.state = .off
        for i in 0..<Preferences.numPatterns{
            patternFields[i].stringValue = ""
        }
    }
    
    @objc func save(){
        if let log = logDocument{
            log.preferences.fullLineColoring = fullLineColoringField.state == .on
            for i in 0..<Preferences.numPatterns{
                log.preferences.patterns[i] = patternFields[i].stringValue
            }
            log.savePreferences()
            log.preferencesChanged()
        }
        if let window = self.view.window as? PopupWindow{
            window.close()
        }
    }
    
}



