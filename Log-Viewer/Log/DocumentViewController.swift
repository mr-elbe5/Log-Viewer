/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class DocumentViewController: ViewController {
    
    let scrollView = NSScrollView()
    let textView = NSTextView()

    var defaultSize = NSMakeSize(900, 600)
    
    var logDocument : LogDocument
    var loaded = false
    
    var follow = true
    
    init(logDocument: LogDocument) {
        self.logDocument = logDocument
        super.init()
        view.frame = CGRect(x: 0, y: 0, width: defaultSize.width, height: defaultSize.height)
        view.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        view = scrollView
        textView.autoresizingMask = [.width]
        textView.isVerticallyResizable = true
        textView.isEditable = false
        textView.isSelectable = true
        scrollView.documentView = textView
    }
    
    override func viewDidAppear() {
        /*if !loaded{
            reloadFullFile()
            loaded = true
        }*/
    }
    
    func reset(){
        textView.textStorage?.setAttributedString(NSAttributedString(string: ""))
    }
    
    func updateFromDocument(){
        if !follow{
            return
        }
        for chunk in logDocument.chunks{
            if !chunk.displayed{
                chunk.displayed = true
                appendText(string: chunk.string)
            }
        }
    }
    
    func appearanceChanged(){
        let oldFollow = follow
        follow = false;
        reset()
        for chunk in logDocument.chunks{
            if chunk.displayed{
                appendText(string: chunk.string)
            }
        }
        follow = oldFollow
        textView.scrollToEndOfDocument(nil)
    }
    
    func appendText(string: String) {
        Log.debug("start append text")
        let prefs = logDocument.preferences
        let font : NSFont = NSFont.monospacedSystemFont(ofSize: CGFloat(GlobalPreferences.shared.fontSize), weight: .medium)
        if logDocument.preferences.hasColorCoding{
            appendColorMarkedText(string, font : font, preferences: prefs)
        }
        else{
            appendDefaultText(string, font : font)
        }
        textView.scrollToEndOfDocument(nil)
        Log.debug("end append text")
    }
    
    func clear(){
        reset()
    }
    
    func reloadFullFile(){
        reset()
        for chunk in logDocument.chunks{
            chunk.displayed = true
            appendText(string: chunk.string)
        }
    }
    
    private func appendColorMarkedText(_ string : String, font: NSFont, preferences: DocumentPreferences){
        let caseMode : NSString.CompareOptions = GlobalPreferences.shared.caseInsensitive ? .caseInsensitive : .literal
        let lines = string.components(separatedBy: "\n")
        for line in lines{
            if !line.isEmpty{
                appendColorMarkedLine(line, font: font, caseMode: caseMode, preferences: preferences)
            }
        }
    }
    
    private func appendColorMarkedLine(_ string : String, font: NSFont, caseMode: NSString.CompareOptions, preferences : DocumentPreferences){
        var parts = [TextPart]()
        for i in 0..<GlobalPreferences.numPatterns{
            if !preferences.patterns[i].isEmpty{
                var start = string.startIndex
                while let range = string.range(of: preferences.patterns[i], options: caseMode, range: start..<string.endIndex){
                    let textPart = TextPart(start: range.lowerBound, end: range.upperBound, color: GlobalPreferences.shared.textColors[i].color, background: GlobalPreferences.shared.backgroundColors[i].color)
                    parts.append(textPart)
                    start = range.upperBound
                }
            }
        }
        if parts.isEmpty{
            if preferences.skipUnmarked{
                return
            }
            appendUnmarkedText(string + "\n", font: font, showGray: GlobalPreferences.shared.showUnmarkedGray)
        }
        else{
            parts.sort{
                $0.start < $1.start
            }
            if logDocument.preferences.fullLineColoring{
                let part = parts[0]
                appendColoredText(string, color: part.color, background: part.background, font: font)
                appendDefaultText("\n", font: font)
            }
            else{
                var start = string.startIndex
                for part in parts{
                    if start >= part.end{
                        continue
                    }
                    if start < part.start{
                        appendDefaultText(String(string[start..<part.start]), font: font)
                        start = part.start
                    }
                    appendColoredText(String(string[start..<part.end]), color: part.color, background: part.background, font: font)
                    start = part.end
                }
                if string.endIndex > start{
                    appendDefaultText(String(string[start..<string.endIndex])+"\n", font: font)
                }
                else{
                    appendDefaultText("\n", font: font)
                }
            }
        }
    }
    
    private func appendColoredText(_ string : String, color: NSColor, background: NSColor, font: NSFont){
        textView.textStorage?.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.backgroundColor : background, NSAttributedString.Key.font : font]))
    }
    
    private func appendUnmarkedText(_ string : String, font: NSFont, showGray : Bool){
        let color = showGray ? NSColor.gray : NSColor.textColor
        textView.textStorage?.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : font]))
    }
    
    private func appendDefaultText(_ string : String, font: NSFont){
        textView.textStorage?.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : NSColor.textColor, NSAttributedString.Key.font : font]))
    }
    
}

class TextPart{
    
    var start : String.Index
    var end : String.Index
    var color : NSColor
    var background : NSColor
    
    init(start: String.Index, end: String.Index, color: NSColor, background: NSColor){
        self.start = start
        self.end = end
        self.color = color
        self.background = background
    }
}
