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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init() {
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
