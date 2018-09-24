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
    
    func getPlace(ofID id: String, _ completion: @escaping (Place) -> ()) {
        
        let placeEndpoint: String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&fields=name,geometry&key=AIzaSyA3yZXPM1qHkElDS6GoAb4co9W-fxYXk4M"
        print(placeEndpoint)
        guard let url = URL(string: placeEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data from Google API URL request")
                return
            }
            
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                guard let result = dictionary["result"] as? [String: Any] else { return }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: result, options: [])
                
                guard let place: Place = try? JSONDecoder().decode(Place.self, from: jsonData!) else {
                    print("Error: Couldn't decode data into Place")
                    return
                }
                
                completion(place)

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
        filter.type = .noFilter
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
