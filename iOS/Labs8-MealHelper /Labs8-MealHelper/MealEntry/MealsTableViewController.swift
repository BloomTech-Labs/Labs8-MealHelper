//
//  MealsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 08.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class MealsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Public properties
    
    var selectedMealsAtIndex = [Int]() {
        didSet {
            if selectedMealsAtIndex.isEmpty {
                navigationItem.setRightBarButton(createMealBarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(addMealBarButton, animated: true)
            }
        }
    }
    
    // MARK: - Private properties
    
    let meals = ["Chicken tandori", "Pork BBQ", "French Fries"]
    
    var createMealBarButton: UIBarButtonItem!
    var addMealBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: "MealCell")
        createMealBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(createMeal))
        addMealBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(addMeal))
        setupViews()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell

        cell.meal = "Hi"
        //cell.selectButton.tintColor = cell.isCheckMarked ? .green : .gray

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (save, indexPath) in
            // Go to ingredients tbv
        }
        edit.backgroundColor = .green
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (remove, indexPath) in
            
            // Remove
        }
        
        return [remove, edit]
    }

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
        
        if selectedMealsAtIndex.contains(indexPath.row) {
            guard let index = selectedMealsAtIndex.index(of: indexPath.row) else { return }
            selectedMealsAtIndex.remove(at: index)
        } else {
            selectedMealsAtIndex.append(indexPath.row)
        }
        
//        tableView.beginUpdates()
//        cell.selectMeal(cell.selectButton)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        self.title = "Meals"
//        let createItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(createMeal))
        navigationItem.setRightBarButton(createMealBarButton, animated: true)
    }
    
    @objc func createMeal() {
        
    }
    
    @objc func addMeal() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
