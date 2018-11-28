//
//  UserSessionManager.swift
//  Carp
//
//  Created by Eldade Marcelino on 04/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class UserSessionManager: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {

    static let shared = UserSessionManager()
    private let authRef = Auth.auth()
    private let dbRef = Firestore.firestore()
    private var subscribers: [Int: (Bool) -> Void] = [:]
    private var loginStatusSubscriber: AuthStateDidChangeListenerHandle?
    private var currentUser: CarpUser?
    private var googleSignInListener: ((_ token: (token: String, idToken: String)?) -> Void)?

    override init() {
        super.init()
        GIDSignIn.sharedInstance()?.delegate = self
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
        var subscriberId = Int.random(in: 0...Int.max)
        while subscribers.keys.contains(subscriberId) {
            subscriberId = Int.random(in: 0...Int.max)
        }
        subscribers[subscriberId] = callback
        return {
            if self.subscribers.keys.contains(subscriberId) {
                self.subscribers.removeValue(forKey: subscriberId)
            }
        }
    }

    func getFbToken(callback: @escaping (_ token: String?) -> Void) {
        FBSDKLoginManager().logIn(
            withReadPermissions: ["public_profile", "email"],
            from: nil
        ) { (loginResult, error) in
            if error != nil {
                callback(nil)
                return
            }
            if let token = loginResult?.token.tokenString {
                callback(token)
            }
        }
    }

    func getFbProfileData(callback: @escaping (_ data: SocialLoginData?) -> Void) {
        FBSDKGraphRequest(
            graphPath: "me?fields=id,name,email,gender,first_name,last_name",
            parameters: nil
        )?.start(completionHandler: { (_, result, error) in
            if error != nil {
                callback(nil)
                return
            }
            if let data = result as? [String: Any] {
                callback(SocialLoginData(
                    email: data["email"] as? String,
                    name: data["name"] as? String,
                    firstName: data["first_name"] as? String,
                    lastName: data["last_name"] as? String,
                    id: "\(data["id"] ?? "")")
                )
                return
            }
        })
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            googleSignInListener?(nil)
            print("Google SignIn error: \(error)")
            return
        }
        if let accessToken = user.authentication.accessToken, let idToken = user.authentication.idToken {
            googleSignInListener?((
                token: accessToken,
                idToken: idToken
            ))
            googleSignInListener = nil
        }
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) { }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) { }

    func getGToken(callback: @escaping (_ token: (token: String, idToken: String)?) -> Void) {
        googleSignInListener = callback
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    func getGProfileData(callback: @escaping (_ data: SocialLoginData?) -> Void) {
        if let currentUser = GIDSignIn.sharedInstance()?.currentUser, let profileData = currentUser.profile {
            callback(SocialLoginData(
                email: profileData.email,
                name: profileData.name,
                firstName: profileData.givenName,
                lastName: profileData.familyName,
                id: currentUser.userID)
            )
        } else {
            callback(nil)
        }
    }
}
