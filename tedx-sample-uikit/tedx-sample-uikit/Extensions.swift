//
//  Extensions.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 4/21/22.
//

import UIKit


extension UIView {
    func centerView(x: Bool, y: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if x {
            if let centerX = superview?.centerXAnchor {
                self.centerXAnchor.constraint(equalTo: centerX).isActive = true
            }
        }
        
        if y {
            if let centerY = superview?.centerYAnchor {
                self.centerYAnchor.constraint(equalTo: centerY).isActive = true
            }
        }
    }
    
    func constraint(top: NSLayoutYAxisAnchor?, ct: CGFloat, bottom: NSLayoutYAxisAnchor?, cb: CGFloat, trail: NSLayoutXAxisAnchor?, ctr: CGFloat, lead: NSLayoutXAxisAnchor?, cl: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: ct).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: cb).isActive = true
        }
        if let trail = trail {
            self.trailingAnchor.constraint(equalTo: trail, constant: ctr).isActive = true
        }
        if let lead = lead {
            self.leadingAnchor.constraint(equalTo: lead, constant: cl).isActive = true
        }
    }
    
    func setSize(width: CGFloat?, height: CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    enum SizeType {
        case width
        case height
        case both
    }
    
    func setSize(view: UIView, multiplier: CGFloat, type: SizeType) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .width:
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        case .height:
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
        case .both:
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
            self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
        }
    }
}

extension UITextField {
    func setUpTextField(placeholder: String?, size: CGFloat, color: UIColor, align: NSTextAlignment) {
        if let place = placeholder {
            self.placeholder = place
        }
        
        self.font = UIFont(name: "Comfortaa-Regular", size: size)
        
        self.textColor = color
        self.textAlignment = align
        
        self.autocapitalizationType = .none
        self.inputAssistantItem.leadingBarButtonGroups = []
        self.inputAssistantItem.trailingBarButtonGroups = []
    }
}

extension UILabel {
    
    enum FontType {
        case display
        case regular
    }
    
    func setUpLabel(text: String?, color: UIColor, align: NSTextAlignment, font: FontType, size: CGFloat) {
        switch font {
        case .display:
            self.setUpLabel(text: text, color: color, align: align, font: "Megrim", size: size)
        case .regular:
            self.setUpLabel(text: text, color: color, align: align, font: "Comfortaa-Regular", size: size)
        }
    }
    
    func setUpLabel(text: String?, color: UIColor, align: NSTextAlignment, font: String, size: CGFloat) {
        self.text = text
        self.font = UIFont(name: font, size: size)
        self.textColor = color
        self.textAlignment = align
    }
    
}
