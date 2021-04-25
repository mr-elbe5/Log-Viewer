//
//  PreferencesViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa

class PreferencesViewController:NSViewController {
    
    var logDocument : LogDocument? = nil
    
    var fontSizeField = FontSizeSelect()
    var showUnmarkedGrayField = NSButton(checkboxWithTitle: "Show gray", target: nil, action: nil)
    var caseInsensitiveField = NSButton(checkboxWithTitle: "Case insensitive", target: nil, action: nil)
    var patternFields = [NSTextField]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        for _ in 0..<DocumentPreferences.numPatterns{
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
            fontSizeField.addItems(selectedSize: prefs.fontSize)
            showUnmarkedGrayField.state = prefs.showUnmarkedGray ? .on : .off
            caseInsensitiveField.state = prefs.caseInsensitive ? .on : .off
            for i in 0..<DocumentPreferences.numPatterns{
                patternFields[i].stringValue = prefs.patterns[i]
            }
        }
        else{
            fontSizeField.addItems(selectedSize: Preferences.defaultFontSize)
            showUnmarkedGrayField.state = .off
            caseInsensitiveField.state = .off
        }
        setColors()
        
        let resetButton = NSButton(title: "Reset", target: self, action: #selector(reset))
        let okButton = NSButton(title: "Ok", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        var views = [
            [NSTextField(labelWithString: "Font size:"), fontSizeField],
            [NSTextField(labelWithString: "Unmarked lines:"), showUnmarkedGrayField],
            [NSTextField(labelWithString: "Search mode:"), caseInsensitiveField],
            [NSBox().asSeparator()]
        ]
        for i in 0..<DocumentPreferences.numPatterns{
            views.append([NSTextField(labelWithString: "Text to mark:"), patternFields[i]])
        }
        views.append([NSBox().asSeparator()])
        views.append([resetButton, okButton])

        let grid = NSGridView(views: views)
        grid.rowAlignment = .firstBaseline
        grid.column(at: 1).xPlacement = .trailing
        
        var separatorRow = grid.row(at: 3)
        separatorRow.mergeCells(in: NSRange(location: 0, length: 2))
        separatorRow.topPadding = 8
        separatorRow.bottomPadding = 8
        
        separatorRow = grid.row(at: 4 + DocumentPreferences.numPatterns)
        separatorRow.mergeCells(in: NSRange(location: 0, length: 2))
        separatorRow.topPadding = 8
        separatorRow.bottomPadding = 8
        
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
        if Statics.isDarkMode{
            for i in 0..<DocumentPreferences.numPatterns{
                patternFields[i].textColor = Preferences.colors[i]
                patternFields[i].backgroundColor = NSColor.textBackgroundColor
            }
        }
        else{
            for i in 0..<DocumentPreferences.numPatterns{
                patternFields[i].textColor = NSColor.labelColor
                patternFields[i].backgroundColor = Preferences.colors[i]
            }
        }
    }
    
    @objc func reset(){
        for i in 0..<DocumentPreferences.numPatterns{
            patternFields[i].stringValue = ""
        }
    }
    
    @objc func save(){
        if let log = logDocument{
            if let fontSizeString = fontSizeField.titleOfSelectedItem{
                if let fontSize = Int(fontSizeString){
                    logDocument?.preferences.fontSize = fontSize
                }
            }
            log.preferences.showUnmarkedGray = showUnmarkedGrayField.state == .on
            log.preferences.caseInsensitive = caseInsensitiveField.state == .on
            for i in 0..<DocumentPreferences.numPatterns{
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

class FontSizeSelect : NSPopUpButton{
    
    func addItems(selectedSize : Int){
        for i in 0..<Preferences.fontSizes.count{
            let fontSize = Preferences.fontSizes[i]
            addItem(withTitle: String(fontSize))
            if fontSize == selectedSize{
                selectItem(at: i)
            }
        }
    }
}

