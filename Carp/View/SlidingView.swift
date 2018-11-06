//
//  SlidingView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 03/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

enum SlidingViewState {
    case destination
    case origin
    case hidden
}

extension SlidingViewState {
    var opposite: SlidingViewState {
        switch self {
        case .origin: return .destination
        case .destination: return .origin
        case .hidden: return .hidden
        }
    }
}

class SlidingView: TouchesPassThroughView {
    
    @IBOutlet weak var destinationLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var originLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var destinationWidthConstraint: NSLayoutConstraint!
    
    private var destinationStateConstraint: CGFloat = 0
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
        
        let searchViewWidth = frame.width * destinationWidthConstraint.multiplier
        
        let sideMargins = (frame.width - searchViewWidth)/2.0
        
        destinationLeadingConstraint.constant = sideMargins
        originLeadingConstraint.constant = sideMargins/2.0
        
        destinationStateConstraint = sideMargins
        originStateConstraint = -searchViewWidth + (sideMargins/2.0)
        hiddenStateConstraint = (-searchViewWidth)*2 - (sideMargins/2.0)
        
        return {}
        
    }()
    
    // MARK: - Animation
    
    var currentState: SlidingViewState = .destination {
        didSet {
            NotificationCenter.default.post(name: .slidginViewStateChanged, object: nil)
        }
    }
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
                self.destinationLeadingConstraint.constant = self.originStateConstraint
                
            case .destination:
                self.destinationLeadingConstraint.constant = self.destinationStateConstraint
                
            case .hidden:
                self.destinationLeadingConstraint.constant = self.hiddenStateConstraint
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
                self.destinationLeadingConstraint.constant = self.originStateConstraint
                
            case .destination:
                self.destinationLeadingConstraint.constant = self.destinationStateConstraint
                
            case .hidden:
                self.destinationLeadingConstraint.constant = self.hiddenStateConstraint
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
            
            if currentState == .destination { fraction *= -1 }
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
            case .destination:
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
