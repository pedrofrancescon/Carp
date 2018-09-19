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
    
    private let datePicker: UIDatePicker
    
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
        
        setupDatePicker()
        
        guard let origin = origin, let destiny = destiny else { return }
        rideDetailsView.originTextField.text = origin.name
        rideDetailsView.destinyTextField.text = destiny.name
        
    }

    init() {
        rideDetailsView = RideDetailsView(frame: .zero)
        datePicker = UIDatePicker()
        super.init(nibName: "RideDetailsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        rideDetailsView.timeTextField.inputAccessoryView = toolbar
        rideDetailsView.timeTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "E, d MMM - HH:mm"
        rideDetailsView.timeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

}
