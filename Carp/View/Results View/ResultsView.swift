//
//  ResultsView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

enum ResultsViewState {
    case onlyResults,resultsAndCar
}

enum ResultsViewButtons {
    case results,car
}

import UIKit

class ResultsView: PopUpView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var newCarLabelView: UIView!
    
    @IBOutlet weak var newCarLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    var resultsTableView = UITableView()
    var carView: UIView = UIView()
    
    weak var resultsDelegate: ResultsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ResultsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.frame = self.bounds
        
        changeStateTo(.onlyResults)
    }
    
    override func layoutSubviews() {
        
        let greenIconAttributes = [
            NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 16.0) as Any
        ]
        
        let greenTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16.0) as Any
        ]
        
        let greyIconAttributes = [
            NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 16.0) as Any
        ]
        
        let greyTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16.0) as Any
        ]
        
        let resultsStringIcon = NSMutableAttributedString(string: "\u{f0ca}", attributes: greenIconAttributes)
        let resultsStringText = NSMutableAttributedString(string: "  Resultados", attributes: greenTextAttributes)
        
        let resultsCombination = NSMutableAttributedString()
        
        resultsCombination.append(resultsStringIcon)
        resultsCombination.append(resultsStringText)
        
        resultsButton.setAttributedTitle(resultsCombination, for: .normal)
        
        let carStringIcon = NSMutableAttributedString(string: "\u{f1ba}", attributes: greyIconAttributes)
        let carStringText = NSMutableAttributedString(string: "  Carro", attributes: greyTextAttributes)
        
        let carCombination = NSMutableAttributedString()
        
        carCombination.append(carStringIcon)
        carCombination.append(carStringText)
        
        chatButton.setAttributedTitle(carCombination, for: .normal)
        
        resultsTableView.tableFooterView = UIView()
        resultsTableView.separatorStyle = .singleLine
        resultsTableView.frame = containerView.bounds
        
        newCarLabel.textColor = UIColor(color: .green)
    }
    
    func changeStateTo(_ state: ResultsViewState) {
        
        switch state {
        case .onlyResults:
            buttonsView.isHidden = true
            newCarLabelView.isHidden = false
            didTap(.results)
            
        case .resultsAndCar:
            buttonsView.isHidden = false
            newCarLabelView.isHidden = true
            didTap(.car)
        }
    }
    
    func didTap(_ button: ResultsViewButtons) {
        
        for sView in containerView.subviews {
            sView.removeFromSuperview()
        }
        
        switch button {
        case .results:
            containerView.addSubview(resultsTableView)
            resultsButton.setTitleColor(UIColor(color: .greenText), for: .normal)
            resultsButton.tintColor = UIColor(color: .greenText)
            chatButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            chatButton.tintColor = UIColor(color: .greyText)
        case .car:
            containerView.addSubview(carView)
            resultsButton.setTitleColor(UIColor(color: .greyText), for: .normal)
            resultsButton.tintColor = UIColor(color: .greyText)
            chatButton.setTitleColor(UIColor(color: .greenText), for: .normal)
            chatButton.tintColor = UIColor(color: .greenText)
        }
        
    }
    
    @IBAction func didTapNewCarLabel(_ sender: Any) {
        resultsDelegate?.callAlertVC()
    }
    
    @IBAction func didTapCarButton(_ sender: Any) {
        didTap(.car)
    }
    
    @IBAction func didTapResultsButton(_ sender: Any) {
        didTap(.results)
    }
    
    
}
