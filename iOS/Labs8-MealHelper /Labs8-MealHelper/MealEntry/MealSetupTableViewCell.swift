//
//  MealSetupTableViewCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol MealSetupTableViewCellDelegate {
    func setServingQty(with qty: String, for recipe: Any)
    func setServingType(with type: String, for recipe: Any)
}

class MealSetupTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    var recipe: Recipe? {
        didSet {
            setupViews()
        }
    }
    
    var delegate: MealSetupTableViewCellDelegate?
    var servingQtys = (1...20).map { String($0) }
    var servingTypes = ["cup", "100 g", "container", "ounce"]

    // MARK: - Private properties
    
    let servingSizeInputField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: "cup")
        inputField.picker.accessibilityIdentifier = "servingSize"
        return inputField
    }()
    
    let servingQtyInputField: PickerInputField = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MealSetupTableViewCellDelegate
    
    func setServingQty(with qty: String, for recipe: Any) {
        delegate?.setServingQty(with: qty, for: recipe)
    }
    
    func setServingType(with type: String, for recipe: Any) {
        delegate?.setServingType(with: type, for: recipe)
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
        
        servingSizeInputField.picker.delegate = self
        servingSizeInputField.picker.dataSource = self
        servingQtyInputField.picker.delegate = self
        servingQtyInputField.picker.dataSource = self
        
        if let ingredient = recipe {
            nameLabel.text = ingredient.name
            servingLabel.text = "asdflkdj"
        }
    }
    
}

extension MealSetupTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

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
            setServingType(with: type, for: recipe)
        case "servingQty":
            let qty = servingQtys[row]
            servingQtyInputField.text = qty
            setServingQty(with: qty, for: recipe)
        default:
            break
        }
    }
    
}
