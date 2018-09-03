//
//  SlidingView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 03/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

private enum SlidingViewState {
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
    
    private var currentState: SlidingViewState = .destiny
    
    var runningAnimators: [UIViewPropertyAnimator] = []
    
    private var destinyStateConstraint: CGFloat = 0
    private var originStateConstraint: CGFloat = 0
    
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
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(panRecognizer)
        layout()
    }
    
    func layout() {
        
        let searchViewWidth = frame.width * destinyWidthConstraint.multiplier
        
        let sideMargins = (frame.width - searchViewWidth)/2.0

        destinyLeadingConstraint.constant = sideMargins
        originLeadingConstraint.constant = sideMargins/2.0
        
        destinyStateConstraint = sideMargins
        originStateConstraint = -searchViewWidth + (sideMargins/2.0)
    }
    
    func showView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.animateIfNeeded(to: self.currentState.opposite, duration: 0.4)
            self.runningAnimators.forEach { $0.startAnimation() }
        })
    }
    
    fileprivate func animateIfNeeded(to state: SlidingViewState, duration: TimeInterval) {
        
        guard runningAnimators.isEmpty else { return }
        
        let basicAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: nil)
        
        basicAnimator.addAnimations {
            switch state {
            case .origin:
                self.destinyLeadingConstraint.constant = self.originStateConstraint
                
            case .destiny:
                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
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
            let fraction = abs(translation.x / self.originStateConstraint)
            
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
        if currentState == SlidingViewState.destiny {
            animateIfNeeded(to: currentState.opposite, duration: 0.4)
            runningAnimators.forEach { $0.startAnimation() }
        }
    }

}
