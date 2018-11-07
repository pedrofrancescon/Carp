//
//  UIViewExtensions.swift
//  Carp
//
//  Created by Eldade Marcelino on 06/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func setupView() { }

    static func fix<T: UIView>(_ view: T) -> T {
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension UIView {
    func constraintEdges(to view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
