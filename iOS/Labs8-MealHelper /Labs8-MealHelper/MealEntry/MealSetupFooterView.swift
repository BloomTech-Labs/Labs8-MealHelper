//
//  MealSetupFooterView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealSetupFooterView: UIView {
    
    // MARK: - Public properties
    
    var date: Date?
    var note: String?
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    private let notesTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 17.0)
        tv.layer.cornerRadius = 8.0
        tv.layer.masksToBounds = true
        tv.text = "Add a note..."
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    private lazy var dateTextField: PickerInputField = {
        let inputField = PickerInputField(defaultValue: Utils().dateAndTimeString(for: Date()))
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(setDateTextField), for: .allEvents)
        inputField.inputView = datePicker
        return inputField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func setDateTextField(_ sender: UIDatePicker) {
        dateTextField.text = Utils().dateAndTimeString(for: sender.date)
    }

    // MARK: - Private methods
    
    private func setupViews() {
        
        // Main view
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(notesTextView)
        mainStackView.addArrangedSubview(dateTextField)
        
        mainStackView.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor, padding: UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0))
        //notesTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.backgroundColor = UIColor.lightGray
        
        notesTextView.delegate = self
    }
    
}

// MARK: - UITextViewDelegate

extension MealSetupFooterView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a note..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
