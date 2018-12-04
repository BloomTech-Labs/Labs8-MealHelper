//
//  IngredientsCollectionViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 04.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import AVFoundation

class SearchIngredientCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
    
    var selectedSearchedIngredientAtIndex = [Int]() {
        didSet {
            if selectedSearchedIngredientAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    var selectedSavedIngredientAtIndex = [Int]() {
        didSet {
            if selectedSavedIngredientAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    var searchedIngredients = [Ingredient]()
    var savedIngredients = [Ingredient]()
    var sectionHeaderReuseId = "SectionHeaderCell"
    var searchBarReuseId = "SearchBarCell"
    var cellId = "FoodCell"
    
    private lazy var searchController: UISearchController = {
        var sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        sc.searchBar.delegate = self
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.setImage(UIImage(named: "camera")!.withRenderingMode(.alwaysTemplate), for: .bookmark, state: .normal) // Set the bookmarkButton to a camera button
        sc.searchBar.tintColor = .mountainBlue
        sc.searchBar.barTintColor = .clear
        sc.searchBar.isTranslucent = false
        return sc
    }()
    
    lazy var noItemSelectedbarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didNotSelectItems))
    }()
    
    lazy var itemsSelectedBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didSelectItems))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        
        // Fetch previously saved ingredients
        FoodClient.shared.fetchIngredients { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.savedIngredients = ingredients
                    self.collectionView.reloadData()
                case .error:
                    self.showAlert(with: "We couldn't find your ingredients, please check your internet connection and try again.")
                    return
                }
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return searchedIngredients.count
        case 2:
            return savedIngredients.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodCell<Ingredient>
        
        switch indexPath.section {
        case 1:
            let ingredient = searchedIngredients[indexPath.row]
            cell.food = ingredient
        case 2:
            let ingredient = savedIngredients[indexPath.row]
            cell.food = ingredient
        default:
            break
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let food = searchedIngredients[indexPath.item]
            didSelect(food)
        case 2:
            let savedIngredient = savedIngredients[indexPath.item]
            didSelect(ingredient: savedIngredient)
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // On row click, show a ingredient detail modal
        let ingredientDetailVC = IngredientDetailViewController()
        ingredientDetailVC.modalPresentationStyle = .overFullScreen
        ingredientDetailVC.delegate = self // We use a delegation pattern so the dismissing detailVC can handle selection of an ingredient
        ingredientDetailVC.delegateIndexPath = indexPath // Needed to determine the section in which it was selected (searched vs. previously saved ingredients)
        
        let ingredient = indexPath.section == 1 ? searchedIngredients[indexPath.row] : savedIngredients[indexPath.row]
        ingredientDetailVC.ingredient = ingredient
        
        present(ingredientDetailVC, animated: true, completion: nil)
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var searchBarHeader: UICollectionReusableView?
        var sectionHeader: SectionHeader?
        
        switch indexPath.section {
        case 0:
            searchBarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchBarReuseId, for: indexPath)
            searchBarHeader?.addSubview(searchController.searchBar)
        case 1:
            sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderReuseId, for: indexPath) as? SectionHeader
            sectionHeader?.headerLabel.text = "Searched ingredients"
        case 2:
            sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderReuseId, for: indexPath) as? SectionHeader
            sectionHeader?.headerLabel.text = "Previously searched ingredients"
        default:
            break
        }
        
        if let searchBarHeader = searchBarHeader {
            return searchBarHeader
        } else if let sectionHeader = sectionHeader  {
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 65)
    }
    
    @objc func didNotSelectItems() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didSelectItems() {
        let saveRecipeVC = SaveRecipeViewController()
        saveRecipeVC.ingredients = getSelectedFoods() + getSelectedIngredient()
        navigationController?.pushViewController(saveRecipeVC, animated: true)
    }
    
    func didSelect(_ food: Ingredient) {
        guard let index = searchedIngredients.index(of: food) else { return }
        
        if selectedSearchedIngredientAtIndex.contains(index) {
            guard let index = selectedSearchedIngredientAtIndex.index(of: index) else { return }
            selectedSearchedIngredientAtIndex.remove(at: index)
        } else {
            selectedSearchedIngredientAtIndex.append(index)
        }
    }
    
    func getSelectedFoods() -> [Ingredient] {
        var selectedFoods = [Ingredient]()
        for index in selectedSearchedIngredientAtIndex {
            let food = searchedIngredients[index]
            selectedFoods.append(food)
        }
        return selectedFoods
    }
    
    func didSelect(ingredient: Ingredient) {
        guard let index = savedIngredients.index(of: ingredient) else { return }
        
        if selectedSavedIngredientAtIndex.contains(index) {
            guard let index = selectedSavedIngredientAtIndex.index(of: index) else { return }
            selectedSavedIngredientAtIndex.remove(at: index)
        } else {
            selectedSavedIngredientAtIndex.append(index)
        }
    }
    
    func getSelectedIngredient() -> [Ingredient] {
        var selectedIngredients = [Ingredient]()
        for index in selectedSavedIngredientAtIndex {
            let food = savedIngredients[index]
            selectedIngredients.append(food)
        }
        return selectedIngredients
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
                if !granted { self.showAlert(with: "Barcode scanner needs access to your camera") }
                
                self.present(cameraVC, animated: true, completion: nil)
            }
            break
        case .denied:
            showAlert(with: "Please go to your phone's settings and provide this app access to your camera")
            break
        case .restricted:
            showAlert(with: "No camera detected")
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
                    self.searchedIngredients = ingredients
                    self.searchController.isActive = false
                    self.collectionView.reloadSections(IndexSet(integer: 1))
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                    self.searchController.isActive = false
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Configuration
    
    private func setupCollectionView() {
        collectionView.register(FoodCell<Ingredient>.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor.init(white: 0, alpha: 0.35)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        collectionView.layer.masksToBounds = true
        
        view.backgroundColor = .mountainDark
        navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
        
//        if let navTitle = navTitle {
//            title = navTitle
//        }
        
        title = "Search Ingredients"
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchBarReuseId)
        
        view.addSubview(searchController.searchBar)
    }
    
}

class SectionHeader: UICollectionViewCell  {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let headerLabel: UILabel = {
        let title = UILabel()
        title.text = "Today"
        title.textColor = .white
        title.backgroundColor = .black
        title.font = UIFont(name: "Montserrat", size: 17)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setupHeaderViews()   {
        addSubview(headerLabel)
        
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchIngredientCollectionViewController: SearchIngredientDetailDelegate {
    
    func updateIngredient(_ ingredient: Ingredient, indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            guard let index = searchedIngredients.index(of: ingredient) else { return }
            searchedIngredients.remove(at: index)
            searchedIngredients.insert(ingredient, at: index)
            didSelect(ingredient)
        case 2:
            guard let index = savedIngredients.index(of: ingredient) else { return }
            savedIngredients.remove(at: index)
            savedIngredients.insert(ingredient, at: index)
            didSelect(ingredient: ingredient)
        default:
            break
        }
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
    }
    
}
