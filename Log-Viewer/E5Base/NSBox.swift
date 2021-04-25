//
//  NSBox.swift
//  Log-Viewer
//
//  Created by Michael Rönnau on 10.12.20.
//

import Foundation

import Cocoa

extension NSBox{
    
    func asSeparator() -> NSBox{
        self.boxType = .separator
        return self
    }
    
}
