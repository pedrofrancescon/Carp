//
//  EntityMapper.swift
//  Carp
//
//  Created by Eldade Marcelino on 20/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import Firebase

private struct TimeRange: Codable {
    var min: Double
    var max: Double
}

private struct Geopoint: Codable {
    var latitude: Double
    var longitude: Double
}

private struct DbPlace: Codable {
    var legibleName: String
    var geopoint: Geopoint
}

private struct RideRequest: Codable {
    var departureTimeRange: TimeRange
    var destination: DbPlace
    var origin: DbPlace
    var numberOfSeats: Int
    var genderRestriction: GenderRestriction
    var uid: String
}

private enum GenderRestriction: String, Codable {
    case noRestriction
    case sameSex
}

private struct DbUser: Codable {
    var creationTime: Double
    var firstName: String
    var lastName: String
    var profilePictureUrl: String
    var uid: String
    var gender: String?
}

private struct DbCar: Codable {
    var rideRequests: [String]?
    var hostRequest: String
    var price: Float
}

func rideToDbFormat(ride: Ride) -> [String: Any] {
    return [
        "departureTimeRange": [
            "min": ride.timeInterval.start.timeIntervalSince1970,
            "max": ride.timeInterval.end.timeIntervalSince1970
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

func rideFromDbFormat(docId: String, _ dictionary: [String: Any]) throws -> Ride {
    let ride: RideRequest = try dicDeserialize(dictionary)
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
            start: Date(timeIntervalSince1970: ride.departureTimeRange.min),
            end: Date(timeIntervalSince1970: ride.departureTimeRange.max)
        ),
        numberOfSeats: NumberOfSeats(rawValue: ride.numberOfSeats) ?? NumberOfSeats.one,
        restriction: convertGenderRestriction(ride.genderRestriction),
        userId: ride.uid,
        id: docId,
        priceEstimate: PriceEstimate.init(lowerPrice: 12.0, upperPrice: 14.0)
    )
}

func userToDbFormat(user: CarpUser) -> [String: Any] {
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

func userFromDbFormat(_ dictionary: [String: Any]) throws -> CarpUser {
    let user: DbUser = try dicDeserialize(dictionary)
    return CarpUser(
        id: user.uid,
        firstName: user.firstName,
        lastName: user.lastName,
        profilePictureUrl: user.profilePictureUrl,
        gender: user.gender
    )
}

func carToDbFormat(_ car: Car) -> [String: Any] {
    return [
        "hostRequest": car.owner.id,
        "rideRequests": car.riders.map({ $0.id }),
        "price": car.price
    ]
}

func carFromDbFormat(docId: String, riders: [Ride], owner: Ride, _ dictionary: [String: Any]) throws -> Car {
    let car: DbCar = try dicDeserialize(dictionary)
    return Car(
        riders: riders,
        owner: owner,
        price: car.price
    )
}

private func convertGenderRestriction(_ dbRestriction: GenderRestriction) -> Restrictions {
    switch dbRestriction {
    case GenderRestriction.sameSex:
        return Restrictions.sameSex
    default:
        return Restrictions.noRestriction
    }
}

private func dicDeserialize<T: Decodable>(_ dictionary: [String: Any]) throws -> T {
    return try JSONDecoder().decode(T.self, from: try JSONSerialization.data(withJSONObject: dictionary, options: []))
}
