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

class Place {
    
    var name: String
    var coordinate: CLLocationCoordinate2D
    var viewPortBounds: GMSCoordinateBounds
    
    init() {
        name = ""
        coordinate = CLLocationCoordinate2D()
        viewPortBounds = GMSCoordinateBounds()
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D, viewPort: GMSCoordinateBounds) {
        self.name = name
        self.coordinate = coordinate
        self.viewPortBounds = viewPort
    }
    
    init(json: [String: Any]) {
        name = ""
        coordinate = CLLocationCoordinate2D()
        viewPortBounds = GMSCoordinateBounds()
        
        guard let name = json[keyPath: "result.name"] as? String else { return }
        self.name = name
        
        guard let latitude = json[keyPath: "result.geometry.location.lat"] as? Double else { return }
        guard let longitude = json[keyPath: "result.geometry.location.lng"] as? Double else { return }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        guard let ne_latitude = json[keyPath: "result.geometry.viewport.northeast.lat"] as? Double else { return }
        guard let ne_longitude = json[keyPath: "result.geometry.viewport.northeast.lng"] as? Double else { return }
        let northeastCoordinates = CLLocationCoordinate2D(latitude: ne_latitude, longitude: ne_longitude)
        
        guard let sw_latitude = json[keyPath: "result.geometry.viewport.southwest.lat"] as? Double else { return }
        guard let sw_longitude = json[keyPath: "result.geometry.viewport.southwest.lng"] as? Double else { return }
        let southwestCoordinates = CLLocationCoordinate2D(latitude: sw_latitude, longitude: sw_longitude)
        
        self.viewPortBounds = GMSCoordinateBounds(coordinate: northeastCoordinates, coordinate: southwestCoordinates)
        
    }
    
}
