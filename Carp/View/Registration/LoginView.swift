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
        let title = View.fix(UILabel()).defaultFont()
        title.font = UIFont.systemFont(ofSize: 24)
        title.textColor = UIColor(color: .greenText)
        title.text = "Bem-vindo!"
        return title
    }()

    lazy var introTextLabel: UILabel = {
        let introText = View.fix(UILabel()).defaultFont()
        introText.text = "Você precisa estar conectado para procurar pessoas, isso ajuda na sua segurança e na de outros usuários."
        introText.textColor = UIColor(color: HexColors.greyText)
        introText.numberOfLines = 0
        introText.lineBreakMode = .byWordWrapping
        return introText
    }()

    let fieldsContainer = View.fix(UIView())
    let fieldsStack = View.fix(UIStackView())

    lazy var emailField: LabelIconField = {
        let field = LabelIconField(labelText: "E-mail", iconCode: "\u{f007}")
        field.field.keyboardType = .emailAddress
        field.onKeyboardReturn = { email in
            print(email.text ?? "NADA")
            email.resignFirstResponder()
        }
        return field
    }()

    lazy var passwordField: LabelIconField = {
        let field = LabelIconField(labelText: "Senha", iconCode: "\u{f084}")
        field.field.isSecureTextEntry = true
        field.onKeyboardReturn = { password in
            print(password.text ?? "NADA")
            password.resignFirstResponder()
        }
        return field
    }()

    lazy var forgotPassword: TouchHighlightLabel = {
        let label = View.fix(TouchHighlightLabel())
        label.text = "Esqueceu sua senha?"
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(color: HexColors.greenText)
        label.font = label.font.withSize(UIFont.buttonFontSize * 0.8)
        label.textAlignment = .right
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped)))
        return label
    }()

    let separator = SeparatorLabel(text: "ou")
    let facebookButton = SocialButton(text: "Continuar com o Facebook",
                                      color: UIColor(red: 68/255, green: 109/255, blue: 176/255, alpha: 1),
                                      icon: "\u{f39e}")
    let googleButton = SocialButton(text: "Continuar com o Google",
                                      color: UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1),
                                      icon: "\u{f1a0}")
    var continueAction: (() -> Void)? {
        set {
            facebookButton.touchHandler = newValue
            googleButton.touchHandler = newValue
        }
        get {
            return nil
        }
    }

    override func setupView() {

        addSubview(mainStack)
        mainStack.constraintEdges(to: self)

        headerStack.addArrangedSubviews([titleLabel, introTextLabel])
        header.addSubview(headerStack)
        headerStack.constraintEdges(to: header, withMargin: 25)

        fieldsStack.axis = .vertical
        fieldsContainer.addSubview(fieldsStack)
        fieldsStack.spacing = 10
        fieldsStack.addArrangedSubviews([
            emailField.view,
            passwordField.view,
            forgotPassword,
            separator.view,
            facebookButton.view,
            googleButton.view
        ])
        fieldsStack.topAnchor.constraint(equalTo: fieldsContainer.topAnchor, constant: 25).isActive = true
        fieldsStack.leftAnchor.constraint(equalTo: fieldsContainer.leftAnchor, constant: 25).isActive = true
        fieldsStack.rightAnchor.constraint(equalTo: fieldsContainer.rightAnchor, constant: -25).isActive = true
        fieldsStack.setCustomSpacing(25, after: forgotPassword)
        fieldsStack.setCustomSpacing(25, after: separator.view)

        mainStack.addArrangedSubviews([header, fieldsContainer])
    }

    @objc
    func forgotPasswordTapped() {
        print("Motherfucker forgot the freakin' password.")
    }
}
