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

class IngredientsTableViewController: FoodsTableViewController<Ingredient, FoodTableViewCell<Ingredient>>, UISearchBarDelegate, UISearchResultsUpdating {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! FoodTableViewCell<Ingredient>
        
        guard let ingredient = foods?[indexPath.row] else { return cell }
        cell.food = ingredient
        
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
                //if !granted { fatalError("MealHelper needs camera access") }
                
                self.present(cameraVC, animated: true, completion: nil)
            }
            break
        case .denied:
            // Fall through to next case statement
            fallthrough
        case .restricted:
            // Show alert message instead:
            //fatalError("MealHelper needs camera access")
            break
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Make call to api
    }
    
}
