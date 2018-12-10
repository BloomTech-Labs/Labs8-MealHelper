//
//  PopupView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 10.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

@objc protocol PopupViewDelegate: class {
    @objc func popupView()
    @objc optional func didPressButton()
}

class PopupView: UIView {
    
    weak var delegate: PopupViewDelegate?
    var isCollapsed = true
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var hasActionButton = true
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 70, green: 170, blue: 255)
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Appearance.appFont(with: 16)
        label.sizeToFit()
        
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mountainBlue
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupViews()
    }
    
    @objc func tappedButton() {
        if isCollapsed {
            delegate?.popupView()
        } else {
            delegate?.didPressButton?()
        }
    }
    
    private func setupViews() {
        
        setupHeaderView()
        
        addSubview(containerView)
        containerView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor)
    }
    
    private func setupHeaderView() {
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 0, height: 60))
        
        headerView.addSubview(titleLabel)
        
        titleLabel.anchor(top: nil, leading: headerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        if hasActionButton == true {
            headerView.addSubview(actionButton)
            actionButton.anchor(top: nil, leading: nil, bottom: nil, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
            actionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
