//
//  LoadingButton.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 15/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    private var originalTitle = ""
    
    let loadingIndicator: UIActivityIndicatorView =
    {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
        
        return aiv
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
        loadingIndicator.startAnimating()
    }
    
    func stopLoading()
    {
        loadingIndicator.stopAnimating()
        self.setTitle(originalTitle, for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    private func setupLoadingIndicator()
    {
        addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
