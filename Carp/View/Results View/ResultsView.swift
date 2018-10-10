//
//  ResultsView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class ResultsView: PopUpView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    var tableView: UITableView = UITableView()
    
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
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    override func layoutSubviews() {
        let greenIconAttributes = [
            NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor(color: .greenText) as Any
        ]
        
        let greenTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor(color: .greenText) as Any
        ]
        
        let greyIconAttributes = [
            NSAttributedString.Key.font: UIFont(name: "FontAwesome5FreeSolid", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor(color: .greyText) as Any
        ]
        
        let greyTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16.0) as Any,
            NSAttributedString.Key.foregroundColor: UIColor(color: .greyText) as Any
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
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.frame = contentView.frame
        containerView.addSubview(tableView)
        
    }
    
}
