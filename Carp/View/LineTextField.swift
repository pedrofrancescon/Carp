//
//  LineTextField.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 30/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class LineTextField: UITextField {
    
    static let max_digits = 4
    static var locale:Locale!
    
    var value: Float {
        
        get{
            Formatter.currency.locale = Locale.current
            let divider:Double = pow(Double(10), Double(Formatter.currency.maximumFractionDigits))
            
            if let t = text {
                return Float(t.numbers.integer) / Float(divider)
            } else {
                return 0.0
            }
        }
        
        set(newVal) {
            
            if newVal == 0 {
                text = ""
            } else {
                Formatter.currency.locale = Locale.current
                text = Formatter.currency.string(from: NSNumber(value: newVal))
            }
        }
    }
    
    var placeholderValue: Float {
        
        get {
            Formatter.currency.locale = Locale.current
            let divider:Double = pow(Double(10), Double(Formatter.currency.maximumFractionDigits))
            
            if let t = placeholder {
                return Float(t.numbers.integer) / Float(divider)
            } else{
                return 0.0
            }
        }
        
        set(newVal){
            Formatter.currency.locale = Locale.current
            
            let stringValue = Formatter.currency.string(from: NSNumber(value: newVal))
            
            guard stringValue != nil else { return }
            
            placeholder = "Preço sugerido: \(stringValue!)"
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func didMoveToSuperview() {
        keyboardType = .numberPad
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        Formatter.currency.locale = Locale.current
        
        font = UIFont(name: "Lato-Bold", size: 18.0)
        textColor = UIColor.darkGreyText
        backgroundColor = .white
        
        borderStyle = .none
        textAlignment = .center
        
        let viewHeight: CGFloat = 35.0
        
        frame.size.height = viewHeight
        
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGreyText.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        super.layoutSubviews()
        
        let placeholderAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 18.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.lightGreyText as Any
        ]
        
        let placeholderText = NSMutableAttributedString(string: "", attributes: placeholderAttributes)
        
        attributedPlaceholder = placeholderText
    }
    
    func setPlaceholderText(with number: Double) {
        
        let numberText = String(number)
        let max = String(numberText.numbers.prefix(LineTextField.max_digits))
        
        self.placeholderValue = (Float(max.numbers.integer) / 10.0)
        
    }
    
    @objc func editingChanged(_ textField: UITextField) {

        let max = String(string.numbers.prefix(LineTextField.max_digits))
        
        let divider:Double = pow(Double(10), Double(Formatter.currency.maximumFractionDigits))
        self.value = (Float(max.numbers.integer) / Float(divider))
    }
    
}

struct Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}

struct Numbers { static let characterSet = CharacterSet(charactersIn: "0123456789") }

