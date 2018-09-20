//
//  Extensions.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 19/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(blur: CGFloat) {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 27/100
        layer.shadowRadius = blur
        layer.shadowOffset = CGSize.zero
        
    }
    
}
