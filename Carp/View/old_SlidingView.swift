//
//  SlidingView.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 03/09/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit

//class SSlidingView: TouchesPassThroughView {
//
//    @IBOutlet weak var destinyLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var originLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var destinyWidthConstraint: NSLayoutConstraint!
//    
//    private var _currentState: SlidingViewState = .destiny
//    
//    var currentState: SlidingViewState {
//        get {
//            return self._currentState
//        }
//    }
//    
//    lazy var layout: () -> Void = {
//        
//        let searchViewWidth = frame.width * destinyWidthConstraint.multiplier
//
//        let sideMargins = (frame.width - searchViewWidth)/2.0
//
//        destinyLeadingConstraint.constant = sideMargins
//        originLeadingConstraint.constant = sideMargins/2.0
//
//        destinyStateConstraint = sideMargins
//        originStateConstraint = -searchViewWidth + (sideMargins/2.0)
//        
//        return {}
//        
//    }()
//    
//    private var runningAnimators: [UIViewPropertyAnimator] = []
//    
//    private var destinyStateConstraint: CGFloat = 0
//    private var originStateConstraint: CGFloat = 0
//    
//    private lazy var panRecognizer: UIPanGestureRecognizer = {
//        let recognizer = UIPanGestureRecognizer()
//        recognizer.addTarget(self, action: #selector(self.onDrag(_:)))
//        return recognizer
//    }()
//    
//    override func didMoveToSuperview() {
//        addGestureRecognizer(panRecognizer)
//    }
//    
//    func slideViewAnimated() {
//        animateIfNeeded(to: _currentState.opposite, duration: 0.4)
//        runningAnimators.forEach { $0.startAnimation() }
//    }
//    
//    fileprivate func animateIfNeeded(to state: SlidingViewState, duration: TimeInterval) {
//        
//        guard runningAnimators.isEmpty else { return }
//        
//        let basicAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: nil)
//        
//        basicAnimator.addAnimations {
//            switch state {
//            case .origin:
//                self.destinyLeadingConstraint.constant = self.originStateConstraint
//                
//            case .destiny:
//                self.destinyLeadingConstraint.constant = self.destinyStateConstraint
//            }
//            self.superview?.layoutIfNeeded()
//        }
//        
//        
//        basicAnimator.addCompletion { position in
//            self.runningAnimators.removeAll()
//            self._currentState = self._currentState.opposite
//        }
//        
//        
//        runningAnimators.append(basicAnimator)
//        
//    }
//    
//    @objc func onDrag(_ gesture: UIPanGestureRecognizer) {
//        
//        switch gesture.state {
//        case .began:
//            animateIfNeeded(to: _currentState.opposite, duration: 0.4)
//        case .changed:
//            let translation = gesture.translation(in: self)
//            let fraction = abs(translation.x / self.originStateConstraint)
//            
//            runningAnimators.forEach { animator in
//                animator.fractionComplete = fraction
//            }
//        case .ended:
//            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
//        default:
//            break
//        }
//    }
//
//}
