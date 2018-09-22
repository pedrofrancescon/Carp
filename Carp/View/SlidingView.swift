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
}

extension SlidingViewState {
    var opposite: SlidingViewState {
        switch self {
        case .origin: return .destiny
        case .destiny: return .origin
        }
    }
}

class SlidingView: TouchesPassThroughView {
    
    @IBOutlet weak var destinyLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var originLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var destinyWidthConstraint: NSLayoutConstraint!
    
    private var destinyStateConstraint: CGFloat = 0
    private var originStateConstraint: CGFloat = 0
    
    // MARK: - View Controller Lifecycle
    
    override func didMoveToSuperview() {
        addGestureRecognizer(panRecognizer)
    }
    
    func slideViewAnimated() {
        animateTransitionIfNeeded(to: currentState.opposite, duration: 1.0)
        runningAnimators.forEach { $0.startAnimation() }
    }
    
    lazy var layout: () -> Void = {
        
        let searchViewWidth = frame.width * destinyWidthConstraint.multiplier
        
        let sideMargins = (frame.width - searchViewWidth)/2.0
        
        destinyLeadingConstraint.constant = sideMargins
        originLeadingConstraint.constant = sideMargins/2.0
        
        destinyStateConstraint = sideMargins
        originStateConstraint = -searchViewWidth + (sideMargins/2.0)
        
        return {}
        
    }()
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    var currentState: SlidingViewState = .destiny
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: SlidingViewState, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .origin:
                self.destinyLeadingConstraint.constant = self.originStateConstraint
                
            case .destiny:
                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
            }
            self.superview?.layoutIfNeeded()
        })
        
        // the transition completion block
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
            
            // manually reset the constraint positions
            switch self.currentState {
            case .origin:
                self.destinyLeadingConstraint.constant = self.originStateConstraint
                
            case .destiny:
                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // start all animators
        transitionAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: self)
            var fraction = -translation.x / self.originStateConstraint
            
            // adjust the fraction for the current state and reversed state
            if currentState == .destiny { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let xVelocity = recognizer.velocity(in: self).x
            let shouldClose = xVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if xVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .origin:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .destiny:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
}
