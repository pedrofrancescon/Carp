//
//  Ride.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 18/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

enum NumberOfSeats: Int, Decodable {
    case one = 1
    case two = 2
    case twree = 3
}

enum Restrictions: String, Decodable {
    case womenOnly
}

struct Ride: Decodable {
    
    let origin: Place
    let destiny: Place
    let timeInterval: DateInterval
    let numberOfSeats: NumberOfSeats
    let restriction: Restrictions
    
}
