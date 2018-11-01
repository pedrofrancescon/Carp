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
    var alertView: AlertView?
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlertVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if let priceEstimate = priceEstimate {
            alertView = AlertView(priceEstimate: priceEstimate)
            
        } else {
            alertView = AlertView()
        }
        
        guard let alertView = alertView else { return }
        
        alertView.parentVC = self
        
        containerView.insertSubview(alertView, at: 0)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 70.0
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 70.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        let frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        alertView?.frame = frame
        
    }
    
    func doneButtonPressed() {
        
        guard let alertView = alertView else { return }
        
        dismiss(animated: true) {
            switch alertView.kind {
            case .disclaimer:
                self.delegate?.callPriceAlertVC()
            case .priceInput:
                //guard let text = alertView.priceInputField.text else { return }
                self.delegate?.createNewCar(price: alertView.priceInputField.value)
            }
        }
    }
    
}
