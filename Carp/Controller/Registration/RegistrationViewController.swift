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

    lazy var scrollView: UIScrollView = {
        let scrollView = View.fix(UIScrollView())
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    lazy var scrollContentView: View = {
        let view = View.fix(View())
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.constraintEdges(to: view)
        scrollView.addSubview(scrollContentView)
        scrollContentView.constraintEdges(to: scrollView)
        scrollContentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        scrollContentView.addSubviews([loginView, profilePictureView])
        loginView.leftAnchor.constraint(equalTo: scrollContentView.leftAnchor).isActive = true
        loginView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        loginView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        profilePictureView.leftAnchor.constraint(equalTo: loginView.rightAnchor).isActive = true
        profilePictureView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        profilePictureView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        profilePictureView.rightAnchor.constraint(equalTo: scrollContentView.rightAnchor).isActive = true

        Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) {_ in
            self.scrollView.scrollRectToVisible(self.profilePictureView.frame, animated: true)
        }
    }
}
