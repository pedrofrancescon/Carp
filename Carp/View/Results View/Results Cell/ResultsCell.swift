//
//  ResultsCell.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    static var cellHeight: CGFloat = 74.0
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak private var originIcon: UILabel!
    @IBOutlet weak private var destinyIcon: UILabel!
    @IBOutlet weak private var timeIcon: UILabel!
    
    @IBOutlet weak var originDistanceLabel: UILabel!
    @IBOutlet weak var destinyDistanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var usersStackView: UsersStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        originIcon.font = UIFont(name: "FontAwesome5FreeSolid", size: 10)
        
        originIcon.text = "\u{f111}"
        destinyIcon.text = "\u{f3c5}"
        timeIcon.text = "\u{f017}"
        
        originIcon.textColor = UIColor(rgb: 0x489773)
        destinyIcon.textColor = UIColor(rgb: 0x489773)
        timeIcon.textColor = UIColor(rgb: 0x4A90E2)
        
        priceLabel.textColor = UIColor(rgb: 0x3F3F3F)
        
        originDistanceLabel.textColor = UIColor(rgb: 0x6D6D6D)
        destinyDistanceLabel.textColor = UIColor(rgb: 0x6D6D6D)
        timeLabel.textColor = UIColor(rgb: 0x6D6D6D)
        
        selectionStyle = .none
        
    }
    
}
