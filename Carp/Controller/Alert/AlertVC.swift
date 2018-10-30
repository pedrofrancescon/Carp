//
//  AlertVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 24/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    let priceEstimate: PriceEstimate?
    
    weak var delegate: AlertDelegate?
    
    init() {
        self.priceEstimate = nil
        
        super.init(nibName: "AlertVC", bundle: nil)
    }
    
    init(priceEstimate: PriceEstimate) {
        self.priceEstimate = priceEstimate
        
        super.init(nibName: "AlertVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var alertView: AlertView
        let frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        
        if let priceEstimate = priceEstimate {
            alertView = AlertView(frame: frame, priceEstimate: priceEstimate)
            
        } else {
            alertView = AlertView(frame: frame)
        }
        
        alertView.parentVC = self
        
        containerView.insertSubview(alertView, at: 0)
        
    }
    
    func doneButtonPressed() {
        
        guard let alertView = containerView.subviews[0] as? AlertView else { return }
        
        dismiss(animated: true) {
            switch alertView.kind {
            case .disclaimer:
                self.delegate?.callPriceAlertVC()
            case .priceInput:
                guard let text = alertView.priceInputField.text else { return }
                //self.delegate?.createNewCar(price: Float(text)!)
            }
        }
    }
    
}
