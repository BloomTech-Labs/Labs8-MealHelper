//
//  SearchIngredientAnimator.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 05.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SearchIngredientAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.85
    var presenting = true // whether or not the VC is presenting or dismissing
    var originFrame = CGRect.zero
    var toFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?
    
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
        
        let screenWidth = UIScreen.main.bounds.width
        toVC.nutrientTableView.tableView.center.x = screenWidth * -0.5
        toVC.labelView.center.x = screenWidth * -0.5
        toVC.macroNutrientsView.center.x = screenWidth * -0.5
        toVC.addButton.anchor(top: toVC.nutrientTableView.tableView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 16, left: toVC.sidePadding, bottom: 0, right: toVC.sidePadding), size: CGSize(width: toVC.buttonSize, height: toVC.buttonSize))
        toVC.addButton.centerXAnchor.constraint(equalTo: toVC.view.centerXAnchor).isActive = true
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                animatedView.frame = containerView.convert(destinationView.bounds, from: destinationView)
                //animatedLabel.frame = containerView.convert(destinationLabel.bounds, from: destinationLabel)
                toView.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                toVC.labelView.center.x = toVC.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                toVC.macroNutrientsView.center.x = toVC.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                toVC.nutrientTableView.tableView.center.x = toVC.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4, animations: {
                toVC.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4, animations: {
                animatedView.alpha = 0.0
                animatedLabel.alpha = 0.0
                destinationView.alpha = 1.0
                destinationLabel.alpha = 1.0
            })
        }) { (success) in
            sourceView.alpha = 1.0
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
