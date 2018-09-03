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
        resultsButton.setTitle("Resultados", for: .normal)
        resultsButton.setTitleColor(UIColor(rgb: 0x489773), for: .normal)
        
        chatButton.setTitle("Chat", for: .normal)
        chatButton.setTitleColor(UIColor(rgb: 0x3F3F3F), for: .normal)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        tableView.frame = contentView.frame
        containerView.addSubview(tableView)
    }
    
}
