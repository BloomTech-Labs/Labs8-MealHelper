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
    
    var savedIngredients = [Ingredient]() {
        didSet {
            if savedIngredients.isEmpty {
                navigationItem.setRightBarButton(noItemSelectedbarButton, animated: true)
            } else {
                navigationItem.setRightBarButton(itemsSelectedBarButton, animated: true)
            }
            
            setPopupTitle(withCount: savedIngredients.count)
            ingredientTableVC.ingredients = savedIngredients
        }
    }
    var searchedIngredients = [Ingredient]()
    var prevSavedIngredients = [Ingredient]()
    var selectedCell: FoodCell<Ingredient>?
    
    private var sectionHeaderReuseId = "SectionHeaderCell"
    private var searchBarReuseId = "SearchBarCell"
    private var cellId = "FoodCell"
    private var transition = SearchIngredientAnimator()
    private var foodHelper = FoodHelper()
    
    private var savePopupViewTopToBottom: NSLayoutConstraint?
    private var savePopupViewTopToTop: NSLayoutConstraint?
    
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
        let bb = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapBarButtonWithoutSelectedItems))
        bb.isEnabled = false
        bb.tintColor = UIColor.lightGray
        return bb
    }()
    
    lazy var itemsSelectedBarButton: UIBarButtonItem = {
        let bb = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapBarButtonWithSelectedItems))
        return bb
    }()
    
    lazy var savePopupView: PopupView = {
        let view = PopupView(frame: .zero)
        view.delegate = self
        view.headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popupView)))
        view.hasActionButton = false
        
        return view
    }()
    
    private let ingredientTableVC: IngredientTableViewController = {
        let tv = IngredientTableViewController()
        return tv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSavePopupView()
        
        // Fetch previously saved ingredients
        FoodClient.shared.fetchIngredients { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.prevSavedIngredients = self.unique(ingredients)
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
    
    //MARK: - CollectionViewControllerDelegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return searchedIngredients.count
        case 2:
            return prevSavedIngredients.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FoodCell<Ingredient>
        
        switch indexPath.section {
        case 1:
            let searchedIngredient = searchedIngredients[indexPath.row]
            cell.food = searchedIngredient
        case 2:
            let prevSavedIngredient = prevSavedIngredients[indexPath.row]
            cell.food = prevSavedIngredient
        default:
            break
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let searchedIngredient = searchedIngredients[indexPath.item]
            didSelect(searchedIngredient)
        case 2:
            let prevSavedIngredient = prevSavedIngredients[indexPath.item]
            didSelect(prevSavedIngredient)
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // On row click, show a ingredient detail modal
        let ingredientDetailVC = SearchIngredientDetailViewController()
        ingredientDetailVC.modalPresentationStyle = .overFullScreen
        ingredientDetailVC.delegate = self // We use a delegation pattern so the dismissing detailVC can handle selection of an ingredient
        ingredientDetailVC.delegateIndexPath = indexPath // Needed to determine the section in which it was selected (searched vs. previously saved ingredients)
        
        let ingredient = indexPath.section == 1 ? searchedIngredients[indexPath.row] : prevSavedIngredients[indexPath.row]
        ingredientDetailVC.ingredient = ingredient
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? FoodCell<Ingredient> // We need to store the cell for the transition animation
        ingredientDetailVC.transitioningDelegate = self
        
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
    
    //MARK: - User Actions
    
    @objc func didTapBarButtonWithoutSelectedItems() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapBarButtonWithSelectedItems() {
        let saveRecipeVC = SaveRecipeViewController()
        saveRecipeVC.ingredients = savedIngredients
        navigationController?.pushViewController(saveRecipeVC, animated: true)
    }
    
    func didSelect(_ ingredient: Ingredient) {
        if let index = savedIngredients.index(of: ingredient) {
            savedIngredients.remove(at: index)
        } else {
            savedIngredients.append(ingredient)
        }
    }
    
    // MARK: - UISearchBarDelegate, UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // Real-time search as the user types
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // On clicking the bookmark button present a camera view
        let cameraVC = CameraViewController()
        cameraVC.delegate = self
        
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
                    let filteredIngredients = ingredients.map { self.foodHelper.cleaned($0) }
                    
                    self.searchedIngredients.removeAll() // Reset searched ingredient results on subsequent searches
                    self.searchedIngredients.append(contentsOf: filteredIngredients)
                    self.searchController.isActive = false
                    self.collectionView.reloadSections(IndexSet(integer: 1)) // Reloads searched ingredients section
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
    
    // MARK: - Private
    
    private func unique(_ ingredients: [Ingredient]) -> [Ingredient] {
        var filteredIngredients = [Ingredient]()
        
        for ingredient in ingredients {
            if !filteredIngredients.contains(ingredient) {
                filteredIngredients.append(ingredient)
            }
        }
        
        return filteredIngredients
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
        
        title = "Search Ingredients"
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchBarReuseId)
        
        view.addSubview(searchController.searchBar)
    }
    
    private func setupSavePopupView() {
        view.addSubview(savePopupView)
        savePopupView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 450))
        savePopupViewTopToBottom = savePopupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        savePopupViewTopToBottom?.isActive = true
        
        savePopupView.containerView.addSubview(ingredientTableVC.tableView)
        ingredientTableVC.tableView.fillSuperview()
        
        setPopupTitle(withCount: 0)
    }
    
    private func setPopupTitle(withCount count: Int) {
        let unit = count == 1 ? "ingredient" : "ingredients"
        savePopupView.title = "\(count) \(unit)"
    }
    
}

extension SearchIngredientCollectionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
}

class SectionHeader: UICollectionViewCell  {
    
    override init(frame: CGRect) {
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
    
    func updateIngredient(_ ingredient: Ingredient, indexPath: IndexPath?) {
        if let indexPath = indexPath {
        
            switch indexPath.section {
            case 1:
                guard let index = searchedIngredients.index(of: ingredient) else { return }
                searchedIngredients.remove(at: index)
                searchedIngredients.insert(ingredient, at: index)
                didSelect(ingredient)
            case 2:
                guard let index = prevSavedIngredients.index(of: ingredient) else { return }
                prevSavedIngredients.remove(at: index)
                prevSavedIngredients.insert(ingredient, at: index)
                didSelect(ingredient)
            default:
                break
            }
            
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            
        } else {
            // Handle ingredients added from barcode scanner
            let filteredIngredient = foodHelper.cleaned(ingredient)
            searchedIngredients.insert(filteredIngredient, at: 0)
            savedIngredients.append(filteredIngredient)
            collectionView.reloadData()
            
            collectionView.selectItem(at: IndexPath(item: 0, section: 1), animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
    
}


extension SearchIngredientCollectionViewController: PopupViewDelegate {
    
    @objc func popupView() {
        savePopupViewTopToBottom?.constant = savePopupView.isCollapsed ? -400 : -60
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (completed) in
            
            self.savePopupView.isCollapsed = self.savePopupView.isCollapsed ? false : true
        }
    }
    
}
