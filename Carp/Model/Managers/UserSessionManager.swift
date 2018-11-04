//
//  UserSessionManager.swift
//  Carp
//
//  Created by Eldade Marcelino on 04/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import Firebase

class UserSessionManager {

    private let authRef = Auth.auth()
    private let dbRef = Firestore.firestore()
    private var subscribers: [Int: (Bool) -> Void] = [:]
    private var loginStatusSubscriber: AuthStateDidChangeListenerHandle?
    
    init() {
        loginStatusSubscriber = authRef.addStateDidChangeListener({
            self.handleStatusChange(user: $1)
        })
    }
    
    func handleStatusChange(user: User?) {
        if let user = user {
            subscribers.forEach({ $0.value(true) })
        } else {
            subscribers.forEach({ $0.value(false) })
        }
    }
    
    func signIn(with socialCredential: SocialCredential, and errorHandler: @escaping (_ reason: String) -> Void) {
        var credential: AuthCredential
        switch socialCredential.provider {
        case SocialCredentialProvider.Facebook:
            credential = FacebookAuthProvider.credential(
                withAccessToken: socialCredential.token
            )
        case SocialCredentialProvider.Google:
            guard let idToken = socialCredential.idToken else {
                errorHandler("Invalid credentials format.")
                return
            }
            credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: socialCredential.token
            )
        }
        authRef.signInAndRetrieveData(
            with: credential,
            completion: { (_, error) in
                if let error = error {
                    errorHandler(error.localizedDescription)
                }
            }
        )
    }

    func subscribeToStatusChange(callback: @escaping (Bool) -> Void) -> () -> Void {
        let subscriberId = Int.random(in: 0...Int.max)
        subscribers[subscriberId] = callback
        return {
            if (self.subscribers.keys.contains(subscriberId)) {
                self.subscribers.removeValue(forKey: subscriberId)
            }
        }
    }
}
