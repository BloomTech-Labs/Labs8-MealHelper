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
            setupViews()
        }
    }
    
    var servingQty: String = "1"
    var servingType: String = "cup"
    var typePickerFieldValues = (1...20).map { String($0) }
    var quantityPickerFieldValues: [String] = FoodHelper.ServingTypes.allCases.map { $0.rawValue }
    var typePickerFieldDefaultValue = "cup" {
        didSet {
            typeInputField.text = typePickerFieldDefaultValue
        }
    }
    var quantityPickerFieldDefaultValue = "1" {
        didSet {
            quantityInputField.text = quantityPickerFieldDefaultValue
        }
    }
    var typePickerFieldImage = #imageLiteral(resourceName: "message")
    var quantityPickerFieldImage = #imageLiteral(resourceName: "message")
    var editableTitle = false
    
    // MARK: - Private properties
    
    private lazy var typeInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: typePickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingSize"
        inputField.imageTintColor = .mountainBlue
        inputField.leftImage = typePickerFieldImage
        return inputField
    }()
    
    private lazy var quantityInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: quantityPickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingQty"
        inputField.imageTintColor = .mountainBlue
        inputField.leftImage = quantityPickerFieldImage
        return inputField
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10.0
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
    
    let titleTextField: LeftIconTextField = {
        let tf = LeftIconTextField()
        tf.leftImage = nil
        tf.tintColor = .lightPurple
        tf.keyboardType = .default
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.placeholder = "Add a recipe name"
        return tf
    }()
    
//    private lazy var subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 17.0)
//        return label
//    }()
    
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
        //mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(typeInputField)
        inputStackView.addArrangedSubview(quantityInputField)
        
        mainStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0))
        inputStackView.anchor(top: nil, leading: mainStackView.leadingAnchor, bottom: nil, trailing: mainStackView.trailingAnchor)
        
        titleLabel.text = titleName
        
        typeInputField.picker.delegate = self
        typeInputField.picker.dataSource = self
        quantityInputField.picker.delegate = self
        quantityInputField.picker.dataSource = self
        titleTextField.delegate = self
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
