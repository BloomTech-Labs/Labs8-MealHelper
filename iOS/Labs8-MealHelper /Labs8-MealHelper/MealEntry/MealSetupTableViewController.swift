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
    
    var meals = ["Kraft Cheese", "Sausage"]
    
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
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealSetup", for: indexPath) as! MealSetupTableViewCell

        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    // MARK: - Public methods
    
    @objc func save() {
        print("saved")
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
    
    func setServingQty(with qty: String, for meal: Any) {
        // Save qty for meal
    }
    
    func setServingType(with type: String, for meal: Any) {
        // Save type for meal
    }
    
}
