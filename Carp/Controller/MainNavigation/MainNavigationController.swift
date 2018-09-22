//
//  MainNavigationController.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        let navigationTitleAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 17.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white as Any
        ]
        
        navigationBar.barTintColor = UIColor(color: .mainGreen)
        navigationBar.titleTextAttributes = navigationTitleAttributes
        
        let mainVC = MainVC()
        setViewControllers([mainVC], animated: false)
        
        // Dismiss keyboard
        /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        navigationBar.addGestureRecognizer(tap)
        
    }
    
    init() {
        
        super.init(nibName: "MainNavigationController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        topViewController?.view.endEditing(true)
    }

}
