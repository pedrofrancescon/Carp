//
//  Login.swift
//  Carp
//
//  Created by Eldade Marcelino on 06/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class LoginView: View {

    lazy var mainStack: UIStackView = {
        let stack = View.fix(UIStackView())
        stack.axis = .vertical
        return stack
    }()

    lazy var header: View = {
        let container = View.fix(View())
        container.backgroundColor = UIColor(color: HexColors.lightGreen)
        return container
    }()

    lazy var headerStack: UIStackView = {
        let stack = View.fix(UIStackView())
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let title = View.fix(UILabel())
        title.font = UIFont.systemFont(ofSize: 24)
        title.textColor = UIColor(color: .greenText)
        title.text = "Bem-vindo!"
        return title
    }()

    lazy var introTextLabel: UILabel = {
        let introText = View.fix(UILabel())
        introText.text = "Você precisa estar conectado para procurar pessoas, isso ajuda na sua segurança e na de outros usuários."
        introText.textColor = UIColor(color: HexColors.greyText)
        introText.numberOfLines = 0
        introText.lineBreakMode = .byWordWrapping
        return introText
    }()

    lazy var emailField: LabelIconField = {
        let field = LabelIconField(labelText: "E-mail", iconCode: "\u{f007}")
        return field
    }()

    lazy var passwordField: LabelIconField = {
        let field = LabelIconField(labelText: "Senha", iconCode: "\u{f084}")
        return field
    }()

    override func setupView() {

        addSubview(mainStack)
        mainStack.constraintEdges(to: self)

        headerStack.addArrangedSubviews([titleLabel, introTextLabel])
        header.addSubview(headerStack)
        headerStack.constraintEdges(to: header, withMargin: 25)

        let fieldsContainer = View.fix(UIView())
        let fieldsStack = View.fix(UIStackView())
        fieldsStack.axis = .vertical
        fieldsContainer.addSubview(fieldsStack)
        fieldsStack.spacing = 10
        fieldsStack.addArrangedSubviews([emailField.view, passwordField.view])

        fieldsStack.topAnchor.constraint(equalTo: fieldsContainer.topAnchor, constant: 25).isActive = true
        fieldsStack.leftAnchor.constraint(equalTo: fieldsContainer.leftAnchor, constant: 25).isActive = true
        fieldsStack.rightAnchor.constraint(equalTo: fieldsContainer.rightAnchor, constant: -25).isActive = true

        mainStack.addArrangedSubviews([header, fieldsContainer])
    }
}
