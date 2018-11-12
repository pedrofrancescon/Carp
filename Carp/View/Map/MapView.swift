//
//  MapView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView, GMSMapViewDelegate {

    private var originMapMarker: GMSMarker = GMSMarker()
    private var destinationMapMarker: GMSMarker = GMSMarker()
    private var polyline: GMSPolyline = GMSPolyline()
    
    weak var dismissKeyboard: DismissKeyboardProtocol?
    
    override func layoutSubviews() {
        originMapMarker.icon = UIImage(named: "origin_map_marker")
        originMapMarker.appearAnimation = .pop
        originMapMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        destinationMapMarker.icon = UIImage(named: "destination_map_marker")
        destinationMapMarker.appearAnimation = .pop
        destinationMapMarker.groundAnchor = CGPoint(x: 0.5, y: 0.91)
        
        settings.allowScrollGesturesDuringRotateOrZoom = false
        settings.myLocationButton = true
        isMyLocationEnabled = true
        
        isExclusiveTouch = false
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        
        delegate = self
        
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        dismissKeyboard?.viewEndEditing()
    }
    
    func createMapMarker(of placeType: PlaceType, with place: Place) {
        
        isMyLocationEnabled = false
        
        switch placeType {
        case .origin:
            originMapMarker.position = place.locations.coordinate.clLocation
            originMapMarker.title = place.name
            originMapMarker.map = self
            
        case .destination:
            destinationMapMarker.position = place.locations.coordinate.clLocation
            destinationMapMarker.title = place.name
            destinationMapMarker.map = self
        }
        
        moveCamera(GMSCameraUpdate.fit(place.locations.viewPortBounds.gmsViewPortBounds))
        animate(toLocation: place.locations.coordinate.clLocation)
    }
    
    private func clearPath() {
        polyline.map = nil
    }
    
    func resetMap() {
        isMyLocationEnabled = true
        clear()
        animate(toLocation: LocationsManager.locationsManager.userCoordinate)
        animate(toZoom: 15.0)
    }
    
    func animateTo(_ state: SlidingViewState) {
        
        switch state {
        case .destination:
            self.animate(toLocation: destinationMapMarker.position)
            self.animate(toZoom: 16.0)
            clearPath()
        case .origin:
            self.animate(toLocation: originMapMarker.position)
            self.animate(toZoom: 16.0)
            clearPath()
        case .hidden:
            break
        }
        
    }
    
    func draw(routes: NSArray) {
        
        OperationQueue.main.addOperation({
            for route in routes {
                let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                let points = routeOverviewPolyline.object(forKey: "points")
                let path = GMSPath.init(fromEncodedPath: points! as! String)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline.strokeWidth = 3
                self.polyline.strokeColor = UIColor.mainGreen
                
                let bounds = GMSCoordinateBounds(path: path!)
                // needs fixing for iPhone X
                self.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 35, left: 20, bottom: 460, right: 20)))
                
                self.polyline.map = self
                
                self.isMyLocationEnabled = false
                
                self.originMapMarker.position = path!.coordinate(at: 0)
                self.destinationMapMarker.position = path!.coordinate(at: path!.count() - 1)
                
            }
        })
        
    }
}
