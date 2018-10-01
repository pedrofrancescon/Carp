//
//  ResultsCell.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak private var originIcon: UILabel!
    @IBOutlet weak private var destinyIcon: UILabel!
    @IBOutlet weak private var timeIcon: UILabel!
    
    @IBOutlet weak var originDistanceLabel: UILabel!
    @IBOutlet weak var destinyDistanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var usersStackView: UIStackView!
    
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
        
    }
    
    func addToStackView(image: UIImage) {
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: imageView,
                                                   attribute: NSLayoutConstraint.Attribute.width,
                                                   multiplier: imageView.frame.size.height / imageView.frame.size.width,
                                                   constant: 0))
        
        usersStackView.addArrangedSubview(imageView)
    }
    
}
