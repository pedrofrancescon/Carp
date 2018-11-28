//
//  UIComponentProtocol.swift
//  Carp
//
//  Created by Eldade Marcelino on 22/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

protocol UIComponentProtocol {
    var view: UIView { get }
}

extension UIComponentProtocol {

    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }

    func addSubview(_ view: UIComponentProtocol) {
        self.view.addSubview(view)
    }
}
