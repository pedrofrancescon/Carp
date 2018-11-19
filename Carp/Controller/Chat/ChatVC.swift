//
//  ChatVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 13/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import MessageKit

class ChatVC: MessagesViewController {

    let inputContainerView: UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 48)
        view.addSubview(inputContainerView)
    }
    
    override var inputAccessoryView: UIView? {
        return nil
    }
    
    override func viewDidLayoutSubviews() {
        layoutContainerInputView()
        
        inputContainerView.addSubview(messageInputBar)
        messageInputBar.frame = inputContainerView.bounds
    }

    init() {
        inputContainerView = UIView()
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutContainerInputView() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: inputContainerView.frame.height).isActive = true
    }
    
}
