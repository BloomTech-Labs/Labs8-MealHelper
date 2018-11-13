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
    func save(user: User)
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: OnboardingCollectionViewCellDelegate?
    var isLastCell: Bool = false {
        didSet {
            setupHeader()
        }
    }
    
    let personalInfoView = PersonalInfoView()
    
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 30.0
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var genderButtonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(previousCell), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Next", for: .normal)
        let nextButtonAction = isLastCell ? #selector(save) : #selector(nextCell)
        button.addTarget(self, action: nextButtonAction, for: .touchUpInside)
        return button
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Sign Up"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = .white
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "In order to make smart suggestions we would like to know a little bit more about you."
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var backgroundImageView : UIImageView = {
        let image = UIImage(named: "backgroundImage")!
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private lazy var lightBlurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView()
        frost.autoresizingMask = .flexibleWidth
        frost.effect = UIBlurEffect(style: .light)
        return frost
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
        guard let email = personalInfoView.email, let password = personalInfoView.password, let zip = personalInfoView.zip, let healthCondition = personalInfoView.healthCondition else { return }
        
        let user = User(email: email, password: password, zip: zip, healthCondition: healthCondition)
        
        delegate?.save(user: user)
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        setupHeader()
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(lightBlurEffect)
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(questionLabel)
        mainStackView.addArrangedSubview(personalInfoView)
        
        backgroundImageView.fillSuperview()
        lightBlurEffect.fillSuperview()
        mainStackView.anchor(top: headerStackView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 100.0, right: 15.0))
        
    }
    
    private func setupHeader() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(backButton)
        headerStackView.addArrangedSubview(headerTitleLabel)
        headerStackView.addArrangedSubview(nextButton)
        
        headerStackView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0), size: CGSize(width: 0.0, height: 50.0))
        
        let nextButtonTitle = isLastCell ? "Save" : "Next"
        nextButton.setTitle(nextButtonTitle, for: .normal)
    }
    
}


class PersonalInfoView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Properties
    
    var gender: String?
    var username: String?
    var zip: Int?
    var email: String?
    var password: String?
    var birthday: Date?
    var height: String?
    var weight: String?
    var healthCondition: String?
    
    private let genders = ["Female", "Male"]
    private var genderButtons = [UIButton]()
    private let selectedButtonColor = UIColor.red
    private let unselectedButtonColor = UIColor.lightGray
    private let inputTextFields = ["Username", "Email", "Password", "Zip", "Health Condition", "Birthday", "Height", "Weight"]
    private let inputPickerTextFields = ["Birthday", "Height", "Weight"]
    private var editingTextfield: UITextField?
    private lazy var weights: [Double] = (40...170).map { Double($0) }
    private var heights: [Double] = (100...270).map { Double($0) }
    
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
    
    // MARK: - User actions
    
    @objc private func tappedGenderButton(_ button: UIButton) {
        genderButtons.forEach { $0.backgroundColor = unselectedButtonColor; $0.isSelected = false }
        button.backgroundColor = selectedButtonColor
        gender = button.accessibilityIdentifier
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(genderButtonStackView)

        genders.forEach { (gender) in
            let button = createButton(for: gender)
            genderButtons.append(button)
            genderButtonStackView.addArrangedSubview(button)
        }

        inputTextFields.forEach { (input) in
            let textField = createTextField(for: input)
            textField.delegate = self
            mainStackView.addArrangedSubview(textField)
            
            if inputPickerTextFields.contains(input) { // Only create a picker when it's supposed to
                createPicker(for: textField)
            }
        }

        mainStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }

    private func createButton(for gender: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = gender // Add an id so we can access it later
        button.setTitle(gender, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.backgroundColor = unselectedButtonColor
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.addTarget(self, action: #selector(tappedGenderButton), for: .touchUpInside)
        return button
    }

    private func createTextField(for input: String) -> UITextField {
        let inputField = InputField(placeholder: input)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.accessibilityIdentifier = input
        inputField.contentHorizontalAlignment = .left
        inputField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        return inputField
    }
    
    
    // MARK: - UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "Birthday":
            return 1
        case "Height":
            return 1
        case "Weight":
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "Height":
            return heights.count
        case "Weight":
            return weights.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "Height":
            return Utils().getPersonHeightString(heights[row])
        case "Weight":
            return Utils().getPersonWeightString(weights[row])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "Height":
            let heightString = Utils().getPersonHeightString(heights[row])
            editingTextfield?.text = heightString
            self.height = heightString
        case "Weight":
            let weightString = Utils().getPersonWeightString(weights[row])
            editingTextfield?.text = weightString
            self.weight = weightString
        default:
            editingTextfield?.text = nil
        }
    }
    
    private func createPicker(for input: UITextField) {
        // Create a picker for each text field
        if input.accessibilityIdentifier == "Birthday" {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(setDateTextField), for: .allEvents)
            input.inputView = datePicker
        } else {
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            picker.accessibilityIdentifier = input.accessibilityIdentifier // Add an id so we can determine what picker type to show in delegate methods
            input.inputView = picker
        }
            
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
    
    @objc private func setDateTextField(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        editingTextfield?.text = formatter.string(from: sender.date)
        self.birthday = sender.date
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldId = textField.accessibilityIdentifier, inputPickerTextFields.contains(textFieldId) { // Disable text editing if it's a picker text field
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextfield = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.accessibilityIdentifier {
        case "Username":
            self.username = textField.text
        case "Email":
            self.email = textField.text
        case "Password":
            self.password = textField.text
        case "Zip":
            if let zip = textField.text {
                self.zip = Int(zip)
            }
        case "Health Condition":
            self.healthCondition = textField.text
        case "Height":
            self.height = textField.text
        case "Weight":
            self.weight = textField.text
        default:
            break
        }
    }
    
}
