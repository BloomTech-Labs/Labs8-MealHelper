//
//  NotesViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 09.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    // MARK: - Public properties
    
    
    
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
        return tv
    }()
    
    private let dateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Date"
        tf.font = UIFont.systemFont(ofSize: 17.0)
        tf.setLeftPaddingPoints(10.0)
        tf.setRightPaddingPoints(10.0)
        tf.backgroundColor = .white
        tf.tintColor = .blue
        tf.layer.cornerRadius = 8.0
        tf.layer.masksToBounds = true
        tf.contentHorizontalAlignment = .left
        tf.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Actions
    
    @objc private func doneAddingNotes() {
        
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        // Navigation
        self.title = "Add Notes"
        let nextBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAddingNotes))
        navigationItem.setRightBarButton(nextBarButton, animated: true)
        
        // Main view
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(dateTextField)
        mainStackView.addArrangedSubview(notesTextView)
        
        mainStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, padding: UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        view.backgroundColor = UIColor.lightGray
        
        dateTextField.delegate = self
        dateTextField.text = dateString(for: Date())
        createPicker(for: dateTextField)
    }
    
    private func dateString(for date: Date, in locale: Locale = Locale(identifier: Locale.current.identifier)) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

}

extension NotesViewController: UITextFieldDelegate {
    
    private func createPicker(for input: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setDateTextField), for: .allEvents)
        input.inputView = datePicker
        
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
    
    @objc private func setDateTextField(_ sender: UIDatePicker) {
        dateTextField.text = dateString(for: sender.date)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false // Text field should not be editable (but still listen to touches)
    }
    
}
