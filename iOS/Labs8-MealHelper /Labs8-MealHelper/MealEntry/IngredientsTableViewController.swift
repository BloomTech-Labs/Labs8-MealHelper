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
        sc.searchResultsUpdater = self
        sc.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        sc.searchBar.delegate = self
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.setImage(UIImage(named: "camera")!.withRenderingMode(.alwaysTemplate), for: .bookmark, state: .normal) // Set the bookmarkButton to a camera button
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredientDetailVC = IngredientDetailViewController()
        ingredientDetailVC.modalPresentationStyle = .overFullScreen
        // We use a delegation pattern so the dismissing VC can handle selection of a row
        ingredientDetailVC.delegate = self
        ingredientDetailVC.delegateIndexPath = indexPath
        present(ingredientDetailVC, animated: true, completion: nil)
    }
    
    override func noItemsSelectedAction() {
    }
    
    override func itemsSelectedAction() {
        
    }
    
}

extension IngredientsTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Real-time search as the user types
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // On clicking the bookmark button present a camera view
        let cameraVC = CameraViewController()
        present(cameraVC, animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Make call to api
    }
    
}
