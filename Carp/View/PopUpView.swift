//
//  PopUpView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 31/08/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

private enum PopUpViewState {
    case closed
    case open
}

extension PopUpViewState {
    var opposite: PopUpViewState {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class PopUpView: UIView {
    
    private var bottomConstraint = NSLayoutConstraint()
    private var currentState: PopUpViewState = .closed
    
    var runningAnimators: [UIViewPropertyAnimator] = []
    
    private var viewOffset: CGFloat = 480
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.onTap(_:)))
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.onDrag(_:)))
        return recognizer
    }()
    
    override func didMoveToSuperview() {
        layout()
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(panRecognizer)
    }
    
    func showView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.animateIfNeeded(to: self.currentState.opposite, duration: 0.4)
            self.runningAnimators.forEach { $0.startAnimation() }
        })
    }
    
    private func layout() {
        guard let superView = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomConstraint = bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: viewOffset)
        bottomConstraint.isActive = true
        
        heightAnchor.constraint(lessThanOrEqualToConstant: 480).isActive = true
    }
    
    fileprivate func animateIfNeeded(to state: PopUpViewState, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }
        
        let basicAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: nil)
        
        basicAnimator.addAnimations {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.viewOffset - 150
            }
            self.superview?.layoutIfNeeded()
        }
        
        
        basicAnimator.addCompletion { position in
            self.runningAnimators.removeAll()
            self.currentState = self.currentState.opposite
        }
        
        
        runningAnimators.append(basicAnimator)
        
    }
    
    @objc func onDrag(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            animateIfNeeded(to: currentState.opposite, duration: 0.4)
        case .changed:
            let translation = gesture.translation(in: self)
            let fraction = abs(translation.y / viewOffset)
            
            runningAnimators.forEach { animator in
                animator.fractionComplete = fraction
            }
        case .ended:
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            break
        }
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        if currentState == PopUpViewState.closed {
            animateIfNeeded(to: currentState.opposite, duration: 0.4)
            runningAnimators.forEach { $0.startAnimation() }
        }
    }
}
