//
//  RideDetaisView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class RideDetailsView: PopUpView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var originIcon: UILabel!
    @IBOutlet weak var destinyIcon: UILabel!
    @IBOutlet weak var timeIcon: UILabel!
    @IBOutlet weak var seatsIcon: UILabel!
    @IBOutlet weak var restrictionsIcon: UILabel!
    
    @IBOutlet weak var originTextField: TextField!
    @IBOutlet weak var destinyTextField: TextField!
    @IBOutlet weak var timeTextField: TextField!
    @IBOutlet weak var timeDeadlineTextField: TextField!
    @IBOutlet weak var restrictionsTextField: TextField!
    
    @IBOutlet weak var oneSeatButton: UIButton!
    @IBOutlet weak var twoSeatsButton: UIButton!
    @IBOutlet weak var threeSeatsButton: UIButton!
    
    @IBOutlet weak var servicesIconsStackView: UIStackView!
    
    @IBOutlet weak var fareEstimateLabel: UILabel!
    
    private let datePicker = UIDatePicker()
    private let deadlineDatePicker = UIDatePicker()
    
    var parentVC: RideDetailsVC? {
        didSet {
            setupDatePicker()
            setupDeadlineDatePicker()
            setupRestrictionsPicker()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    private func comminInit() {
        Bundle.main.loadNibNamed("RideDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        originIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 10)
        originIcon.text = "\u{f111}"
        
        destinyIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 15)
        destinyIcon.text = "\u{f3c5}"
        
        timeIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 14)
        timeIcon.text = "\u{f017}"
        
        timeIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 16)
        seatsIcon.text = "\u{f0c0}"
        
        timeIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 15)
        restrictionsIcon.text = "\u{f502}"
        
        fareEstimateLabel.textColor = UIColor(color: .darkGreyText)
        
        originIcon.textColor = UIColor(color: .mainGreen)
        destinyIcon.textColor = UIColor(color: .mainGreen)
        timeIcon.textColor = UIColor(color: .mainBlue)
        seatsIcon.textColor = UIColor(color: .mainOrange)
        restrictionsIcon.textColor = UIColor(color: .greyIcon)
        
        makeButtonSelected(oneSeatButton)
        
        timeDeadlineTextField.isEnabled = false
        
        addToStackView(image: UIImage(named: "Uber")!)
        addToStackView(image: UIImage(named: "Cabify")!)
        addToStackView(image: UIImage(named: "99.jpeg")!)
        
    }
    
    func addToStackView(image: UIImage) {
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                        attribute: NSLayoutConstraint.Attribute.height,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: imageView,
                                                        attribute: NSLayoutConstraint.Attribute.width,
                                                        multiplier: imageView.frame.size.height / imageView.frame.size.width,
                                                        constant: 0))
        
        servicesIconsStackView.addArrangedSubview(imageView)
    }
    
    private func makeButtonSelected(_ button: UIButton) {
        
        switch button {
        case oneSeatButton:
            oneSeatButton.backgroundColor = UIColor(color: .mainOrange)
            oneSeatButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            twoSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            twoSeatsButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            threeSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            threeSeatsButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            parentVC?.numberOfSeats = .one
            
        case twoSeatsButton:
            twoSeatsButton.backgroundColor = UIColor(color: .mainOrange)
            twoSeatsButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            oneSeatButton.backgroundColor = UIColor(color: .softGreyBoxes)
            oneSeatButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            threeSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            threeSeatsButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            parentVC?.numberOfSeats = .two
            
        case threeSeatsButton:
            threeSeatsButton.backgroundColor = UIColor(color: .mainOrange)
            threeSeatsButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            oneSeatButton.backgroundColor = UIColor(color: .softGreyBoxes)
            oneSeatButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            twoSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            twoSeatsButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            
            parentVC?.numberOfSeats = .twree
            
        default:
            return
        }
        
    }
    
    @IBAction func didTouchSeatsButton(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        makeButtonSelected(button)
        
    }
    
    func setupRestrictionsPicker() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = parentVC
        pickerView.dataSource = parentVC
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(doneRestrictionsPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        restrictionsTextField.inputAccessoryView = toolbar
        restrictionsTextField.inputView = pickerView
        
    }
    
    @objc func doneRestrictionsPicker() {
        
        restrictionsTextField.text = parentVC?.restriction?.rawValue
        endEditing(true)
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        timeTextField.inputAccessoryView = toolbar
        timeTextField.inputView = datePicker
        
    }
    
    @objc func doneDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "E, d MMM - HH:mm"
        timeTextField.text = formatter.string(from: datePicker.date)
        
        deadlineDatePicker.minimumDate = datePicker.date
        deadlineDatePicker.date = Date(timeInterval: 900, since: datePicker.date)
        
        formatter.dateFormat =  "HH:mm"
        timeDeadlineTextField.text = formatter.string(from: deadlineDatePicker.date)
        
        parentVC?.timeInterval = DateInterval(start: datePicker.date, end: deadlineDatePicker.date)
        
        timeDeadlineTextField.isEnabled = true
        
        endEditing(true)
    }
    
    func setupDeadlineDatePicker(){
        deadlineDatePicker.datePickerMode = .time
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(doneDeadlineDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        timeDeadlineTextField.inputAccessoryView = toolbar
        timeDeadlineTextField.inputView = deadlineDatePicker
        
    }
    
    @objc func doneDeadlineDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "HH:mm"
        timeDeadlineTextField.text = formatter.string(from: deadlineDatePicker.date)
        
        parentVC?.timeInterval = DateInterval(start: datePicker.date, end: deadlineDatePicker.date)
        
        endEditing(true)
    }
    
    @objc func cancelPicker(){
        endEditing(true)
    }
    
}

protocol RideDetailsViewDelegate: class {
    
    func didChange(timeInterval: DateInterval)
    func didChange(numberOfSeats: NumberOfSeats)
}
