//
//  MapView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView {

    private var originMapMarker: GMSMarker = GMSMarker()
    private var destinyMapMarker: GMSMarker = GMSMarker()
    
    override func layoutSubviews() {
        originMapMarker.icon = UIImage(named: "origin_map_marker")
        originMapMarker.appearAnimation = .pop
        originMapMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        destinyMapMarker.icon = UIImage(named: "destiny_map_marker")
        destinyMapMarker.appearAnimation = .pop
        destinyMapMarker.groundAnchor = CGPoint(x: 0.5, y: 0.91)
        
        settings.allowScrollGesturesDuringRotateOrZoom = false
        settings.myLocationButton = true
        isMyLocationEnabled = true
        
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func createMapMarker(of placeType: PlaceType, with place: Place) {
        
        isMyLocationEnabled = false
        
        switch placeType {
        case .origin:
            originMapMarker.position = place.locations.coordinate.clLocation
            originMapMarker.title = place.name
            originMapMarker.map = self
            
        case .destiny:
            destinyMapMarker.position = place.locations.coordinate.clLocation
            destinyMapMarker.title = place.name
            destinyMapMarker.map = self
        }
        
        moveCamera(GMSCameraUpdate.fit(place.locations.viewPortBounds.gmsViewPortBounds))
        animate(toLocation: place.locations.coordinate.clLocation)
    }
    
    func draw(routes: NSArray) {
        
        OperationQueue.main.addOperation({
            for route in routes {
                let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                let points = routeOverviewPolyline.object(forKey: "points")
                let path = GMSPath.init(fromEncodedPath: points! as! String)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor(color: .mainGreen)
                
                let bounds = GMSCoordinateBounds(path: path!)
                // needs fixing for iPhone X
                self.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 35, left: 20, bottom: 460, right: 20)))
                
                polyline.map = self
                
                self.isMyLocationEnabled = false
                
                self.originMapMarker.position = path!.coordinate(at: 0)
                self.destinyMapMarker.position = path!.coordinate(at: path!.count() - 1)
                
            }
        })
        
    }
}
