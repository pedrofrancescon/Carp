//
//  LineTextField.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 30/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class LineTextField: UITextField {
    
    override func layoutSubviews() {
        font = UIFont(name: "Lato-Bold", size: 19.0)
        textColor = UIColor(color: .darkGreyText)
        backgroundColor = .white
        
        borderStyle = .none
        textAlignment = .center
        
        let viewHeight: CGFloat = 35.0
        
        frame.size.height = viewHeight
        
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(color: .lightGreyText).cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        super.layoutSubviews()
        
        guard let placeholder = placeholder else { return }
        
        let placeholderAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 19.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor(color: .lightGreyText) as Any
        ]
        
        let placeholderText = NSMutableAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        attributedPlaceholder = placeholderText
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}
