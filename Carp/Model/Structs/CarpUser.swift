//
//  User.swift
//  Carp
//
//  Created by Eldade Marcelino on 21/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

// The name CarpUser is required to avoid conflicts with Firebase's User class
struct CarpUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePictureUrl: String
    let gender: String?
}

extension CarpUser: DatabaseRepresentation {
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "profilePictureUrl": profilePictureUrl,
            "gender": gender ?? ""
        ]
        
        return rep
    }
    
}
