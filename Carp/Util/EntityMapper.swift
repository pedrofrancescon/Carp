//
//  EntityMapper.swift
//  Carp
//
//  Created by Eldade Marcelino on 20/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

fileprivate struct Timestamp: Codable {
    var seconds: Double
    var nanoseconds: Double
}

fileprivate struct TimeRange: Codable {
    var min: Timestamp
    var max: Timestamp
}

fileprivate struct Geopoint: Codable {
    var latitude: Double
    var longitude: Double
}

fileprivate struct DbPlace: Codable {
    var legibleName: String
    var geopoint: Geopoint
}

fileprivate struct RideRequest: Codable {
    var departureTimeRange: TimeRange
    var destination: DbPlace
    var origin: DbPlace
    var numberOfSeats: Int
    var genderRestriction: GenderRestriction
    var uid: String
}

fileprivate enum GenderRestriction: String, Codable {
    case noRestriction
    case sameSex
}

fileprivate struct DbUser: Codable {
    var creationTime: Timestamp
    var firstName: String
    var lastName: String
    var profilePictureUrl: String
    var uid: String
    var gender: String?
}

fileprivate struct DbCar: Codable {
    var rideRequests: [String]
    var hostRequest: String
    var price: Float
}

func RideToDbFormat(ride: Ride) -> [String : Any] {
    return [
        "departureTimeRange": [
            "min": [
                "seconds": ride.timeInterval.start.timeIntervalSince1970,
                "nanoseconds": 0
            ],
            "max": [
                "seconds": ride.timeInterval.end.timeIntervalSince1970,
                "nanoseconds": 0
            ]
        ],
        "destination": [
            "legibleName": ride.destiny.name,
            "geopoint": [
                "latitude": ride.destiny.locations.coordinate.lat,
                "longitude": ride.destiny.locations.coordinate.lng
            ]
        ],
        "origin": [
            "legibleName": ride.origin.name,
            "geopoint": [
                "latitude": ride.origin.locations.coordinate.lat,
                "longitude": ride.origin.locations.coordinate.lng
            ]
        ],
        "uid": ride.userId
    ]
}

func RideFromDbFormat(docId: String, _ dictionary: [String: Any]) throws -> Ride {
    let ride: RideRequest = try DicDeserialize(dictionary)
    return Ride(
        origin: Place(
            name: ride.origin.legibleName,
            locations: Locations(
                coordinate: Coordinate(
                    lat: ride.origin.geopoint.latitude,
                    lng: ride.origin.geopoint.longitude
                ),
                viewPortBounds: ViewPortBounds(
                    northeast: Coordinate(lat: 0, lng: 0),
                    southwest: Coordinate(lat: 0, lng: 0)
                )
            )
        ),
        destiny: Place(
            name: ride.destination.legibleName,
            locations: Locations(
                coordinate: Coordinate(
                    lat: ride.destination.geopoint.latitude,
                    lng: ride.destination.geopoint.longitude
                ),
                viewPortBounds: ViewPortBounds(
                    northeast: Coordinate(lat: 0, lng: 0),
                    southwest: Coordinate(lat: 0, lng: 0)
                )
            )
        ),
        timeInterval: DateInterval(
            start: Date(timeIntervalSince1970: ride.departureTimeRange.min.seconds),
            end: Date(timeIntervalSince1970: ride.departureTimeRange.max.seconds)
        ),
        numberOfSeats: NumberOfSeats(rawValue: ride.numberOfSeats) ?? NumberOfSeats.one,
        restriction: ConvertGenderRestriction(ride.genderRestriction),
        userId: ride.uid,
        id: docId
    )
}

func UserToDbFormat(user: CarpUser) -> [String: Any] {
    var outputObj = [
        "firstName": user.firstName,
        "lastName": user.lastName,
        "profilePictureUrl": user.profilePictureUrl,
        "uid": user.id
    ]
    
    if let gender = user.gender {
        outputObj["gender"] = gender
    }
    
    return outputObj
}

func UserFromDbFormat(_ dictionary: [String: Any]) throws -> CarpUser {
    let user: DbUser = try DicDeserialize(dictionary)
    return CarpUser(
        id: user.uid,
        firstName: user.firstName,
        lastName: user.lastName,
        profilePictureUrl: user.profilePictureUrl,
        gender: user.gender
    )
}

func CarToDbFormat(_ car: Car) -> [String: Any] {
    return [
        "hostRequest": car.owner.id,
        "rideRequests": car.riders.map({ $0.id }),
        "price": car.price
    ]
}

func CarFromDbFormat(docId: String, riders: [Ride], owner: Ride, _ dictionary: [String: Any]) throws -> Car {
    let car: DbCar = try DicDeserialize(dictionary)
    return Car(
        riders: riders,
        owner: owner,
        price: car.price
    )
}

fileprivate func ConvertGenderRestriction(_ dbRestriction: GenderRestriction) -> Restrictions {
    switch dbRestriction {
    case GenderRestriction.sameSex:
        return Restrictions.sameSex
    default:
        return Restrictions.noRestriction
    }
}

fileprivate func DicDeserialize<T: Decodable>(_ dictionary: [String: Any]) throws -> T {
    return try JSONDecoder().decode(T.self, from: try JSONSerialization.data(withJSONObject: dictionary, options: []))
}