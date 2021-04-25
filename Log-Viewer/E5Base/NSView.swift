//
//  NSView.swift
//  tomcatctrl
//
//  Created by Michael Rönnau on 30.11.20.
//

import Cocoa

extension NSView{
    
    func fillSuperview(insets: NSEdgeInsets = NSEdgeInsets()){
        if let sv = superview{
            fillView(view: sv, insets: insets)
        }
    }
    
    func fillView(view: NSView, insets: NSEdgeInsets = NSEdgeInsets()){
        setAnchors()
            .leading(view.leadingAnchor,inset: insets.left)
            .top(view.topAnchor,inset: insets.top)
            .trailing(view.trailingAnchor,inset: insets.right)
            .bottom(view.bottomAnchor,inset: insets.bottom)
    }
    
    func placeBelow(anchor: NSLayoutYAxisAnchor, insets: NSEdgeInsets = Insets.defaultInsets){
        setAnchors()
            .top(anchor,inset: insets.top)
            .leading(superview?.leadingAnchor,inset: insets.left)
            .trailing(superview?.trailingAnchor, inset: insets.right)
    }
    
    @discardableResult
    func setAnchors() -> NSView{
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0) -> NSView{
        if let anchor = anchor{
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: inset)
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0) -> NSView{
        if let anchor = anchor{
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -inset)
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0) -> NSView{
        if let anchor = anchor{
            let constraint = topAnchor.constraint(equalTo: anchor, constant: inset)
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0) -> NSView{
        if let anchor = anchor{
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -inset)
            constraint.isActive = true
        }
        return self
    }
    
}

