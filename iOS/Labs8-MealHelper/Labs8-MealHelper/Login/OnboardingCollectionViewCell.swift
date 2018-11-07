//
//  OnboardingCollectionViewCell.swift
//  ios-meal-helper
//
//  Created by De MicheliStefano on 07.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol OnboardingCollectionViewCellDelegate {
    func previousCell()
    func nextCell()
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: OnboardingCollectionViewCellDelegate?
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.tintColor = .blue
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(nextCell), for: .touchUpInside)
        return button
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "In order to make smart suggestions we would like to know a little bit more about you."
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backButton.addTarget(self, action: #selector(previousCell), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextCell), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backButton.removeTarget(nil, action: nil, for: .allEvents)
        nextButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    // MARK: - OnboardingCollectionViewCellDelegate
    
    @objc func previousCell() {
        delegate?.previousCell()
    }
    
    @objc func nextCell() {
        delegate?.nextCell()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        // Setup header
        contentView.addSubview(headerView)
        headerView.addSubview(headerStackView)
        headerStackView.addArrangedSubview(backButton)
        headerStackView.addArrangedSubview(headerTitleLabel)
        headerStackView.addArrangedSubview(nextButton)
        
        headerView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0), size: CGSize(width: 0.0, height: 50.0))
        headerStackView.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor)
        
        // Setup body
        contentView.addSubview(questionLabel)
        
        questionLabel.anchor(top: headerView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0))
        
    }
    
}


class PersonalInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
