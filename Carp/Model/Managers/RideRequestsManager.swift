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
    
    func findMatches(_ ride: Ride, onUpdate: @escaping ([Car]) -> Void) -> ListenerRegistration {
        return db.collection("cars").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Could not retrieve matches: \(error)")
            } else {
                snapshot!.documents.forEach({ doc in
                    let hostRideId = doc.data()["hostRequest"] as! String
                    self
                        .db
                        .document("ride-requests/\(hostRideId)")
                        .getDocument(completion: { (rideRef, error) in
                        if let error = error {
                            print("Could not retrieve host ride: \(error)")
                        } else {
                            let ride = try! RideFromDbFormat(docId: rideRef!.documentID, rideRef!.data() ?? [:])
                            onUpdate([try? CarFromDbFormat(docId: doc.documentID, riders: [], owner: ride, doc.data())].filter({ $0 != nil }) as! [Car])
                        }
                    })
                })
            }
        })
    }
}
