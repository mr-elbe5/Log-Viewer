/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa


public class OpenDocumentDialog: NSWindowController, NSWindowDelegate {
    
    var url : URL?{
        get{
            (contentViewController as! OpenDocumentViewController).url
        }
    }
    
    var type : LogType{
        get{
            (contentViewController as! OpenDocumentViewController).type
        }
    }
    
    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), styleMask: [.closable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Open Log File"
        super.init(window: window)
        self.window?.delegate = self
        let controller = OpenDocumentViewController()
        contentViewController = controller
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        window?.makeKeyAndOrderFront(nil)
    }
    
    public func windowWillClose(_ notification: Notification) {
        NSApp.stopModal(withCode: url != nil ? .OK : .cancel)
    }

}

class OpenDocumentViewController: ViewController {
    
    var url : URL? = nil
    var type: LogType = .file
    
    override public func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        
        let scrollView = NSScrollView()
        let contentView = NSView()
        scrollView.asVerticalScrollView(inView: view, contentView: contentView)
        
        var lastView: NSView? = nil
        let logDescriptors = LogDocumentPool.shared.documentHistory
        if logDescriptors.isEmpty{
            let label = NSTextField(labelWithString: "There are no recent files")
            contentView.addSubview(label)
            label.placeBelow(anchor: contentView.topAnchor, insets: Insets.defaultInsets)
            lastView = label
        }
        else{
            for descriptor in logDescriptors{
                var selector : Selector
                switch descriptor.type{
                case .file:
                    selector = #selector(openRecentFile)
                case .remote:
                    selector = #selector(openRecentRemote)
                }
                let button = NSButton(title: descriptor.path, target: self, action: selector)
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
    
    @objc open func openRecentFile(sender: Any){
        if let button = sender as? NSButton{
            url = URL(fileURLWithPath: button.title)
            self.type = .file
            view.window?.close()
        }
    }
    
    @objc open func openRecentRemote(sender: Any){
        self.type = .remote
    }
    
    @objc open func open(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        if NSApp.runModal(for: panel) == .OK, let url = panel.urls.first{
            self.url = url
            self.type = .file
            view.window?.close()
        }
    }
    
    
    
}


