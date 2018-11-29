//
//  Fonts.swift
//  Carp
//
//  Created by Eldade Marcelino on 29/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func getAvailableFonts() {
        for family: String in UIFont.familyNames {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}
