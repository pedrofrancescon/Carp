//
//  Login.swift
//  Carp
//
//  Created by Eldade Marcelino on 06/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class LoginView: View {

    lazy var header: View = {
        let container = View.fix(View())
        let title = View.fix(UILabel())
        let introText = View.fix(UILabel())
        let stack = View.fix(UIStackView(arrangedSubviews: [title, introText]))
        title.font = UIFont.systemFont(ofSize: 24)
        title.text = "Bem-vindo!"
        introText.text = "Você precisa estar conectado para procurar pessoas, isso ajuda na sua segurança e na de outros usuários."
        introText.numberOfLines = 0
        introText.lineBreakMode = .byWordWrapping
        stack.axis = UILayoutConstraintAxis.vertical
        container.backgroundColor = .green
        container.addSubview(stack)
        stack.constraintEdges(to: container)
        return container
    }()

    override func setupView() {
        let testView = View.fix(View())
        testView.backgroundColor = .red
        addSubview(header)
        addSubview(testView)
        header.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        testView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        testView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        testView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        testView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
