//
//  LocationsManager.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationsManager: CLLocationManager, CLLocationManagerDelegate, GMSAutocompleteFetcherDelegate {
    
    static var locationsManager = LocationsManager()
    
    private var _coordinate: CLLocationCoordinate2D!
    private let locationManager = CLLocationManager()
    
    private var placesFetcher: GMSAutocompleteFetcher?
    
    private var predictionsUpdate: (([GMSAutocompletePrediction]) -> ())?
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    var userCoordinate: CLLocationCoordinate2D {
        get {
            return _coordinate
        }
    }
    
    var userLatitude: CLLocationDegrees {
        get {
            return _coordinate.latitude
        }
    }
    
    var userLongitude: CLLocationDegrees {
        get {
            return _coordinate.longitude
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    func getPlacePredictions(with text: String, _ completion: @escaping ([GMSAutocompletePrediction]) -> ()) {
        predictionsUpdate = completion
        placesFetcher?.sourceTextHasChanged(text)
    }
    
    func getPlace(of id: String, _ completion: @escaping (Place) -> ()) {
        
        // Set up the URL request
        let placeEndpoint: String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&fields=name,geometry&key=AIzaSyA3yZXPM1qHkElDS6GoAb4co9W-fxYXk4M"
        guard let url = URL(string: placeEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let place = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                print(place["status"] as! String)
                
                let placeFromJson = Place(json: place)
                completion(placeFromJson)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
        
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        guard let completion = predictionsUpdate else { return }
        completion(predictions)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    override init() {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "BR"
        
        placesFetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        
        super.init()
        
        placesFetcher?.delegate = self
        
        _coordinate = CLLocationCoordinate2D(latitude: -25.441105, longitude: -49.276855)
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        _coordinate = location.coordinate
    }
    
}
