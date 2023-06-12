/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa


public class OpenRemoteLogDialog: NSWindowController, NSWindowDelegate {
    
    var server: String = ""
    
    init(){
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), styleMask: [.closable, .titled, .resizable], backing: .buffered, defer: false)
        window.title = "Open Remote Log File"
        super.init(window: window)
        self.window?.delegate = self
        let controller = OpenRemoteLogViewController()
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
        NSApp.stopModal(withCode: !server.isEmpty ? .OK : .cancel)
    }

}

class OpenRemoteLogViewController: ViewController {
    
    var server : String? = nil
    
    override public func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        
        let scrollView = NSScrollView()
        let contentView = NSView()
        scrollView.asVerticalScrollView(inView: view, contentView: contentView)
        
        
        let openButton = NSButton(title: "Open...", target: self, action: #selector(open))
        view.addSubview(openButton)
        openButton.placeBelow(anchor: scrollView.bottomAnchor, insets: Insets.defaultInsets)
        openButton.refusesFirstResponder = true
        openButton.bottom(view.bottomAnchor, inset: Insets.defaultInset)
    }
    
    @objc open func open(){
        
    }
    
    
    
}


