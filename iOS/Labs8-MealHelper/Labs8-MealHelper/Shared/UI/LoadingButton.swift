//
//  LoadingButton.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 15/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import Lottie

class LoadingButton: UIButton {
    
    private var originalTitle = ""
    
    let loadingView: LOTAnimationView = {
        let lv = LOTAnimationView()
        lv.setAnimation(named: "loading")
        lv.loopAnimation = true
        lv.isHidden = true
        
        return lv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupLoadingIndicator()
    }
    
    func startLoading()
    {
        self.isUserInteractionEnabled = false
        originalTitle = self.titleLabel?.text ?? "Login"
        self.setTitle("", for: .normal)
        loadingView.isHidden = false
        loadingView.play()
    }
    
    func stopLoading()
    {
        loadingView.stop()
        loadingView.isHidden = true
        self.setTitle(originalTitle, for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    private func setupLoadingIndicator()
    {
        addSubview(loadingView)
        loadingView.centerInSuperview(size: CGSize(width: 140, height: 80))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
