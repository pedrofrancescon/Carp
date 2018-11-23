//
//  Message.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 20/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import MessageKit

struct Message: Codable {
    let user: CarpUser
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: user.id, displayName: user.firstName)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
