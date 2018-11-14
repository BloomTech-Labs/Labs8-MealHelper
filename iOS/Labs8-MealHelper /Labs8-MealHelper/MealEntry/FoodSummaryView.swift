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

class FoodSummaryView: UIView {
    
    // MARK: - Public properties
    
    var food: Any = "meal"
    var servingQty: String?
    var servingType: String?
    var servingQtys = (1...20).map { String($0) }
    var servingTypes = ["cup", "100 g", "container", "ounce"]

    
    // MARK: - Private properties

    private let servingSizeInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: "cup")
        inputField.picker.accessibilityIdentifier = "servingSize"
        return inputField
    }()
    
    private let servingQtyInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: "1")
        inputField.picker.accessibilityIdentifier = "servingQty"
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var servingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
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
    
    // MARK: - Configuration
    
    private func setupViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(servingLabel)
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(servingSizeInputField)
        inputStackView.addArrangedSubview(servingQtyInputField)
        
        mainStackView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        inputStackView.anchor(top: nil, leading: mainStackView.leadingAnchor, bottom: nil, trailing: mainStackView.trailingAnchor)
        
        nameLabel.text = "Kraft Cheese"
        servingLabel.text = "1 cup"
        
        servingSizeInputField.picker.delegate = self
        servingSizeInputField.picker.dataSource = self
        servingQtyInputField.picker.delegate = self
        servingQtyInputField.picker.dataSource = self
    }
    
}

extension FoodSummaryView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return servingTypes.count
        case "servingQty":
            return servingQtys.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            return servingTypes[row]
        case "servingQty":
            return servingQtys[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "servingSize":
            let type = servingTypes[row]
            servingSizeInputField.text = type
            servingType = type
            //setServingType(with: type, for: food)
        case "servingQty":
            let qty = servingQtys[row]
            servingQtyInputField.text = qty
            servingQty = qty
            //setServingQty(with: qty, for: food)
        default:
            break
        }
    }
    
}

