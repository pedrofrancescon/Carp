//
//  UIViewExtensions.swift
//  Carp
//
//  Created by Eldade Marcelino on 06/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func setupView() { }

    static func fix<T: UIView>(_ view: T) -> T {
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

class TextField: UITextField {

    var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

extension UIView {
    func constraintEdges(to view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func constraintEdges(to view: UIView, withMargin: CGFloat) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: withMargin).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: withMargin).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -withMargin).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -withMargin).isActive = true
    }
    func addSubviews(_ views: [UIView]) {
        views.forEach({ addSubview($0) })
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach({ addArrangedSubview($0) })
    }
}
