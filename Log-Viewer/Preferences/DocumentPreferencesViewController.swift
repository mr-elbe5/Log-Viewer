/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa


class DocumentPreferencesViewController:ViewController {
    
    var logDocument : LogDocument? = nil
    
    var fullLineColoringField = NSButton(checkboxWithTitle: "On", target: nil, action: nil)
    var skipUnmarkedField = NSButton(checkboxWithTitle: "Skip line", target: nil, action: nil)
    var patternFields = [NSTextField]()
    var saveAsField = NSTextField()
    var namedPreferencesField = NSPopUpButton()
    
    override init() {
        super.init()
        for _ in 0..<GlobalPreferences.numPatterns{
            patternFields.append(NSTextField())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 310)
        
        if let prefs = logDocument?.preferences{
            fullLineColoringField.state = prefs.fullLineColoring ? .on : .off
            for i in 0..<GlobalPreferences.numPatterns{
                patternFields[i].stringValue = prefs.patterns[i]
            }
        }
        setColors()
        
        let resetButton = NSButton(title: "Reset", target: self, action: #selector(resetDocumentPreferences))
        let okButton = NSButton(title: "Ok", target: self, action: #selector(save))
        okButton.keyEquivalent = "\r"
        
        let grid = NSGridView()
        grid.addLabeledRow(label: "Full line coloring (first pattern wins):", views: [fullLineColoringField])
        grid.addLabeledRow(label: "Unmarked lines:", views: [skipUnmarkedField, NSGridCell.emptyContentView]).mergeCells(from: 1)
        for i in 0..<patternFields.count{
            grid.addLabeledRow(label: "Text to mark:", views: [patternFields[i]]).rowAlignment = .firstBaseline
        }
        reset()
        grid.addSeparator()
        grid.addRow(with: [resetButton, okButton])
        for i in 0..<GlobalPreferences.numSavedDocumentPreferences{
            namedPreferencesField.addItem(withTitle: String(i+1))
        }
        grid.addLabeledRow(label: "Preferences slot", view: namedPreferencesField)
        let saveButton = NSButton(title: "Save to slot", target: self, action: #selector(savePreferences))
        let loadButton = NSButton(title: "Load from slot", target: self, action: #selector(loadPreferences))
        grid.addRow(with: [saveButton, loadButton])
        grid.column(at: 1).xPlacement = .trailing

        view.addSubview(grid)
        grid.placeBelow(anchor: view.topAnchor)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reset(){
        if let log = logDocument{
            fullLineColoringField.state = log.preferences.fullLineColoring ? .on : .off
            skipUnmarkedField.state = log.preferences.skipUnmarked ? .on : .off
        }
    }
    
    func appearanceChanged(){
        setColors()
    }
    
    private func setColors(){
        for i in 0..<GlobalPreferences.numPatterns{
            patternFields[i].textColor = GlobalPreferences.shared.textColors[i].color
            patternFields[i].backgroundColor = GlobalPreferences.shared.backgroundColors[i].color
        }
    }
    
    @objc func resetDocumentPreferences(){
        fullLineColoringField.state = .off
        for i in 0..<GlobalPreferences.numPatterns{
            patternFields[i].stringValue = ""
        }
    }
    
    @objc func savePreferences(){
        let idx = namedPreferencesField.indexOfSelectedItem
        let prefs = DocumentPreferences()
        prefs.fullLineColoring = fullLineColoringField.state == .on
        prefs.skipUnmarked = skipUnmarkedField.state == .on
        for i in 0..<GlobalPreferences.numPatterns{
            prefs.patterns[i] = patternFields[i].stringValue
        }
        GlobalPreferences.shared.savedDocumentPreferences[idx] = prefs
        GlobalPreferences.shared.save()
    }
    
    @objc func loadPreferences(){
        let idx = namedPreferencesField.indexOfSelectedItem
        let prefs = GlobalPreferences.shared.savedDocumentPreferences[idx]
        fullLineColoringField.state = prefs.fullLineColoring ? .on : .off
        skipUnmarkedField.state = prefs.skipUnmarked ? .on : .off
        for i in 0..<GlobalPreferences.numPatterns{
            patternFields[i].stringValue = prefs.patterns[i]
        }
        
    }
    
    @objc func save(){
        if let log = logDocument{
            log.preferences.fullLineColoring = fullLineColoringField.state == .on
            log.preferences.skipUnmarked = skipUnmarkedField.state == .on
            for i in 0..<GlobalPreferences.numPatterns{
                log.preferences.patterns[i] = patternFields[i].stringValue
            }
            log.savePreferences()
            log.preferencesChanged()
        }
        if let window = view.window{
            window.close()
        }
    }
    
}



