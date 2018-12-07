//
//  FoodSummaryView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol FoodSummaryViewDelegate {
    var servingQty: String? { get set }
    var servingType: String? { get set }
    func setServingQty(with qty: String, for recipe: Any)
    func setServingType(with type: String, for recipe: Any)
}

class FoodSummaryViewController: UIViewController {
    
    // MARK: - Public properties
    
    var titleName: String? {
        didSet {
            updateViews()
        }
    }
    
    var subtitleName: String? {
        didSet {
            updateViews()
        }
    }
    
    var servingQty: String = "Change quantity"
    var servingType: String = "Change serving"
    var typePickerFieldValues: [String] = {
        var values = (1...20).map { String($0) }
        values.insert("", at: 0)
        return values
    }()
    var quantityPickerFieldValues: [String] = {
        var values: [String] = FoodHelper.ServingTypes.allCases.map { $0.rawValue }
        values.insert("", at: 0)
        return values
    }()
    
    var typePickerFieldDefaultValue = "Change qty" {
        didSet {
            typeInputField.text = typePickerFieldDefaultValue
        }
    }
    var quantityPickerFieldDefaultValue = "Change serving" {
        didSet {
            quantityInputField.text = quantityPickerFieldDefaultValue
        }
    }
    var typePickerFieldImage = #imageLiteral(resourceName: "meal")
    var quantityPickerFieldImage = #imageLiteral(resourceName: "add")
    var editableTitle = false
    
    // MARK: - Private properties
    
    private lazy var typeInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: typePickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingSize"
        inputField.imageTintColor = .mountainBlue
        inputField.leftImage = typePickerFieldImage
        inputField.font = Appearance.appFont(with: 13)
        return inputField
    }()
    
    private lazy var quantityInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: quantityPickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingQty"
        inputField.imageTintColor = .mountainBlue
        inputField.leftImage = quantityPickerFieldImage
        inputField.font = Appearance.appFont(with: 13)
        return inputField
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6.0
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(with: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(with: 13)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let titleTextField: LeftIconTextField = {
        let tf = LeftIconTextField()
        tf.leftImage = nil
        tf.tintColor = .lightPurple
        tf.keyboardType = .default
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.placeholder = "Add a recipe name"
        return tf
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Configuration
    
    func setupViews() {
        view.addSubview(mainStackView)
        
        editableTitle == true
            ? mainStackView.addArrangedSubview(titleTextField)
            : mainStackView.addArrangedSubview(titleLabel)
        if editableTitle == true {
            mainStackView.addArrangedSubview(titleTextField)
        } else {
            mainStackView.addArrangedSubview(titleLabel)
            mainStackView.addArrangedSubview(subtitleLabel)
        }
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(typeInputField)
        inputStackView.addArrangedSubview(quantityInputField)
        
        mainStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0))
        inputStackView.anchor(top: nil, leading: mainStackView.leadingAnchor, bottom: nil, trailing: mainStackView.trailingAnchor)
        
        titleLabel.text = titleName
        subtitleLabel.text = subtitleName
        
        typeInputField.picker.delegate = self
        typeInputField.picker.dataSource = self
        quantityInputField.picker.delegate = self
        quantityInputField.picker.dataSource = self
        titleTextField.delegate = self
    }
    
    private func updateViews() {
        titleLabel.text = titleName
        subtitleLabel.text = subtitleName
    }
    
}

extension FoodSummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return quantityPickerFieldValues.count
        case "servingQty":
            return typePickerFieldValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return quantityPickerFieldValues[row]
        case "servingQty":
            return typePickerFieldValues[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            let type = quantityPickerFieldValues[row]
            typeInputField.text = type
            servingType = type
            //setServingType(with: type, for: food)
            NotificationCenter.default.post(name: .MHFoodSummaryPickerDidChange, object: nil, userInfo: ["quantity": servingQty, "type": servingType])
        case "servingQty":
            let qty = typePickerFieldValues[row]
            quantityInputField.text = qty
            servingQty = qty
            //setServingQty(with: qty, for: food)
            NotificationCenter.default.post(name: .MHFoodSummaryPickerDidChange, object: nil, userInfo: ["quantity": servingQty, "type": servingType])
        default:
            break
        }
    }
    
}

extension FoodSummaryViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        NotificationCenter.default.post(name: .MHFoodSummaryTextFieldDidChange, object: nil, userInfo: ["textField": text])
    }
    
}
