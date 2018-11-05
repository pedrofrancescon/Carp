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
    private var currentUser: CarpUser?

    init() {
        loginStatusSubscriber = authRef.addStateDidChangeListener({
            self.handleStatusChange(user: $1)
        })
    }
    
    deinit {
        if let handler = loginStatusSubscriber {
            authRef.removeStateDidChangeListener(handler)
        }
    }

    func handleStatusChange(user: User?) {
        if let user = user {
            UserDataManager.shared.getPublicUserDataWith(uid: user.uid) { publicData in
                UserDataManager.shared.getPrivateUserDataWith(uid: user.uid) { privateData in
                    if let publicData = publicData, let privateData = privateData {
                        self.currentUser = publicData
                        self.currentUser?.privateData = privateData
                        self.subscribers.forEach({ $0.value(true) })
                    } else {
                        self.subscribers.forEach({ $0.value(false) })
                    }
                }
            }
        } else {
            subscribers.forEach({ $0.value(false) })
        }
    }

    func signIn(with socialCredential: SocialCredential, errorHandler: @escaping (_ reason: String) -> Void) {
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
    
    func signIn(email: String, password: String, errorHandler: @escaping (_ reason: String) -> Void) {
        authRef.signIn(
            withEmail: email,
            password: password,
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
            if self.subscribers.keys.contains(subscriberId) {
                self.subscribers.removeValue(forKey: subscriberId)
            }
        }
    }
}
