//
//  UserDataManager.swift
//  Carp
//
//  Created by Eldade Marcelino on 04/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import Firebase

class UserDataManager {
    private let dbRef = Firestore.firestore()
    private let publicDataRef: CollectionReference
    private let privateDataRef: CollectionReference

    init() {
        publicDataRef = dbRef.collection("publicUserData")
        privateDataRef = dbRef.collection("privateDataRef")
    }

    func getPublicUserDataWith(uid: String, callback: @escaping (CarpUser?) -> Void) {
        publicDataRef.document(uid).getDocument { (snapshot, _) in
            guard let data = snapshot?.data(), let user = try? userFromDbFormat(data) else {
                callback(nil)
                return
            }
            callback(user)
        }
    }

    func getPrivateUserDataWith(uid: String, callback: @escaping (PrivateUserData?) -> Void) {
        privateDataRef.document(uid).getDocument { (snapshot, _) in
            guard let data = snapshot?.data(), let privateUserData = try? privateUserDataFromDbFormat(data) else {
                callback(nil)
                return
            }
            callback(privateUserData)
        }
    }
}
