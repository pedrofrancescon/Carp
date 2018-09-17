//
//  TextField.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 14/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override func layoutSubviews() {
        font = UIFont(name: "Lato-Regular", size: 15.0)
        textColor = UIColor(color: .darkGreyText)
        backgroundColor = UIColor(color: .softGreyBoxes)
        
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        leftViewMode = .always
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = paddingView
        
        super.draw(rect)
    }
    
}
