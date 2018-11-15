//
//  MealsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 08.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class FoodsTableViewController<Resource, Cell: UITableViewCell>: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Public properties
    
    var foods: [Resource]?
    var navTitle: String!
    var cellReuseId: String!
    var selectedFoodAtIndex = [Int]() {
        didSet {
            print(selectedFoodAtIndex)
            if selectedFoodAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    // MARK: - Private properties
        
    lazy private var noItemSelectedbarButton: UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(noItemsSelectedAction))
    }()
    
    lazy private var itemsSelectedBarButton: UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(itemsSelectedAction))
    }()
    
    // MARK: - Init
    
    init(navTitle: String) {
        self.navTitle = navTitle
        self.cellReuseId = "\(String(describing: navTitle))Cell"
        
        super.init(style: .plain)
        self.tableView.register(Cell.self, forCellReuseIdentifier: self.cellReuseId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        //cell.recipe = recipes[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (save, indexPath) in
            // Go to ingredients tbv
        }
        edit.backgroundColor = .green
        
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { (remove, indexPath) in
            
            // Remove
        }
        
        return [remove, edit]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectFood(at: indexPath)
        
    }

    func selectFood(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FoodTableViewCell<Resource> {
            cell.selectRow(cell.selectButton)
        }
        
        if selectedFoodAtIndex.contains(indexPath.row) {
            guard let index = selectedFoodAtIndex.index(of: indexPath.row) else { return }
            selectedFoodAtIndex.remove(at: index)
        } else {
            selectedFoodAtIndex.append(indexPath.row)
        }
    }
    
    func getSelectedFoods() -> [Resource] {
        var selectedFoods = [Resource]()
        for index in selectedFoodAtIndex {
            guard let food = foods?[index] else { continue }
            selectedFoods.append(food)
        }
        return selectedFoods
    }
    
    // MARK: - User Actions
    
    @objc func noItemsSelectedAction() {
        
    }
    
    @objc func itemsSelectedAction() {
        
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        self.title = navTitle
        navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
    }

}
