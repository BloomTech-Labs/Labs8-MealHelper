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
    func save()
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let genders = ["Female", "Male"]
    let inputFields = ["Username", "Email", "Password", "Birthday", "Height", "Weight"]
    var textFields = [UITextField]()
    
    var delegate: OnboardingCollectionViewCellDelegate?
    var isLastCell: Bool = false {
        didSet {
            setupHeader()
        }
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 30.0
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let genderButtonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        button.setTitle("Next", for: .normal)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - OnboardingCollectionViewCellDelegate
    
    @objc func previousCell() {
        delegate?.previousCell()
    }
    
    @objc func nextCell() {
        delegate?.nextCell()
    }
    
    @objc func save() {
        print("save")
        delegate?.save()
    }
    
    @objc func tappedGenderButton() {
        print("beeep")
    }
    
    // MARK: - Private
    
    private func setupViews() {
        setupHeader()
        
        mainStackView.addArrangedSubview(questionLabel)
        addSubview(mainStackView)
        let personalInfoView = PersonalInfoView()
        mainStackView.addArrangedSubview(personalInfoView)
        
        mainStackView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 150.0, right: 15.0))
        
    }
    
    private func setupHeader() {
        addSubview(headerView)
        headerView.addSubview(headerStackView)
        headerStackView.addArrangedSubview(backButton)
        headerStackView.addArrangedSubview(headerTitleLabel)
        headerStackView.addArrangedSubview(nextButton)
        
        headerView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0), size: CGSize(width: 0.0, height: 50.0))
        headerStackView.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor)
        
        let nextButtonAction = isLastCell ? #selector(save) : #selector(nextCell)
        let nextButtonTitle = isLastCell ? "Save" : "Next"
        nextButton.addTarget(self, action: nextButtonAction, for: .touchUpInside)
        nextButton.setTitle(nextButtonTitle, for: .normal)
        backButton.addTarget(self, action: #selector(previousCell), for: .touchUpInside)
    }
    
}


class PersonalInfoView: UIView {

    let genders = ["Female", "Male"]
    let inputFields = ["Username", "Email", "Password", "Birthday", "Height", "Weight"]

    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = UIStackView.Distribution.equalCentering
        view.alignment = .fill
        return view
    }()

    private let genderButtonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(genderButtonStackView)

        genders.forEach { (gender) in
            let button = createButton(for: gender)
            genderButtonStackView.addArrangedSubview(button)
        }

        inputFields.forEach { (input) in
            let textField = createTextField(for: input)
            mainStackView.addArrangedSubview(textField)
        }

        mainStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    @objc func tappedGenderButton() {
        print("beeep")
    }

    private func createButton(for gender: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(gender, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.backgroundColor = .red
        button.tintColor = .white
        //button.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.addTarget(self, action: #selector(tappedGenderButton), for: .touchUpInside)
        return button
    }

    private func createTextField(for input: String) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = input
        tf.font = UIFont.systemFont(ofSize: 17.0)
        tf.setLeftPaddingPoints(10.0)
        tf.setRightPaddingPoints(10.0)
        tf.backgroundColor = .white
        tf.tintColor = .blue
        tf.layer.cornerRadius = 8.0
        tf.layer.masksToBounds = true
        tf.contentHorizontalAlignment = .left
        tf.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        tf.isUserInteractionEnabled = true
        return tf
    }

}
