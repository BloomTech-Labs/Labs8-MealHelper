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


class PersonalInfoView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var gender: String?
    var username: String?
    var email: String?
    var password: String?
    var birthday: Date?
    var height: String?
    var weight: String?
    
    private let genders = ["Female", "Male"]
    private let inputTextFields = ["Username", "Email", "Password", "Birthday", "Height", "Weight"]
    
    private let mainStackView: UIStackView = {
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

        inputTextFields.forEach { (input) in
            let textField = createTextField(for: input)
            mainStackView.addArrangedSubview(textField)
            
            createPicker(for: textField)
        }

        mainStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    @objc func tappedGenderButton(_ sender: UIButton) {
        print("beeep")
        print(sender.accessibilityIdentifier)
    }

    private func createButton(for gender: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = gender
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
        tf.accessibilityIdentifier = input
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // https://developer.apple.com/documentation/foundation/lengthformatter
        return "hi"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // textField.text = pickerDataSource[row]

    }
    
    
    private func createPicker(for input: UITextField) {
        // Create a picker for each text field
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        input.inputView = picker
        picker.backgroundColor = .white
        
        // Create a tool bar above the picker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Add a Done button that will dismiss the keyboard. Can also add more button items into array.
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Accessory view to the inputView which is set as the picker
        input.inputAccessoryView = toolBar
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
}
