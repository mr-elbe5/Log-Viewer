//
//  PreferencesViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class GlobalPreferencesViewController:ViewController {
    
    var showSplashField = NSButton(checkboxWithTitle: "Show at startup", target: nil, action: nil)
    var rememberFrameField = NSButton(checkboxWithTitle: "Remember", target: nil, action: nil)
    var fontSizeField = FontSizeSelect()
    var showUnmarkedGrayField = NSButton(checkboxWithTitle: "Show gray", target: nil, action: nil)
    var caseInsensitiveField = NSButton(checkboxWithTitle: "Case insensitive", target: nil, action: nil)
    var textColorFields = [NSColorWell]()
    var backgroundColorFields = [NSColorWell]()
    
    override init() {
        super.init()
        for _ in 0..<Preferences.numPatterns{
            textColorFields.append(NSColorWell())
            backgroundColorFields.append(NSColorWell())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 390)
        
        fontSizeField.addItems(selectedSize: Preferences.shared.fontSize)
        reset()
        let resetButton = NSButton(title: "Reset to previous", target: self, action: #selector(reset))
        let setDefaultsButton = NSButton(title: "Reset to defaults", target: self, action: #selector(toDefaults))
        let okButton = NSButton(title: "Save", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Previous documents:", views: [showSplashField, NSGridCell.emptyContentView]).mergeCells(from: 1, to: 2)
        grid.addLabeledRow(label: "Window size:", views: [rememberFrameField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Font size:", views: [fontSizeField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Unmarked lines:", views: [showUnmarkedGrayField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Search:", views: [caseInsensitiveField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addSeparator()
        grid.addRow(with: [NSTextField(labelWithString: ""), NSTextField(labelWithString: "Text color"), NSTextField(labelWithString: "Background")])
        for i in 0..<Preferences.numPatterns{
            grid.addLabeledRow(label: "Colors of pattern \(i)", views: [textColorFields[i], backgroundColorFields[i]])
        }
        grid.addSeparator()
        grid.addRow(with: [resetButton, setDefaultsButton, okButton])
        
        view.addSubview(grid)
        grid.placeBelow(anchor: view.topAnchor)
        let buttonGrid = NSGridView()
        buttonGrid.addRow(with: [resetButton, setDefaultsButton, okButton])
        buttonGrid.column(at: 2).xPlacement = .trailing
        view.addSubview(buttonGrid)
        buttonGrid.placeBelow(view: grid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func reset(){
        fontSizeField.setSelectedSize(Preferences.shared.fontSize)
        showSplashField.state = Preferences.shared.showSplash ? .on : .off
        rememberFrameField.state = Preferences.shared.rememberWindowFrame ? .on : .off
        showUnmarkedGrayField.state = Preferences.shared.showUnmarkedGray ? .on : .off
        caseInsensitiveField.state = Preferences.shared.caseInsensitive ? .on : .off
        for i in 0..<Preferences.numPatterns{
            let colorField = textColorFields[i]
            colorField.height(CGFloat(Preferences.shared.fontSize + 10))
            colorField.width(50)
            colorField.color = Preferences.shared.textColors[i].color
        }
        for i in 0..<Preferences.numPatterns{
            let colorField = backgroundColorFields[i]
            colorField.height(CGFloat(Preferences.shared.fontSize + 10))
            colorField.width(50)
            colorField.color = Preferences.shared.backgroundColors[i].color
        }
    }
    
    @objc func toDefaults(){
        Preferences.shared.resetGlobalSettings()
        reset()
    }
    
    @objc func save(){
        Preferences.shared.showSplash = showSplashField.state == .on
        Preferences.shared.rememberWindowFrame = rememberFrameField.state == .on
        if let fontSizeString = fontSizeField.titleOfSelectedItem{
            if let fontSize = Int(fontSizeString){
                Preferences.shared.fontSize = fontSize
            }
        }
        Preferences.shared.showUnmarkedGray = showUnmarkedGrayField.state == .on
        Preferences.shared.caseInsensitive = caseInsensitiveField.state == .on
        for i in 0..<Preferences.numPatterns{
            Preferences.shared.textColors[i] = CodableColor(color: textColorFields[i].color)
            Preferences.shared.backgroundColors[i] = CodableColor(color: backgroundColorFields[i].color)
        }
        Preferences.shared.save()
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
    
    func setSelectedSize(_ size: Int){
        let s = String(size)
        for item in self.itemArray{
            if item.title == s{
                select(item)
                break
            }
        }
    }
}
