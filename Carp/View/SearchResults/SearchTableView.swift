//
//  SearchTableView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 19/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class SearchTableView: UITableView {
    
    lazy var layout: () -> Void = {
        
        separatorStyle = .singleLine
        tableFooterView = UIView()
        isHidden = true
        
        return {}
        
    }()
    
    override func layoutSubviews() {
        layout()
        
        self.heightAnchor.constraint(equalToConstant: contentSize.height)
        self.frame.size.height = contentSize.height
        
    }
    
    func changeHeightTo(numberOfCells number: Int) {
        
        if number > 1 {
            separatorStyle = .singleLine
        } else {
            separatorStyle = .none
        }
        
        let tableHeight: CGFloat = 50 * CGFloat(number)
        
        UIView.animate(withDuration: 0.5) {
            self.heightAnchor.constraint(equalToConstant: tableHeight)
            self.frame.size.height = tableHeight
        }
        
    }

}
