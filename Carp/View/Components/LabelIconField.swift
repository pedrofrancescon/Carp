//
//  LabelIconField.swift
//  Carp
//
//  Created by Eldade Marcelino on 07/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

class LabelIconField {
    var view = View.fix(UIView())
    let label = View.fix(UILabel())
    lazy var icon: UILabel = {
        let icon = View.fix(UILabel())
        icon.font = UIFont(name: "FontAwesome5FreeSolid", size: 18)
        icon.textColor = UIColor(color: .darkGreyText)
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconTapped)))
        icon.textAlignment = .center
        icon.isUserInteractionEnabled = true
        icon.backgroundColor = UIColor(color: .lightGreyBoxes)
        return icon
    }()
    lazy var field: TextField = {
        let field = View.fix(TextField())
        field.backgroundColor = UIColor(color: .lightGreyBoxes)
        field.padding = UIEdgeInsetsFromString("{10,10,10,0}")
        return field
    }()
    init(labelText: String, iconCode: String, fieldHeight: CGFloat = 45) {
        label.text = labelText
        icon.text = iconCode
        view.addSubview(field)
        view.addSubview(label)
        view.addSubview(self.icon)
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        field.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        field.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3).isActive = true
        field.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        field.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        icon.heightAnchor.constraint(equalTo: field.heightAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: field.topAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    @objc
    func iconTapped() {
        field.becomeFirstResponder()
    }
}
