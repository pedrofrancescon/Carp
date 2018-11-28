//
//  SmartScrollView.swift
//  Carp
//
//  Created by Eldade Marcelino on 27/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import Foundation
import UIKit

class HorizontalPagedScrollView: UIComponentProtocol {

    let view = View.fix(UIView())
    lazy var scrollView: UIScrollView = {
        let scroll = View.fix(UIScrollView())
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.bounces = false
        view.addSubview(scroll)
        return scroll
    }()
    private lazy var contentView: View = {
        let view = View.fix(View())
        scrollView.addSubview(view)
        return view
    }()
    private var firstChildConstraint: NSLayoutConstraint?
    private var lastChildConstraint: NSLayoutConstraint?
    private var glueConstraints = [NSLayoutConstraint]()
    private var views = [UIView]()

    init(_ views: [UIView]) {
        scrollView.constraintEdges(to: view)
        contentView.constraintEdges(to: scrollView)
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        contentView.addSubviews(views)
        self.views = views
        configureConstraints()
    }

    private func clearConstraints() {
        firstChildConstraint?.isActive = false
        lastChildConstraint?.isActive = false
        glueConstraints.forEach { $0.isActive = false }
        firstChildConstraint = nil
        lastChildConstraint = nil
        glueConstraints = []
    }

    private func configureConstraints() {
        if views.count > 0 {
            views.first?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            views.first?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            firstChildConstraint = views.first?.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            lastChildConstraint = views[views.count - 1].rightAnchor.constraint(equalTo: contentView.rightAnchor)
            firstChildConstraint?.isActive = true
            lastChildConstraint?.isActive = true
            glueConstraints = (
                views
                    .enumerated()
                    .filter({ $0.offset > 0 })
                    .map {
                        $0.element.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                        $0.element.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
                        return $0.element.leftAnchor.constraint(equalTo: views[$0.offset - 1].rightAnchor)
                }
            )
            glueConstraints.forEach { $0.isActive = true }
        }
    }

    func removeView(_ view: UIView) {
        clearConstraints()
        if let viewIndex = views.firstIndex(of: view) {
            views.remove(at: viewIndex)
            view.removeFromSuperview()
        }
        configureConstraints()
    }

    func addView(_ view: UIView) {
        clearConstraints()
        views.append(view)
        contentView.addSubview(view)
        configureConstraints()
    }
}
