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

class TouchHighlightLabel: UILabel {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.8
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.alpha = 1
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
    func addSubview(_ view: UIComponentProtocol) {
        addSubview(view.view)
    }
    func addSubviews(_ views: [UIView]) {
        views.forEach({ addSubview($0) })
    }
    func addSubviews(_ views: [UIComponentProtocol]) {
        views.forEach({ addSubview($0.view) })
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach({ addArrangedSubview($0) })
    }
    func addArrangedSubviews(_ views: [UIComponentProtocol]) {
        views.forEach({ addArrangedSubview($0.view) })
    }
    func addArrangedSubview(_ view: UIComponentProtocol) {
        addArrangedSubview(view.view)
    }
}

extension UILabel {
    func defaultFont() -> UILabel {
        self.font = UIFont(name: "Lato-Regular", size: self.font.pointSize)
        return self
    }
}
