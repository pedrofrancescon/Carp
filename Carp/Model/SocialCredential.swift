//
//  SocialCredential.swift
//  Carp
//
//  Created by Eldade Marcelino on 04/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

struct SocialCredential {
    var idToken: String?
    var token: String
    var provider: SocialCredentialProvider
}

enum SocialCredentialProvider {
    case Facebook
    case Google
}
