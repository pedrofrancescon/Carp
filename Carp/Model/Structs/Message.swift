//
//  Message.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 20/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore

struct Message: Codable {
    let user: CarpUser
    let text: String
    let messageId: String
    let sentDate: Date //Needed for MessageType extension
    
    init(user: CarpUser, text: String, messageId: String) {
        self.user = user
        self.text = text
        self.messageId = messageId
        self.sentDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let created = data["created"] as? Date else {
            return nil
        }
        guard let text = data["content"] as? String else {
            return nil
        }
        guard let userDictionary = data["user"] as? [String : Any] else {
            return nil
        }
        guard let messageId = data["messageID"] as? String else {
            return nil
        }
        
        let user = CarpUser(id: userDictionary["id"] as! String,
                            firstName: userDictionary["firstName"] as! String,
                            lastName: userDictionary["lastName"] as! String,
                            profilePictureUrl: userDictionary["profilePictureUrl"] as! String,
                            gender: userDictionary["gender"] as? String)
        
        self.messageId = messageId
        self.user = user
        self.text = text
        self.sentDate = created
    }
    
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: user.id, displayName: user.firstName)
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "created": sentDate,
            "messageID": messageId,
            "user": user.representation,
            "content": text
        ]
        
        return rep
    }
    
}

extension Message: Comparable {
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}
