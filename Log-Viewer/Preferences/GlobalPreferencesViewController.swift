//
//  PreferencesViewController.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 08.12.20.
//

import Cocoa
import SwiftyMacViewExtensions

class GlobalPreferencesViewController:ViewController {
    
    var rememberFrameField = NSButton(checkboxWithTitle: "Remember", target: nil, action: nil)
    var useTabsField = NSButton(checkboxWithTitle: "Use Tabs", target: nil, action: nil)
    var fontSizeField = FontSizeSelect()
    var showUnmarkedGrayField = NSButton(checkboxWithTitle: "Show gray", target: nil, action: nil)
    var caseInsensitiveField = NSButton(checkboxWithTitle: "Case insensitive", target: nil, action: nil)
    var textColorFields = [NSColorWell]()
    var backgroundColorFields = [NSColorWell]()
    
    override init() {
        super.init()
        for _ in 0..<GlobalPreferences.numPatterns{
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
        
        fontSizeField.addItems(selectedSize: GlobalPreferences.shared.fontSize)
        reset()
        let resetButton = NSButton(title: "Reset to previous", target: self, action: #selector(reset))
        let setDefaultsButton = NSButton(title: "Reset to defaults", target: self, action: #selector(toDefaults))
        let okButton = NSButton(title: "Save", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Window size:", views: [rememberFrameField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Window settings:", views: [useTabsField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Font size:", views: [fontSizeField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Unmarked lines:", views: [showUnmarkedGrayField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Search:", views: [caseInsensitiveField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addSeparator()
        grid.addRow(with: [NSTextField(labelWithString: ""), NSTextField(labelWithString: "Text color"), NSTextField(labelWithString: "Background")])
        for i in 0..<GlobalPreferences.numPatterns{
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
        fontSizeField.setSelectedSize(GlobalPreferences.shared.fontSize)
        rememberFrameField.state = GlobalPreferences.shared.rememberWindowFrame ? .on : .off
        useTabsField.state = GlobalPreferences.shared.useTabs ? .on : .off
        showUnmarkedGrayField.state = GlobalPreferences.shared.showUnmarkedGray ? .on : .off
        caseInsensitiveField.state = GlobalPreferences.shared.caseInsensitive ? .on : .off
        for i in 0..<GlobalPreferences.numPatterns{
            let colorField = textColorFields[i]
            colorField.height(CGFloat(GlobalPreferences.shared.fontSize + 10))
            colorField.width(50)
            colorField.color = GlobalPreferences.shared.textColors[i].color
        }
        for i in 0..<GlobalPreferences.numPatterns{
            let colorField = backgroundColorFields[i]
            colorField.height(CGFloat(GlobalPreferences.shared.fontSize + 10))
            colorField.width(50)
            colorField.color = GlobalPreferences.shared.backgroundColors[i].color
        }
    }
    
    @objc func toDefaults(){
        GlobalPreferences.shared.resetGlobalSettings()
        reset()
    }
    
    @objc func save(){
        GlobalPreferences.shared.rememberWindowFrame = rememberFrameField.state == .on
        GlobalPreferences.shared.useTabs = useTabsField.state == .on
        if let fontSizeString = fontSizeField.titleOfSelectedItem{
            if let fontSize = Int(fontSizeString){
                GlobalPreferences.shared.fontSize = fontSize
            }
        }
        GlobalPreferences.shared.showUnmarkedGray = showUnmarkedGrayField.state == .on
        GlobalPreferences.shared.caseInsensitive = caseInsensitiveField.state == .on
        for i in 0..<GlobalPreferences.numPatterns{
            GlobalPreferences.shared.textColors[i] = CodableColor(color: textColorFields[i].color)
            GlobalPreferences.shared.backgroundColors[i] = CodableColor(color: backgroundColorFields[i].color)
        }
        GlobalPreferences.shared.save()
        if let window = view.window{
            window.close()
        }
    }
    
}

class FontSizeSelect : NSPopUpButton{
    
    func addItems(selectedSize : Int){
        for i in 0..<GlobalPreferences.fontSizes.count{
            let fontSize = GlobalPreferences.fontSizes[i]
            addItem(withTitle: String(fontSize))
            if fontSize == selectedSize{
                selectItem(at: i)
            }
        }
    }
    
    func setSelectedSize(_ size: Int){
        let s = String(size)
        for item in itemArray{
            if item.title == s{
                select(item)
                break
            }
        }
    }
}

