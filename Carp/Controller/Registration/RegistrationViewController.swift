//
//  RegistrationViewController.swift
//  Carp
//
//  Created by Eldade Marcelino on 05/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    lazy var loginView = {
        View.fix(LoginView())
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.constraintEdges(to: view)
    }
}
