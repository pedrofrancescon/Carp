//
//  SearchTableView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 19/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class SearchTableView: UITableView {
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        
        UIView.animate(withDuration: 0.5) {
            self.heightAnchor.constraint(equalToConstant: self.contentSize.height)
            //self.frame.size.height = self.contentSize.height
        }
    }
    
    lazy var layout: () -> Void = {
        
        separatorStyle = .singleLine
        tableFooterView = UIView()
        isHidden = true
        
        return {}
        
    }()
    
    override func layoutSubviews() {
        layout()
    }

}
