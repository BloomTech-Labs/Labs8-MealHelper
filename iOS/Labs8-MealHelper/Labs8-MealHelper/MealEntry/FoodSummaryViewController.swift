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
    
    var titleString: String? {
        didSet {
            setupViews()
        }
    }
    var servingQty: String?
    var servingType: String?
    var leftPickerFieldValues = (1...20).map { String($0) }
    var rightPickerFieldValues: [String] = FoodHelper.ServingTypes.allCases.map { $0.rawValue }
    var leftPickerFieldDefaultValue = "cup"
    var rightPickerFieldDefaultValue = "1"
    var leftPickerFieldImage = #imageLiteral(resourceName: "message")
    var rightPickerFieldImage = #imageLiteral(resourceName: "message")
    var editableTitle = false
    
    // MARK: - Private properties
    
    private lazy var leftInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: leftPickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingSize"
        inputField.leftImage = leftPickerFieldImage
        return inputField
    }()
    
    private lazy var rightInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: rightPickerFieldDefaultValue)
        inputField.picker.accessibilityIdentifier = "servingQty"
        inputField.leftImage = rightPickerFieldImage
        return inputField
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    
    let titleTextField: LeftIconTextField = {
        let tf = LeftIconTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = .lightPurple
        tf.keyboardType = .default
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.backgroundColor = .white
        tf.placeholder = "Add a recipe name"
        tf.leftImage = #imageLiteral(resourceName: "message")
        return tf
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.text = "Some subtitle"
        return label
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
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(leftInputField)
        inputStackView.addArrangedSubview(rightInputField)
        
        mainStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0))
        inputStackView.anchor(top: nil, leading: mainStackView.leadingAnchor, bottom: nil, trailing: mainStackView.trailingAnchor)
        
        titleLabel.text = titleString
        
        leftInputField.picker.delegate = self
        leftInputField.picker.dataSource = self
        rightInputField.picker.delegate = self
        rightInputField.picker.dataSource = self
    }
    
}

extension FoodSummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return rightPickerFieldValues.count
        case "servingQty":
            return leftPickerFieldValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return rightPickerFieldValues[row]
        case "servingQty":
            return leftPickerFieldValues[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            let type = rightPickerFieldValues[row]
            leftInputField.text = type
            servingType = type
            //setServingType(with: type, for: food)
            NotificationCenter.default.post(name: .MHServingTypeDidChange, object: nil, userInfo: ["servingType": type])
        case "servingQty":
            let qty = leftPickerFieldValues[row]
            rightInputField.text = qty
            servingQty = qty
            //setServingQty(with: qty, for: food)
            NotificationCenter.default.post(name: .MHServingQtyDidChange, object: nil, userInfo: ["servingQty": qty])
        default:
            break
        }
    }
    
}

