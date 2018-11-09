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
    
    @IBOutlet weak var newCarLabelView: UIView!
    
    @IBOutlet weak var newCarLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var resultsTableView = UITableView()
    
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
        
        //hideView()
    }
    
    override func layoutSubviews() {
        
        resultsTableView.tableFooterView = UIView()
        resultsTableView.separatorStyle = .singleLine
        resultsTableView.frame = containerView.bounds
        containerView.addSubview(resultsTableView)
        
        newCarLabel.textColor = UIColor(color: .green)
    }
    
    @IBAction func didTapNewCarLabel(_ sender: Any) {
        resultsDelegate?.callAlertVC()
    }
    
}
