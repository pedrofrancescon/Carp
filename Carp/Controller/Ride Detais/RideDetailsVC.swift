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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = rideDetailsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    init() {
        rideDetailsView = RideDetailsView(frame: .zero)
        super.init(nibName: "RideDetailsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
