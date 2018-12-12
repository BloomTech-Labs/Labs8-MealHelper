//
//  NotesAnimator.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 12.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NotesAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.85
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // TODO: Needs to be refactored
        let fromNav = transitionContext.viewController(forKey: .from) as! WhiteStatusNavController
        let fromVC = fromNav.viewControllers[1] as! SearchIngredientCollectionViewController
        let toVC = transitionContext.viewController(forKey: .to) as! SearchIngredientDetailViewController
        let toView = transitionContext.view(forKey: .to)!
        
        let containerView = transitionContext.containerView
        
        let toViewEndFrame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toView)
        toView.frame = toViewEndFrame
        
        toView.alpha = 0.0
        
        let sourceView = fromVC.selectedCell!
        let destinationView = toVC.headerView.view!
        let destinationLabel = toVC.headerView.titleLabel
        
        sourceView.alpha = 0.0
        destinationView.alpha = 0.0
        destinationLabel.alpha = 0.0
        
        let viewInitialFrame = containerView.convert(sourceView.bounds, from: sourceView)
        
        let animatedView = UIView(frame: viewInitialFrame) //FoodCell<Ingredient>(frame: viewInitialFrame)
        animatedView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        animatedView.layer.cornerRadius = 12
        //        animatedView.food = sourceView.food
        
        let animatedLabel = UILabel(frame: sourceView.mealNameLabel.frame)
        animatedLabel.font = Appearance.appFont(with: 15)
        animatedLabel.numberOfLines = 2
        animatedLabel.textAlignment = .center
        animatedLabel.text = destinationLabel.text
        
        containerView.addSubview(animatedView)
        //animatedView.addSubview(animatedLabel)
        
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0.0, animations: {
            
        }) { (success) in
            sourceView.alpha = 1.0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
