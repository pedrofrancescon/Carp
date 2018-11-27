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
    
    init(id: String, firstName: String, lastName: String, profilePictureUrl: String, gender: String?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePictureUrl = profilePictureUrl
        self.gender = gender
    }
    
    init?(representation: [String : Any]) {
        guard let id = representation["id"] as? String else { return nil }
        guard let firstName = representation["firstName"] as? String else { return nil }
        guard let lastName = representation["lastName"] as? String else { return nil }
        guard let profilePictureUrl = representation["profilePictureUrl"] as? String else { return nil }
        guard let gender = representation["gender"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePictureUrl = profilePictureUrl
        self.gender = gender
        
    }
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
