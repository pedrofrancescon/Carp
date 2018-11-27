//
//  Extensions.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static var mainGreen = UIColor(rgb: 0x087443)
    static var green = UIColor(rgb: 0x388F68)
    static var greenText = UIColor(rgb: 0x489773)
    static var lightGreen = UIColor(rgb: 0xEEF5F2)
    static var mainBlue = UIColor(rgb: 0x4A90E2)
    static var mainOrange = UIColor(rgb: 0xF5A623)
    static var lightGreyBoxes = UIColor(rgb: 0xF5F5F5)
    static var greyIcon = UIColor(rgb: 0x6D6D6D)
    static var greyText = UIColor(rgb: 0x3F3F3F)
    static var lightGreyText = UIColor(rgb: 0xAEAEAE)
    static var darkGreyText = UIColor(rgb: 0x717171)
    static var greyChatBubble = UIColor(rgb: 0xF5F5F5)
    static var darkGreyChatText = UIColor(rgb: 0x494949)
}

