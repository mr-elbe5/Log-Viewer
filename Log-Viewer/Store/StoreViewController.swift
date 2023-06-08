/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

class StoreViewController:ViewController {
    
    var purchaseRadioGroup = RadioGroup()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        view.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        
        setupView()
    }
    
    func setupView(){
        let text  = NSTextField(labelWithString: "If you like this app, a tip is welcome but not mandatory. No features are hidden without it.")
        view.addSubview(text)
        text.placeBelow(anchor: view.topAnchor)
        if !Store.shared.loaded{
            print("store not loaded")
        }
        Store.shared.delegate = self
        var lastView : NSView = text
        if let purchasedProduct = Store.shared.purchasedProduct{
            let purchasedLabel = NSTextField(labelWithString: "Thank you for the tip '" + purchasedProduct.product.displayName + "'!")
            view.addSubview(purchasedLabel)
            purchasedLabel.placeBelow(view: lastView, insets: Insets.doubleInsets)
            lastView = purchasedLabel
        }
        else{
            view.addSubview(purchaseRadioGroup)
            purchaseRadioGroup.placeBelow(view: lastView)
            purchaseRadioGroup.setup(values: Store.shared.productDescriptions)
            
            let purchaseButton = NSButton(title: "Purchase", target: self, action: #selector(purchase))
            view.addSubview(purchaseButton)
            purchaseButton.placeBelow(view: purchaseRadioGroup)
            lastView = purchaseButton
        }
        lastView.bottom(view.bottomAnchor, inset: Insets.defaultInset)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateStoreSection(){
        view.removeAllSubviews()
        purchaseRadioGroup = RadioGroup()
        setupView()
    }
    
    @objc func purchase(){
        let value = purchaseRadioGroup.selectedIndex
        if value != -1{
            let selectedProductInfo = Store.shared.productInfos[value]
            selectedProductInfo.purchase()
            NSApp.stopModal()
        }
    }
    
}

extension StoreViewController: StoreDelegate{
    
    func storeChanged() {
        DispatchQueue.main.async {
            self.updateStoreSection()
        }
    }
    
}

