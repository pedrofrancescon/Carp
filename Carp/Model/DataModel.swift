//
//  DataModel.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class DataModel {
    
    static var shared = DataModel()
    
    private var user: CarpUser
    
    init() {
        
        user = CarpUser(id: "", firstName: "", lastName: "", profilePictureUrl: "", gender: "")
        
    }
    
}
