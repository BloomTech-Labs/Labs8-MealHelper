//
//  SwipeableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 23.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

@objc protocol SwipeableViewControllerDelegate: class {
    @objc optional func didPresentSwipeableView(_ swipeableView: SwipableViewController)
    @objc optional func willDismissSwipeableView(_ swipeableView: SwipableViewController)
}

class SwipableViewController: UIViewController {
    
    enum State {
        case closed
        case intermediate
        case open
    }
    
    weak var delegate: SwipeableViewControllerDelegate?
    var openHeight: CGFloat = 650.0
    var closedHeight: CGFloat = 200.0
    var popupOffset: CGFloat {
        return openHeight - closedHeight
    }
    var animationDuration = 0.6
    var currentState: State = .intermediate
    
    lazy var popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 30
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    private var animationProgress: CGFloat = 0.0
    private var viewIsAnimating = false
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    private var bottomConstraint = NSLayoutConstraint()
    private var transitionAnimator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        popupView.addGestureRecognizer(panRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bottomConstant = currentState == .open ? 0 : popupOffset
        animateInitialPopup(to: bottomConstant)
    }
    
    private func setupViews() {
        view.addSubview(overlayView)
        
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(popupView)
        
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: openHeight).isActive = true
        
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: openHeight)
        bottomConstraint.isActive = true
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: popupView)
        let isSwipingUp = translation.y < 0 ? true : false
        var fraction = -translation.y / popupOffset
        
        switch recognizer.state {
            //        case .began:
            //            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            //            animationProgress = transitionAnimator?.fractionComplete ?? 0.0
        //            viewIsAnimating = true
        case .changed:
            if currentState == .intermediate && !viewIsAnimating {
                if isSwipingUp {
                    animateTransition(to: .open, duration: animationDuration)
                    transitionAnimator?.pauseAnimation()
                    animationProgress = transitionAnimator?.fractionComplete ?? 0.0
                    viewIsAnimating = true
                } else {
                    animateTransition(to: .closed, duration: animationDuration)
                    transitionAnimator?.pauseAnimation()
                    animationProgress = transitionAnimator?.fractionComplete ?? 0.0
                    viewIsAnimating = true
                }
            } else if currentState == .open && !viewIsAnimating {
                animateTransition(to: .intermediate, duration: animationDuration)
                transitionAnimator?.pauseAnimation()
                animationProgress = transitionAnimator?.fractionComplete ?? 0.0
                viewIsAnimating = true
            }
            
            if currentState == .open || transitionAnimator?.isReversed ?? false { fraction *= -1 }
            
            if currentState == .intermediate && !isSwipingUp  { fraction *= -1 }
            
            transitionAnimator?.fractionComplete = fraction + animationProgress // Add previous animation progress to panned fraction
        case .ended:
            let yVelocity = recognizer.velocity(in: popupView).y
            let shouldMoveDown = yVelocity > 0
            if yVelocity == 0 {
                transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            
            switch currentState { // Reverse the animations based on their current state and pan motion
            case .open:
                if !shouldMoveDown && !(transitionAnimator?.isReversed ?? false) { transitionAnimator?.isReversed = !(transitionAnimator?.isReversed ?? false) }
                if shouldMoveDown && transitionAnimator?.isReversed ?? false { transitionAnimator?.isReversed = !(transitionAnimator?.isReversed ?? false) }
            case .intermediate:
                if !shouldMoveDown && transitionAnimator?.isReversed ?? false { transitionAnimator?.isReversed = !(transitionAnimator?.isReversed ?? false) }
            case .closed:
                break
            }
            
            transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
    private func animateTransition(to targetState: State, duration: TimeInterval) {
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0, animations: {
            switch targetState {
            case .open:
                self.bottomConstraint.constant = 0
                self.overlayView.alpha = 0.3
            case .intermediate:
                self.bottomConstraint.constant = self.popupOffset
                self.overlayView.alpha = 0
            case .closed:
                self.bottomConstraint.constant = self.openHeight
                self.overlayView.alpha = 0
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator?.addCompletion { position in
            switch position {
            case .start:
                self.currentState = targetState.opposite // state == .closed ? .intermediate : state.opposite
            case .end:
                if targetState == .closed { // When target state is closed, then remove the view
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
                
                self.currentState = targetState // Update state when animation ended
            case .current:
                ()
            }
            
            self.viewIsAnimating = false
        }
        
        transitionAnimator?.startAnimation()
    }
    
    private func animateInitialPopup(to constant: CGFloat) {
        UIView.animate(withDuration: animationDuration) {
            self.bottomConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}

extension SwipableViewController.State {
    var opposite: SwipableViewController.State {
        switch self {
        case .open: return .intermediate
        case .closed: return .intermediate
        case .intermediate: return .open
        }
    }
}
