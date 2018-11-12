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
    
    func addShadow(blur: CGFloat, opacity: Float) {
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
        layer.shadowOffset = CGSize.zero
    }
    
}

extension UITextField {
    var string: String { return text ?? "" }
}

extension String {
    var numbers: String { return components(separatedBy: Numbers.characterSet.inverted).joined() }
    var integer: Int { return Int(numbers) ?? 0 }
}

extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
        self.currencySymbol = self.currencySymbol.appending(" ")
    }
}

extension Notification.Name {
    static let slidginViewStateChanged = Notification.Name(
        rawValue: "slidginViewStateChanged")
}

extension UIViewController {
    func addChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    func removeFromParentVC() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
