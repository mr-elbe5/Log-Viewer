/*
 Log-Viewer
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

protocol RadioGroupDelegate{
    func valueDidChangeTo(idx: Int, value: String)
}

class RadioGroup: NSView{
    
    var selectedIndex : Int = -1
    var selectedValue : String{
        if selectedIndex != -1{
            return radioViews[selectedIndex].title
        }
        return ""
    }
    
    var radioViews = Array<NSButton>()
    var stackView = NSStackView()
    
    var delegate: RadioGroupDelegate? = nil
    
    init(){
        super.init(frame: .zero)
        setRoundedBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(values: Array<String>, includingNobody: Bool = false){
        stackView.orientation = .vertical
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.fillSuperview()
        if includingNobody{
            let radioView = NSButton(radioButtonWithTitle: "nobody", target: self, action: #selector(radioIsSelected))
            radioViews.append(radioView)
            stackView.addArrangedSubview(radioView)
        }
        for i in 0..<values.count{
            let radioView = NSButton(radioButtonWithTitle: values[i], target: self, action: #selector(radioIsSelected))
            radioViews.append(radioView)
            stackView.addArrangedSubview(radioView)
        }
    }
    
    func select(index: Int){
        selectedIndex = index
        for i in 0..<radioViews.count{
            let radioView = radioViews[i]
            radioView.state = i == index ? .on : .off
        }
    }
    
    @objc func radioIsSelected(sender: AnyObject) {
        if let selectedRadio = sender as? NSButton{
            for i in 0..<radioViews.count{
                let radioView = radioViews[i]
                if radioView == selectedRadio{
                    radioView.state = .on
                    selectedIndex = i
                }
                else{
                    radioView.state = .off
                }
            }
            delegate?.valueDidChangeTo(idx: selectedIndex, value: selectedValue)
        }
    }
    
}

