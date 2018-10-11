//
//  PersistantDataManager.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation

class PersistantDataManager {
    
    static var dataManager = PersistantDataManager()
    
    private func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
    
    func saveRideToDisk(ride: Ride) {
        // 1. Create a URL for documents-directory/posts.json
        let url = getDocumentsURL().appendingPathComponent("ride.json")
        // 2. Endcode our [Post] data to JSON Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(ride)
            // 3. Write this data to the url specified in step 1
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getRideFromDisk() -> Ride {
        // 1. Create a url for documents-directory/posts.json
        let url = getDocumentsURL().appendingPathComponent("ride.json")
        let decoder = JSONDecoder()
        do {
            // 2. Retrieve the data on the file in this path (if there is any)
            let data = try Data(contentsOf: url, options: [])
            // 3. Decode an array of Posts from this Data
            let ride = try decoder.decode(Ride.self, from: data)
            return ride
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
