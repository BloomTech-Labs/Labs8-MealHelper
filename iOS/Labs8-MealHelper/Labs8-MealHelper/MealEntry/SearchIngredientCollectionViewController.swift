//
//  IngredientsCollectionViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 04.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SearchIngredientCollectionViewController: FoodsCollectionViewController<Ingredient>, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    var selectedIngredientAtIndex = [Int]() {
        didSet {
            if selectedIngredientAtIndex.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
        }
    }
    
    var savedIngredients = [Ingredient]()
    var sectionHeaderReuseId = "SectionHeaderCell"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Ingredients"
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseId)
        
        
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
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return foods.count
        case 1:
            return savedIngredients.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodCell<Ingredient>
        
        switch indexPath.section {
        case 0:
            let ingredient = foods[indexPath.row]
            cell.food = ingredient
        case 1:
            let ingredient = savedIngredients[indexPath.row]
            cell.food = ingredient
        default:
            break
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // On row click, show a ingredient detail modal
//        let ingredientDetailVC = SearchIngredientDetailViewController()
//        ingredientDetailVC.modalPresentationStyle = .overFullScreen
//        ingredientDetailVC.delegate = self // We use a delegation pattern so the dismissing detailVC can handle selection of an ingredient
//        ingredientDetailVC.delegateIndexPath = indexPath // Select ingredient at indexPath
//
//        let ingredient = indexPath.section == 0 ? foods[indexPath.row] : previousIngredients[indexPath.row]
//        ingredientDetailVC.ingredient = ingredient
//
//        present(ingredientDetailVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let food = foods[indexPath.item]
            didSelect(food)
        case 1:
            let savedIngredient = savedIngredients[indexPath.item]
            didSelect(ingredient: savedIngredient)
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {// On row click, show a ingredient detail modal
        let ingredientDetailVC = SearchIngredientDetailViewController()
        ingredientDetailVC.modalPresentationStyle = .overFullScreen
        ingredientDetailVC.delegate = self // We use a delegation pattern so the dismissing detailVC can handle selection of an ingredient
        ingredientDetailVC.delegateIndexPath = indexPath // Needed to determine the section in which it was selected (searched vs. previously saved ingredients)
        
        let ingredient = indexPath.section == 0 ? foods[indexPath.row] : savedIngredients[indexPath.row]
        ingredientDetailVC.ingredient = ingredient
        
        present(ingredientDetailVC, animated: true, completion: nil)
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderReuseId, for: indexPath) as! SectionHeader
        
        switch indexPath.section {
        case 0:
            sectionHeader.headerLabel.text = "Searched ingredients"
        case 1:
            sectionHeader.headerLabel.text = "Previously searched ingredients"
        default:
            break
        }
        
        return sectionHeader
    }

    override func didNotSelectItems() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didSelectItems() {
        let saveRecipeVC = SaveRecipeViewController()
        saveRecipeVC.ingredients = getSelectedFoods() + getSelectedIngredient()
        navigationController?.pushViewController(saveRecipeVC, animated: true)
    }
    
    func didSelect(ingredient: Ingredient) {
        guard let index = savedIngredients.index(of: ingredient) else { return }
        
        if selectedIngredientAtIndex.contains(index) {
            guard let index = selectedIngredientAtIndex.index(of: index) else { return }
            selectedIngredientAtIndex.remove(at: index)
        } else {
            selectedIngredientAtIndex.append(index)
        }
    }
    
    func getSelectedIngredient() -> [Ingredient] {
        var selectedIngredients = [Ingredient]()
        for index in selectedIngredientAtIndex {
            let food = savedIngredients[index]
            selectedIngredients.append(food)
        }
        return selectedIngredients
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
        case 0:
            guard let index = foods.index(of: ingredient) else { return }
            foods.remove(at: index)
            foods.insert(ingredient, at: index)
            didSelect(ingredient)
        case 1:
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
