//
//  RideDetailsVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 13/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class RideDetailsVC: UIViewController {

    let rideDetailsView: RideDetailsView
    
    var origin: Place?
    var destiny: Place?
    var timeInterval: DateInterval?
    var numberOfSeats: NumberOfSeats?
    var restriction: Restrictions?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = rideDetailsView
        
        numberOfSeats = .one
        restriction = .none
        
        guard let origin = origin, let destiny = destiny else { return }
        rideDetailsView.originTextField.text = origin.name
        rideDetailsView.destinyTextField.text = destiny.name
        
    }

    init() {
        rideDetailsView = RideDetailsView(frame: .zero)
        super.init(nibName: "RideDetailsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
