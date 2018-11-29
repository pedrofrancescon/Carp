//
//  SeparatorLabel.swift
//  Carp
//
//  Created by Eldade Marcelino on 22/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class SeparatorLabel: UIComponentProtocol {

    private let label: UILabel = {
        let label = View.fix(UILabel())
        label.textColor = UIColor.lightGreyText
        return label
    }()

    private lazy var leftSep: UIView = {
        let view = View.fix(UIView())
        view.backgroundColor = UIColor.lightGreyBoxes
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        return view
    }()

    private lazy var rightSep: UIView = {
        let view = View.fix(UIView())
        view.backgroundColor = UIColor.lightGreyBoxes
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        return view
    }()

    let view = View.fix(UIView())

    init(text: String) {
        label.text = text
        view.addSubviews([label, leftSep, rightSep])
        view.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        leftSep.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        leftSep.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        leftSep.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -10).isActive = true
        rightSep.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rightSep.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        rightSep.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
