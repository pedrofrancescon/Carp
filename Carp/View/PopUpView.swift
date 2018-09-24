//
//  PopUpView.swift
//  InteractiveAnimations
//
//  Created by Pedro Francescon Cittolin on 15/09/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: - State

private enum State {
    case closed
    case open
    case half
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .half
        case .closed: return .open
        case .half: return .open
        }
    }
}


class PopUpView: UIView {

    // MARK: - Constants
    
    private let popupOffset: CGFloat = 480
    
    // MARK: - View Controller Lifecycle
    
    override func didMoveToSuperview() {
        layout()
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(tapRecognizer)
    }
    
    func showView() {
        DispatchQueue.main.async {
            self.animateTransitionIfNeeded(to: .open, duration: 1.0)
            self.runningAnimators.forEach { $0.startAnimation() }
        }
    }
    
    func hideView() {
        DispatchQueue.main.async {
            self.animateTransitionIfNeeded(to: .closed, duration: 1.0)
            self.runningAnimators.forEach { $0.startAnimation() }
        }
    }
    
    // MARK: - Layout
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        guard let superView = self.superview else { return }
        
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadow(blur: 10)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomConstraint = bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        heightAnchor.constraint(lessThanOrEqualToConstant: popupOffset).isActive = true
        
    }
    
    // MARK: - Animation
    
    private var currentState: State = .closed
    
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    private var animationProgress = [CGFloat]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()

    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }
        
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            case.half:
                self.bottomConstraint.constant = self.popupOffset - 150
            }
            self.superview?.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            

            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            case.half:
                self.bottomConstraint.constant = self.popupOffset - 150
            }
            
            self.runningAnimators.removeAll()
            
        }
        
        transitionAnimator.startAnimation()
        
        runningAnimators.append(transitionAnimator)
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            runningAnimators.forEach { $0.pauseAnimation() }
            
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            let translation = recognizer.translation(in: self)
            var fraction = -translation.y / popupOffset
            
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            let yVelocity = recognizer.velocity(in: self).y
            let shouldClose = yVelocity > 0
            
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .half:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        if currentState == .closed {
            DispatchQueue.main.async {
                self.animateTransitionIfNeeded(to: self.currentState.opposite, duration: 1.0)
                self.runningAnimators.forEach { $0.startAnimation() }
            }
        }
    }

}
