/*
 SwiftyMacViewExtensions
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Cocoa

extension NSView{
    
    var highPriority : Float{
        get{
            900
        }
    }

    var midPriority : Float{
        get{
            500
        }
    }

    var lowPriority : Float{
        get{
            300
        }
    }

    static var defaultPriority : Float{
        get{
            900
        }
    }

    func setRoundedBorders(){
        if let layer = layer{
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
        }
    }

    func setGrayRoundedBorders(){
        if let layer = layer{
            layer.borderColor = NSColor.lightGray.cgColor
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
        }
    }

    func resetConstraints(){
        for constraint in constraints{
            constraint.isActive = false
        }
    }

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

    func setCentral(view: NSView){
        setAnchors()
            .centerX(view.centerXAnchor)
            .centerY(view.centerYAnchor)
    }

    func placeBelow(anchor: NSLayoutYAxisAnchor, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }

    func placeBelow(view: NSView, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        placeBelow(anchor: view.bottomAnchor, insets: insets, priority : priority)
    }

    func placeAbove(anchor: NSLayoutYAxisAnchor, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .bottom(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }

    func placeAbove(view: NSView, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        placeAbove(anchor: view.topAnchor, insets: insets, priority : priority)
    }

    func connectBottom(view: NSView, insets: CGFloat = Insets.defaultInset,priority: Float = defaultPriority){
        bottom(view.bottomAnchor, inset: insets, priority : priority)
    }

    func placeBefore(anchor: NSLayoutXAxisAnchor, insets: NSEdgeInsets = Insets.defaultInsets, priority: Float = defaultPriority){
        setAnchors()
            .trailing(anchor, inset: insets.right, priority : priority)
            .top(superview?.topAnchor, inset: insets.top, priority : priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }

    func placeBefore(view: NSView, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        placeBefore(anchor: view.leadingAnchor, insets: insets, priority: priority)
    }

    func placeAfter(anchor: NSLayoutXAxisAnchor, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .leading(anchor,inset: insets.left, priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }

    func placeAfter(view: NSView, insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        placeAfter(anchor: view.trailingAnchor, insets: insets, priority : priority)
    }

    func placeXCentered(insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .centerX(superview?.centerXAnchor,priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }

    func placeTopRight(insets: NSEdgeInsets = Insets.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(superview?.topAnchor, inset: insets.top, priority: priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority: priority)
    }
    
    @discardableResult
    func setAnchors() -> NSView{
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = topAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ anchor: NSLayoutXAxisAnchor?,priority: Float = defaultPriority) -> NSView{
        if anchor != nil{
            let constraint = centerXAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ anchor: NSLayoutYAxisAnchor?,priority: Float = defaultPriority) -> NSView{
        if anchor != nil{
            let constraint = centerYAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        widthAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat,priority: Float = defaultPriority) -> NSView{
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        heightAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func setSquareByWidth(priority: Float = defaultPriority) -> NSView{
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = NSLayoutConstraint.Priority(priority)
        addConstraint(c)
        return self
    }
    
    @discardableResult
    func setSquareByHeight(priority: Float = defaultPriority) -> NSView{
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = NSLayoutConstraint.Priority(priority)
        addConstraint(c)
        return self
    }
    
    @discardableResult
    func removeAllConstraints() -> NSView{
        for constraint in constraints{
            removeConstraint(constraint)
        }
        return self
    }

    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func removeSubview(_ view : NSView) {
        for subview in subviews {
            if subview == view{
                subview.removeFromSuperview()
                break
            }
        }
    }

}

