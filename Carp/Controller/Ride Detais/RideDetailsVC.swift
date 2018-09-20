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

        rideDetailsView.parentVC = self
        view = rideDetailsView
        
        numberOfSeats = .one
        restriction = .noRestriction
        
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