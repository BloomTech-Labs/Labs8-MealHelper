//
//  IngedientsTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SearchIngredientsTableViewController: FoodsTableViewController<Ingredient, FoodTableViewCell<Ingredient>>, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Public properties
    
    var previousIngredients = [Ingredient]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    override lazy var noItemSelectedbarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didNotSelectItems))
    }()
    
    override lazy var itemsSelectedBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didSelectItems))
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
        
        // Fetch previously saved ingredients
        FoodClient.shared.fetchIngredients { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.previousIngredients = ingredients
                case .error(let error):
                    NSLog("Error fetching ingredients\(error)")
                    // Handle error in UI
                    break
                }
            }
        }
    }
    
    // MARK: - UITableViewController
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return foods?.count ?? 0
        case 1:
            return previousIngredients.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Search results"
        case 1:
            return "Previously saved ingredients"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! FoodTableViewCell<Ingredient>
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            guard let ingredient = foods?[indexPath.row] else { return cell }
            cell.food = ingredient
        case 1:
            let ingredient = previousIngredients[indexPath.row]
            cell.food = ingredient
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // On row click, show a ingredient detail modal
        let ingredientDetailVC = SearchIngredientDetailViewController()
        ingredientDetailVC.modalPresentationStyle = .overFullScreen
        ingredientDetailVC.delegate = self // We use a delegation pattern so the dismissing detailVC can handle selection of an ingredient
        ingredientDetailVC.delegateIndexPath = indexPath // Select ingredient at indexPath
        
        let ingredient = indexPath.section == 0 ? foods?[indexPath.row] : previousIngredients[indexPath.row]
        ingredientDetailVC.ingredient = ingredient
        
        present(ingredientDetailVC, animated: true, completion: nil)
    }
    
    override func didNotSelectItems() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didSelectItems() {
        let saveRecipeVC = SaveRecipeViewController()
        saveRecipeVC.ingredients = getSelectedFoods()
        navigationController?.pushViewController(saveRecipeVC, animated: true)
    }
    
    // MARK: - UISearchBarDelegate, UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // Real-time search as the user types
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // On clicking the bookmark button present a camera view
        let cameraVC = CameraViewController()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            present(cameraVC, animated: true, completion: nil)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                // Show alert message instead:
                // if !granted { fatalError("MealHelper needs camera access") } --> Handle differently
                
                self.present(cameraVC, animated: true, completion: nil)
            }
            break
        case .denied:
            // Fall through to next case statement
            fallthrough
        case .restricted:
            // Show alert message instead:
            //fatalError("MealHelper needs camera access") --> Handle differently
            break
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Make call to usda food database
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        FoodClient.shared.fetchUsdaIngredients(with: searchTerm) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.foods = ingredients
                    self.searchController.isActive = false
                    self.tableView.reloadData()
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                    self.searchController.isActive = false
                }
            }
        }
    }
    
}

extension SearchIngredientsTableViewController: SearchIngredientDetailDelegate {
    
    func updateIngredient(_ ingredient: Ingredient, indexPath: IndexPath) {
        guard let index = foods?.index(of: ingredient) else { return }
        foods?.remove(at: index)
        foods?.insert(ingredient, at: index)
    }
    
    
}
