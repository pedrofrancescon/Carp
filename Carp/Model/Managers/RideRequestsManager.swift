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
    private let dbRef = Firestore.firestore()

    func createRide(_ ride: Ride, callback: @escaping (_ error: Bool, _ docId: String) -> Void) {
        var ref: DocumentReference?
        ref = dbRef.collection("ride-requests").addDocument(data: rideToDbFormat(ride: ride)) { (err) in
            if err != nil {
                callback(true, ref?.documentID ?? "")
            } else {
                callback(false, ref?.documentID ?? "")
            }
        }
    }

    func findMatches(_ ride: Ride, onUpdate: @escaping ([Car]) -> Void) -> ListenerRegistration {
        return dbRef.collection("cars").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Could not retrieve matches: \(error)")
            } else {
                snapshot?.documents.forEach({ doc in
                    guard let hostRideId = doc.data()["hostRequest"] as? String else {
                        return
                    }
                    self
                        .dbRef
                        .document("ride-requests/\(hostRideId)")
                        .getDocument(completion: { (rideRef, error) in
                        if let error = error {
                            print("Could not retrieve host ride: \(error)")
                        } else {
                            guard let rideRef = rideRef,
                                let ride = try? rideFromDbFormat(
                                    docId: rideRef.documentID,
                                    rideRef.data() ?? [:]
                                ) else { return }

                            guard let car = try? carFromDbFormat(
                                docId: doc.documentID,
                                riders: [],
                                owner: ride,
                                doc.data()
                            ) else { return }

                            onUpdate([car])
                        }
                    })
                })
            }
        })
    }
}
