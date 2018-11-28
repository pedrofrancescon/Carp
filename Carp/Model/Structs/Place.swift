//
//  Place.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

struct Place: Codable {
    let name: String
    let locations: Locations
    
    enum CodingKeys : String, CodingKey {
        case name
        case locations = "geometry"
    }
}

struct Locations: Codable {
    let coordinate: Coordinate
    let viewPortBounds: ViewPortBounds
    
    enum CodingKeys : String, CodingKey {
        case coordinate = "location"
        case viewPortBounds = "viewport"
    }
}

struct Coordinate: Codable {
    static let zero = Coordinate(lat: 0, lng: 0)
    let lat: Double
    let lng: Double
    var clLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

struct ViewPortBounds: Codable {
    let northeast: Coordinate
    let southwest: Coordinate
    
    var gmsViewPortBounds: GMSCoordinateBounds {
        return GMSCoordinateBounds(coordinate: northeast.clLocation, coordinate: southwest.clLocation)
    }
}
