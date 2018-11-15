//
//  MealSetupTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 13.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealSetupTableViewController: UITableViewController {
    
    // MARK: - Public properties
    
    //var recipes = ["Kraft Cheese", "Sausage"]
    var recipes: [Recipe]?
    
    // MARK: - Private properties

    lazy private var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MealSetupTableViewCell.self, forCellReuseIdentifier: "MealSetup")
        
        // Header view - Shows macro nutrients
        let mealSetupHeaderView = MealSetupHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100.0))
        tableView.tableHeaderView = mealSetupHeaderView
        
        // Footer view - Input for notes, weather, date
        let mealSetupFooterView = MealSetupFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 400.0))
        tableView.tableFooterView = mealSetupFooterView
        
        setupViews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealSetup", for: indexPath) as! MealSetupTableViewCell

        cell.recipe = recipes?[indexPath.row]
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    // MARK: - Public methods
    
    @objc func save() {
        print("saved")
        let meal = Meal(mealTime: "", experience: "", date: "", userId: 1)
        // API call to /users/:userid/meals
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        title = "Add meal"
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        
        tableView.allowsSelection = false
    }

}

// MARK: - MealSetupTableViewCellDelegate

extension MealSetupTableViewController: MealSetupTableViewCellDelegate {
    
    func setServingQty(with qty: String, for recipe: Any) {
        // Save qty for meal
    }
    
    func setServingType(with type: String, for recipe: Any) {
        // Save type for meal
    }
    
}

class MealSetupHeaderView: UIView {
    
    // MARK: - Public properties
    // TODO: Change to nutrient model
    var nutrients = [("216 cal", "Calories"), ("30 g", "Carbs"), ("7 g", "Fat"), ("8 g", "Protein")]
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        
        self.addSubview(mainStackView)
        
        for nutrient in nutrients {
            let label = createLabel(with: nutrient.0, subtitle: nutrient.1)
            mainStackView.addArrangedSubview(label)
        }
        
        mainStackView.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor)
        
    }
    
    private func createLabel(with text: String, subtitle: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "\(text)\n\(subtitle)"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }
    
}

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
