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
    
    convenience init(color: HexColors) {
        let rgb = color.rawValue
        
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

enum HexColors: Int {
    case mainGreen = 0x087443
    case green = 0x388F68
    case greenText = 0x489773
    case lightGreen = 0xEEF5F2
    case mainBlue = 0x4A90E2
    case mainOrange = 0xF5A623
    case lightGreyBoxes = 0xF5F5F5
    case greyIcon = 0x6D6D6D
    case greyText = 0x3F3F3F
    case lightGreyText = 0xAEAEAE
    case darkGreyText = 0x717171
}

