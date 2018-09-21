//
//  MappVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController, MapControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    private let locationsManager: LocationsManager
    
    private var originMapMarker: GMSMarker
    private var destinyMapMarker: GMSMarker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //originMapMarker.isDraggable = true
        //destinyMapMarker.isDraggable = true

        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.animate(toLocation: locationsManager.userCoordinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.mapView.animate(toLocation: self.locationsManager.userCoordinate)
            self.mapView.animate(toZoom: 15.0)
        })
    }
    

    init() {
        locationsManager = LocationsManager.locationsManager
        originMapMarker = GMSMarker()
        destinyMapMarker = GMSMarker()
        
        super.init(nibName: "MapVC", bundle: nil)
    }
    
    func createMapMarker(of placeType: PlaceType, with place: Place) {
        
        switch placeType {
        case .origin:
            originMapMarker.map = nil
            
            originMapMarker.position = place.locations.coordinate.clLocation
            originMapMarker.title = place.name
            originMapMarker.map = mapView
            
        case .destiny:
            destinyMapMarker.map = nil
            
            destinyMapMarker.position = place.locations.coordinate.clLocation
            destinyMapMarker.title = place.name
            destinyMapMarker.map = mapView
        }
        
        mapView.moveCamera(GMSCameraUpdate.fit(place.locations.viewPortBounds.gmsViewPortBounds))
        mapView.animate(toLocation: place.locations.coordinate.clLocation)
    }
    
    func drawRoute(from origin: Place, to destiny: Place) {
        
        let origin = "\(origin.locations.coordinate.lat),\(origin.locations.coordinate.lng)"
        let destination = "\(destiny.locations.coordinate.lat),\(destiny.locations.coordinate.lat)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=drivingoogleg&key=AIzaSyDwfMVcDzcQ_w8XKJ-edAUu7NwZ1HJuEco"
        
        print(urlString)
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    self.mapView.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.mapView
                            
                        }
                    })
                    
                } catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol MapControllerDelegate: class {
    func createMapMarker(of placeType: PlaceType, with place: Place)
    func drawRoute(from origin: Place, to destiny: Place)
}
