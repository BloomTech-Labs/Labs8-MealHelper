//
//  MealDetailViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 30/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    var meal: Meal? {
        didSet {
            navigationItem.title = meal?.mealTime
        }
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mountain"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setGradientBackground(colorOne: UIColor.nightSkyDark.cgColor, colorTwo: UIColor.nightSkyBlue.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
//        backgroundImageView.fillSuperview()
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        view.addSubview(blurEffect)
//        blurEffect.fillSuperview()
        blurEffect.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        
    }
    
    
}
