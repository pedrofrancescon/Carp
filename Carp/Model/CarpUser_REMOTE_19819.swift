//
//  User.swift
//  Carp
//
//  Created by Eldade Marcelino on 21/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

// The name CarpUser is required to avoid conflicts with Firebase's User class
struct CarpUser {
    var id: String
    var firstName: String
    var lastName: String
    var profilePictureUrl: String
    var gender: String?
    var privateData: PrivateUserData?
}

struct PrivateUserData {
    var email: String
    var phoneNumber: String
    var documentInfo: DocumentInfo
}

struct DocumentInfo {
    var country: String
    var number: String
    var type: String
}

struct SocialLoginData {
    var email: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    var id: String?
}