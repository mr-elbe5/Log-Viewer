/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class GlobalPreferencesViewController:ViewController {
    
    var rememberFrameField = NSButton(checkboxWithTitle: "Remember", target: nil, action: nil)
    var useTabsField = NSButton(checkboxWithTitle: "Use Tabs", target: nil, action: nil)
    var showFullFileField = NSButton(checkboxWithTitle: "Show Full File", target: nil, action: nil)
    var fontSizeField = FontSizeSelect()
    var showUnmarkedGrayField = NSButton(checkboxWithTitle: "Show gray", target: nil, action: nil)
    var caseInsensitiveField = NSButton(checkboxWithTitle: "Case insensitive", target: nil, action: nil)
    var maxLinesField = NSTextField(string: String(GlobalPreferences.shared.maxLines))
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
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 430)
        
        fontSizeField.addItems(selectedSize: GlobalPreferences.shared.fontSize)
        reset()
        let resetButton = NSButton(title: "Reset to previous", target: self, action: #selector(reset))
        let setDefaultsButton = NSButton(title: "Reset to defaults", target: self, action: #selector(toDefaults))
        let okButton = NSButton(title: "Save", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Window size:", views: [rememberFrameField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Window settings:", views: [useTabsField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "File settings:", views: [showFullFileField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        grid.addLabeledRow(label: "Max lines:", views: [maxLinesField, NSGridCell.emptyContentView]).mergeCells(from: 1)
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
        maxLinesField.stringValue = String(GlobalPreferences.shared.maxLines)
        rememberFrameField.state = GlobalPreferences.shared.rememberWindowFrame ? .on : .off
        useTabsField.state = GlobalPreferences.shared.useTabs ? .on : .off
        showFullFileField.state = GlobalPreferences.shared.showFullFile ? .on : .off
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
        GlobalPreferences.shared.showFullFile = showFullFileField.state == .on
        if let fontSizeString = fontSizeField.titleOfSelectedItem{
            if let fontSize = Int(fontSizeString){
                GlobalPreferences.shared.fontSize = fontSize
            }
        }
        if let maxLines = Int(maxLinesField.stringValue){
            GlobalPreferences.shared.maxLines = maxLines
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

