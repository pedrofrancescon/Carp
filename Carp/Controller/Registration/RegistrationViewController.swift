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

    lazy var profilePictureView = {
        View.fix(ProfilePictureView())
    }()

    lazy var scrollView = HorizontalPagedScrollView([loginView])

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(scrollView.view)
        scrollView.view.constraintEdges(to: view)
        loginView.continueAction = {
            self.scrollView.addView(self.profilePictureView)
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { _ in
                self.scrollView.scrollView.scrollRectToVisible(self.profilePictureView.frame, animated: true)
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
