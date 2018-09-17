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
        
        originIcon.text = "\u{f111}"
        destinyIcon.text = "\u{f3c5}"
        timeIcon.text = "\u{f017}"
        seatsIcon.text = "\u{f0c0}"
        restrictionsIcon.text = "\u{f502}"
        
        originIcon.textColor = UIColor(color: .mainGreen)
        destinyIcon.textColor = UIColor(color: .mainGreen)
        timeIcon.textColor = UIColor(color: .mainBlue)
        seatsIcon.textColor = UIColor(color: .mainOrange)
        restrictionsIcon.textColor = UIColor(color: .darkGreyIcon)
        
        makeButtonSelected(oneSeatButton)
        
    }
    
    private func makeButtonSelected(_ button: UIButton) {
        
        switch button {
        case oneSeatButton:
            oneSeatButton.backgroundColor = UIColor(color: .mainOrange)
            oneSeatButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            twoSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            twoSeatsButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
            threeSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            threeSeatsButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
        case twoSeatsButton:
            twoSeatsButton.backgroundColor = UIColor(color: .mainOrange)
            twoSeatsButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            oneSeatButton.backgroundColor = UIColor(color: .softGreyBoxes)
            oneSeatButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
            threeSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            threeSeatsButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
        case threeSeatsButton:
            threeSeatsButton.backgroundColor = UIColor(color: .mainOrange)
            threeSeatsButton.setTitleColor(UIColor(color: .softGreyBoxes), for: .normal)
            
            oneSeatButton.backgroundColor = UIColor(color: .softGreyBoxes)
            oneSeatButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
            twoSeatsButton.backgroundColor = UIColor(color: .softGreyBoxes)
            twoSeatsButton.setTitleColor(UIColor(color: .darkGreyText), for: .normal)
            
        default:
            return
        }
        
    }
    
    @IBAction func didTouchSeatsButton(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return }
        makeButtonSelected(button)
        
    }
    
    
}
