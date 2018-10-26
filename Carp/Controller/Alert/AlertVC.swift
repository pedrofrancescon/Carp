//
//  AlertVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 24/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet weak var containerView: AlertView!
    
    let alertView: AlertView
    
    init() {
        alertView = AlertView()
        
        super.init(nibName: "AlertVC", bundle: nil)
    }
    
    init(priceEstimate: PriceEstimate) {
        alertView = AlertView(priceEstimate: priceEstimate)
        
        super.init(nibName: "AlertVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        containerView = alertView
        
    }
}
