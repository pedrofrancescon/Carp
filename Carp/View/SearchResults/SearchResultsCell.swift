//
//  SearchResultsCell.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class SearchResultsCell: UITableViewCell {
    
    @IBOutlet weak var iconLabel: UILabel!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconLabel.text = "\u{f276}"
        iconLabel.textColor = UIColor.greyIcon
        
    }
    
}
