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
    var destination: Place?
    var timeInterval: DateInterval?
    var numberOfSeats: NumberOfSeats?
    var restriction: Restrictions?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rideDetailsView.parentVC = self
        view = rideDetailsView
        
        numberOfSeats = .one
        restriction = .noRestriction
        
        guard let origin = origin, let destination = destination else { return }
        
        let originTap = UITapGestureRecognizer(target: self, action: #selector(didTapOriginTextField))
        let destinationTap = UITapGestureRecognizer(target: self, action: #selector(didTapdestinationTextField))
        
        rideDetailsView.originTextField.text = origin.name
        rideDetailsView.destinationTextField.text = destination.name
        
        rideDetailsView.originTextField.addGestureRecognizer(originTap)
        rideDetailsView.destinationTextField.addGestureRecognizer(destinationTap)
        
    }
    
    @objc func didTapOriginTextField() {
        RootVC.main.show(.searches, at: .origin, shouldSelect: true)
    }
    
    @objc func didTapdestinationTextField() {
        RootVC.main.show(.searches, at: .destination, shouldSelect: true)
    }

    init() {
        rideDetailsView = RideDetailsView(frame: .zero)
        super.init(nibName: "RideDetailsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRide() {
        
        if let origin = origin, let destination = destination, let timeInterval = timeInterval, let numberOfSeats = numberOfSeats, let restriction = restriction {
            
            let priceEstimate = PriceEstimate.init(lowerPrice: 12.0, upperPrice: 14.0)
            
            let newRide = Ride.init(origin: origin, destination: destination, timeInterval: timeInterval, numberOfSeats: numberOfSeats, restriction: restriction, userId: "", id: "", priceEstimate: priceEstimate)
            
            PersistantDataManager.dataManager.saveRideToDisk(ride: newRide)
            
            RootVC.main.callResultsVC(ride: newRide)
        }
        
    }

}

extension RideDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Restrictions.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Restrictions.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        restriction = Restrictions.allCases[row]
    }
    
}
