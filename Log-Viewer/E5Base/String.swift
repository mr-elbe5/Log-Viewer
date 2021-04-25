//
//  E5String.swift
//  tomcatctrl
//
//  Created by Michael Rönnau on 30.11.20.
//

import Foundation

extension String {
    
    func localize() -> String{
        return NSLocalizedString(self,comment: "")
    }
    
    func localize(i: Int) -> String{
        return String(format: NSLocalizedString(self,comment: ""), String(i))
    }
    
    func localize(s: String) -> String{
        return String(format: NSLocalizedString(self,comment: ""), s)
    }
    
    func trim() -> String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
