//
//  TextField.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 14/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class BoxTextField: UITextField {

    override func layoutSubviews() {
        font = UIFont(name: "Lato-Regular", size: 15.0)
        textColor = UIColor(color: .greyText)
        backgroundColor = UIColor(color: .lightGreyBoxes)
        
        super.layoutSubviews()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func draw(_ rect: CGRect) {
        leftViewMode = .always
        rightViewMode = .always
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = paddingView
        rightView = paddingView
        
        super.draw(rect)
    }
    
}
