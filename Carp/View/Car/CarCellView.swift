//
//  CarView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 01/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class CarCellView: UIView {

    @IBOutlet var contentView: UIView!
    
    let carTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CarCellView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.addSubview(carTableView)
        
        carTableView.isScrollEnabled = false
        carTableView.separatorStyle = .none
        carTableView.tableFooterView = UIView()
    }
    
    override func layoutSubviews() {
        carTableView.frame = contentView.bounds
    }
}
