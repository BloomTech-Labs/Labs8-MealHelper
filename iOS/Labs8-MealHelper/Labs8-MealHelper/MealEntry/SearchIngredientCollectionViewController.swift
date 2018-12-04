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
    
    
    var previousIngredients = [Ingredient]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Ingredients"
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseId)
        
        // Fetch previously saved ingredients
        FoodClient.shared.fetchIngredients { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.previousIngredients = ingredients
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
            return previousIngredients.count
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
            let ingredient = previousIngredients[indexPath.row]
            cell.food = ingredient
        default:
            break
        }
        
        return cell
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
    
    override func didSelectItems() {
    }
    
    override func didNotSelectItems() {
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
