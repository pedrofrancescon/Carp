//
//  CarView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class CarView: PopUpView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cellStackView: UIView!
    @IBOutlet weak var chatStackView: UIView!
    
    let carTableView = UITableView()
    
    @IBOutlet weak var cellStackViewConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        cellStackView.addSubview(carTableView)
        
        carTableView.isScrollEnabled = false
        carTableView.separatorStyle = .none
    }
    
    override func layoutSubviews() {
        
        cellStackViewConstraint.constant = ResultsCell.cellHeight
        cellStackView.layoutIfNeeded()
        
        carTableView.frame = cellStackView.bounds
    }
}
