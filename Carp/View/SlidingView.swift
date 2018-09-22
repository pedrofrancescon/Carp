//
//  SlidingView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 03/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

enum SlidingViewState {
    case destiny
    case origin
    case hidden
}

extension SlidingViewState {
    var opposite: SlidingViewState {
        switch self {
        case .origin: return .destiny
        case .destiny: return .origin
        case .hidden: return .hidden
        }
    }
}

class SlidingView: TouchesPassThroughView {
    
    @IBOutlet weak var destinyLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var originLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var destinyWidthConstraint: NSLayoutConstraint!
    
    private var destinyStateConstraint: CGFloat = 0
    private var originStateConstraint: CGFloat = 0
    private var hiddenStateConstraint: CGFloat = 0
    
    // MARK: - View Controller Lifecycle
    
    override func didMoveToSuperview() {
        addGestureRecognizer(panRecognizer)
    }
    
    func slideViewAnimated(to state: SlidingViewState, withDuration duration: Double) {
        animateTransitionIfNeeded(to: state, duration: duration)
        runningAnimators.forEach { $0.startAnimation() }
    }
    
    lazy var layout: () -> Void = {
        
        let searchViewWidth = frame.width * destinyWidthConstraint.multiplier
        
        let sideMargins = (frame.width - searchViewWidth)/2.0
        
        destinyLeadingConstraint.constant = sideMargins
        originLeadingConstraint.constant = sideMargins/2.0
        
        destinyStateConstraint = sideMargins
        originStateConstraint = -searchViewWidth + (sideMargins/2.0)
        hiddenStateConstraint = (-searchViewWidth)*2 - (sideMargins/2.0)
        
        return {}
        
    }()
    
    // MARK: - Animation
    
    var currentState: SlidingViewState = .destiny
        private var runningAnimators = [UIViewPropertyAnimator]()
    
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()

    
    private func animateTransitionIfNeeded(to state: SlidingViewState, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }
                let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .origin:
                self.destinyLeadingConstraint.constant = self.originStateConstraint
                
            case .destiny:
                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
                
            case .hidden:
                self.destinyLeadingConstraint.constant = self.hiddenStateConstraint
            }
            self.superview?.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            switch self.currentState {
            case .origin:
                self.destinyLeadingConstraint.constant = self.originStateConstraint
                
            case .destiny:
                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
                
            case .hidden:
                self.destinyLeadingConstraint.constant = self.hiddenStateConstraint
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
            var fraction = -translation.x / self.originStateConstraint
            
            if currentState == .destiny { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            let xVelocity = recognizer.velocity(in: self).x
            let shouldClose = xVelocity > 0
            
            if xVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            switch currentState {
            case .origin:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .destiny:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .hidden:
                break
            }
            
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
}
