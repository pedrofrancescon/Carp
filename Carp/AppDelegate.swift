//
//  AppDelegate.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance()?.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GMSServices.provideAPIKey("AIzaSyDwfMVcDzcQ_w8XKJ-edAUu7NwZ1HJuEco")
        GMSPlacesClient.provideAPIKey("AIzaSyDwfMVcDzcQ_w8XKJ-edAUu7NwZ1HJuEco")

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = RootNavigationController()
        //let initialViewController = RegistrationViewController()

        window!.rootViewController = initialViewController
        window!.makeKeyAndVisible()

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let fbHandled = FBSDKApplicationDelegate.sharedInstance()?.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String ?? "",
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) ?? false
        let gHandled = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: [:]
        )
        return fbHandled || gHandled
    }

    func testApiMethods() {
        let dm = UserDataManager()
        let testUid = "PRSHQMvzf2nnZ8ObhDHZ"
        dm.getPublicUserDataWith(uid: testUid) { (user) in
            if let user = user {
                print("Successfully retrieved public user data:\n", user)
            } else {
                print("Could not retrieve user data")
            }
        }
        dm.getPrivateUserDataWith(uid: testUid) { (data) in
            if let data = data {
                print("Successfully retrieved private user data:\n", data)
            } else {
                print("Could not retrieve private user data")
            }
        }
        let placeWithNameAndLatLng = { (name: String, lat: Double, lng: Double) in
            return Place(
                name: name,
                locations: Locations(
                    coordinate: Coordinate(lat: lat, lng: lng),
                    viewPortBounds: ViewPortBounds.init(
                        northeast: Coordinate.zero,
                        southwest: Coordinate.zero)
                    )
                )
        }
        UserSessionManager.shared.getFbToken { token in
            if let token = token {
                print("Successfully got Facebook token: \(token)")
            } else {
                print("Failure while retrieving Facebook token")
            }
        }
        UserSessionManager.shared.getFbProfileData { data in
            if let data = data {
                print("Facebook data: \(data)")
            } else {
                print("Could no retrieve Facebook data.")
            }
        }
        UserSessionManager.shared.getGToken { tokens in
            if let tokens = tokens {
                print("Successfully retrieved Google token: \(tokens)")
            } else {
                print("Could not get Google token.")
            }
        }
        UserSessionManager.shared.getGProfileData { data in
            if let data = data {
                print("Google data: \(data)")
            } else {
                print("Could not retrieve Google data.")
            }
        }
        RideRequestsManager.rideRequestsManager.createRide(
            Ride(
                origin: placeWithNameAndLatLng("Casa do Eldade", 10, 10),
                destination: placeWithNameAndLatLng("Casa da Grazi", 5, 5),
                timeInterval: DateInterval(start: Date(timeIntervalSince1970: 1541363761), duration: 60*30),
                numberOfSeats: NumberOfSeats.one,
                restriction: Restrictions.noRestriction,
                userId: testUid,
                id: "",
                priceEstimate: PriceEstimate(lowerPrice: 10, upperPrice: 15)
            )
        ) { (error, createdDocId) in
            if error {
                print("Could not create ride request")
            } else {
                print("Successfully created ride request with id \(createdDocId)")
            }
        }
    }
}
