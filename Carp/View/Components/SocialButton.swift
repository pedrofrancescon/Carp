//
//  SocialButton.swift
//  Carp
//
//  Created by Eldade Marcelino on 22/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class SocialButton: UIComponentProtocol {

    let view = View.fix(UIView())
    private lazy var label: UILabel = {
        let label = View.fix(UILabel())
        label.textColor = .white
        return label
    }()
    private lazy var iconLabel: UILabel = {
        let label = View.fix(UILabel())
        label.textColor = .white
        label.font = UIFont(name: "FontAwesome5BrandsRegular", size: 18)
        return label
    }()
    private lazy var button: UIButton = {
        let button = View.fix(UIButton())
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()

    init(text: String, color: UIColor, icon: String?) {
        label.text = text
        view.backgroundColor = color
        view.addSubviews([label, button])
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.constraintEdges(to: view)
        if let icon = icon {
            iconLabel.text = icon
            addSubview(iconLabel)
            iconLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            iconLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        }
    }
}
