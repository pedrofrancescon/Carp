//
//  LabelIconField.swift
//  Carp
//
//  Created by Eldade Marcelino on 07/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

class LabelIconField: NSObject, UITextFieldDelegate, UIComponentProtocol {
    var view = View.fix(UIView())

    let label: UILabel = {
        let label = View.fix(UILabel()).defaultFont()
        label.textColor = UIColor.lightGreyText
        return label
    }()

    lazy var icon: UILabel = {
        let icon = View.fix(UILabel())
        icon.font = UIFont(name: "FontAwesome5FreeSolid", size: 18)
        icon.textColor = .darkGreyText
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconTapped)))
        icon.textAlignment = .center
        icon.isUserInteractionEnabled = true
        icon.backgroundColor = UIColor.lightGreyBoxes
        return icon
    }()

    lazy var field: TextField = {
        let field = View.fix(TextField())
        field.textColor = UIColor.darkGreyText
        field.backgroundColor = UIColor.lightGreyBoxes
        field.padding = NSCoder.uiEdgeInsets(for: "{10,10,10,0}")
        field.delegate = self
        return field
    }()

    var onKeyboardReturn: ((UITextField) -> Void)?

    init(labelText: String, iconCode: String, fieldHeight: CGFloat = 45) {
        super.init()
        label.text = labelText
        icon.text = iconCode
        view.addSubviews([field, label, self.icon])
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onKeyboardReturn?(textField)
        return true
    }
}
