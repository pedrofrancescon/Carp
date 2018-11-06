//
//  Ride.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 18/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

enum NumberOfSeats: Int, Codable {
    case one = 1
    case two = 2
    case twree = 3
}

enum Restrictions: String, Codable, CaseIterable {
    case noRestriction = "Nenhuma Restrição"
    case sameSex = "Pessoas do mesmo sexo"
}

struct Ride: Codable {
    let origin: Place
    let destination: Place
    let timeInterval: DateInterval
    let numberOfSeats: NumberOfSeats
    let restriction: Restrictions
    let userId: String
    let id: String
    let priceEstimate: PriceEstimate
}
