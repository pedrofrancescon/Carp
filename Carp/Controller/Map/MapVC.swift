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

    @IBOutlet weak var mapView: MapView!
    private let locationsManager: LocationsManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.animate(toLocation: locationsManager.userCoordinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.mapView.resetMap()
        })
    }
    
    init() {
        locationsManager = LocationsManager.locationsManager
        super.init(nibName: "MapVC", bundle: nil)
    }
    
    func createMapMarker(of placeType: PlaceType, with place: Place) {
        mapView.createMapMarker(of: placeType, with: place)
    }
    
    func animateTo(_ state: SlidingViewState) {
        mapView.animateTo(state)
    }
    
    func drawRoute(from origin: Place, to destination: Place) {
        
        let origin = "\(origin.locations.coordinate.lat),\(origin.locations.coordinate.lng)"
        let destination = "\(destination.locations.coordinate.lat),\(destination.locations.coordinate.lng)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDwfMVcDzcQ_w8XKJ-edAUu7NwZ1HJuEco"
        
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
                    
                    self.mapView.draw(routes: routes)
                    
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
    func drawRoute(from origin: Place, to destination: Place)
    func animateTo(_ state: SlidingViewState)
}
