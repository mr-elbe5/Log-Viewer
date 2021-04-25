//
//  DefaultInsets.swift
//  tomcatctrl
//
//  Created by Michael Rönnau on 01.12.20.
//

import Foundation

struct Insets {
    
    static var defaultInset : CGFloat = 10
    
    static var defaultInsets : NSEdgeInsets = .init(top: defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset)
    
    static var flatInsets : NSEdgeInsets = .init(top: 0, left: defaultInset, bottom: 0, right: defaultInset)
    
    static var narrowInsets : NSEdgeInsets = .init(top: defaultInset, left: 0, bottom: defaultInset, right: 0)
    
    static var reverseInsets : NSEdgeInsets = .init(top: -defaultInset, left: -defaultInset, bottom: -defaultInset, right: -defaultInset)
    
    static var doubleInsets : NSEdgeInsets = .init(top: 2 * defaultInset, left: 2 * defaultInset, bottom: 2 * defaultInset, right: 2 * defaultInset)
    
}
