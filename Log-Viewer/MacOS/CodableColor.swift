/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import Cocoa

class CodableColor : Codable{
    
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
    }
    
    private var red : CGFloat = 0.0
    private var green : CGFloat = 0.0
    private var blue : CGFloat = 0.0
    private var alpha : CGFloat = 1.0
    private var nsColor : NSColor!
    
    var color : NSColor{
        get{
            return nsColor
        }
        set{
            self.red = newValue.redComponent
            self.green = newValue.greenComponent
            self.blue = newValue.blueComponent
            self.alpha = newValue.alphaComponent
            self.nsColor = newValue
        }
    }

    init(){
        nsColor = NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0){
        update(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(color: NSColor){
        self.red = color.redComponent
        self.green = color.greenComponent
        self.blue = color.blueComponent
        self.alpha = color.alphaComponent
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        red = try values.decodeIfPresent(CGFloat.self, forKey: .red) ?? 0.0
        green = try values.decodeIfPresent(CGFloat.self, forKey: .green) ?? 0.0
        blue = try values.decodeIfPresent(CGFloat.self, forKey: .blue) ?? 0.0
        alpha = try values.decodeIfPresent(CGFloat.self, forKey: .alpha) ?? 1.0
        nsColor = NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }
    
    func update(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0){
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        nsColor = NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
    
}
