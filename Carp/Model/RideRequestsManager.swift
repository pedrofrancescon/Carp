//
//  RideRequestsManager.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 24/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import Firebase

class RideRequestsManager {
    
    static var rideRequestsManager = RideRequestsManager()
    
    private let db = Firestore.firestore()
    
    func createRide(_ ride: Ride) {
        
        var ref: DocumentReference? = nil
        ref = db.collection("ride-requests").addDocument(data: RideToDbFormat(ride: ride)) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
    
}
