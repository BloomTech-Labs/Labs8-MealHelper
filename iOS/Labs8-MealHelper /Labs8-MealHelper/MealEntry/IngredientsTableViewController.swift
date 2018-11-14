//
//  IngedientsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit

class IngredientsTableViewController: MealsTableViewController {
    
    // MARK: - Private properties
    
    private lazy var searchController: UISearchController = {
        var sc = UISearchController(searchResultsController: nil)
        // sc.searchResultsUpdater = self
        sc.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        sc.searchBar.delegate = self
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.setImage(UIImage(named: "camera")!.withRenderingMode(.alwaysTemplate), for: .bookmark, state: .normal)
        sc.searchBar.tintColor = view.tintColor
        return sc
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! MealTableViewCell
        
        guard let recipe = foods[indexPath.row] as? String else { return cell }
        cell.recipe = recipe
        
        return cell
    }
    
    override func noItemsSelectedAction() {
        let ingredientsVC = IngredientsTableViewController(navTitle: "Ingredients", cell: MealTableViewCell.self, foods: ["Chicken tandori", "Pork BBQ", "French Fries"])
        navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    
    override func itemsSelectedAction() {
        let mealSetupVC = MealSetupTableViewController()
        navigationController?.pushViewController(mealSetupVC, animated: true)
    }
    
}

extension IngredientsTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Real-time search as the user types
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Handle searchBar button click (Image Controller)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
}
