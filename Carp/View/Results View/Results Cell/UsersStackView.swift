//
//  UsersStackView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 04/10/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

class UsersStackView: UIStackView {

    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func add(_ image: UIImage) {
        
        //let imageView = UIImageView(image: image)
        let imageView = UIImageView()
        
        imageView.backgroundColor = .red
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = frame.height/2
        imageView.clipsToBounds = true
        
        addArrangedSubview(imageView)
        
    }
    
}
