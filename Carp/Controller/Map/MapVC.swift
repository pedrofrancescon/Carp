//
//  MappVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    private let locationsManager: LocationsManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.isMyLocationEnabled = true
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
        
        super.init(nibName: "MapVC", bundle: nil)
    }
    
    func createMapMarker(of place: Place) {
        
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.title = place.name
        //marker.snippet = "Australia"
        marker.map = mapView
        
        mapView.moveCamera(GMSCameraUpdate.fit(place.viewPortBounds))
        mapView.animate(toLocation: place.coordinate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
