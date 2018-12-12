//
//  MealDetailViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 30/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    var meal: Meal? {
        didSet {
            navigationItem.title = meal?.mealTime
            fetchIngredients()
        }
    }
    
    var ingredients: [Ingredient]? {
        didSet {
            ingredientsTableView.ingredients = ingredients
        }
    }
    
    var aggregateNutrients: [Nutrient]? {
        didSet {
            nutrientsView.nutrients = aggregateNutrients
        }
    }
    
    private let transition = NotesAnimator()
    
    let nutrientsView: NutrientsView = {
        let view = NutrientsView()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    let ingredientsTableView: IngredientTableViewController = {
        let tvc = IngredientTableViewController()
        tvc.tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tvc.tableView.layer.cornerRadius = 12
        
        return tvc
    }()
    
    let weatherView: WeatherView = {
        let wv = WeatherView()
        wv.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        wv.layer.cornerRadius = 12
        
        return wv
    }()
    
    let noteView: NotesView = {
        let tv = NotesView()
        tv.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tv.layer.cornerRadius = 12
        tv.addDoneButtonOnKeyboard()
        
        return tv
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mountain"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setGradientBackground(colorOne: UIColor.nightSkyBlue.cgColor, colorTwo: UIColor.mountainDark.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupViews()
    }
    
    private func setupBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(blurEffect)
        blurEffect.fillSuperview()
    }
    
    private func setupViews() {
        
        view.addSubview(nutrientsView)
        nutrientsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 80))
        
        view.addSubview(ingredientsTableView.tableView)
        ingredientsTableView.tableView.anchor(top: nutrientsView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 0, right: 30))
        
        view.addSubview(weatherView)
        weatherView.anchor(top: ingredientsTableView.tableView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 130))
        
        view.addSubview(noteView)
        noteView.anchor(top: weatherView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 40, right: 30), size: CGSize(width: 0, height: 150))
        noteView.delegate = self
        
        view.layoutIfNeeded()
        
        transitioningDelegate = self
        animateIntoView()
    }
    
    private func animateIntoView() {
        // Place view outside of the screen
        let screenWidth = UIScreen.main.bounds.width
        nutrientsView.center.x = screenWidth * -0.5
        ingredientsTableView.tableView.center.x = screenWidth * -0.5
        weatherView.center.x = screenWidth * -0.5
        noteView.center.x = screenWidth * -0.5
        
        // Animate views from left to the center of the screen
        UIView.animateKeyframes(withDuration: 0.65, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.nutrientsView.center.x = self.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.ingredientsTableView.tableView.center.x = self.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.weatherView.center.x = self.view.center.x
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.noteView.center.x = self.view.center.x
            })
        }, completion: nil)
    }
    
    private func fetchIngredients() {
        guard let meal = meal, let recipeId = meal.recipeId else { return }
        FoodClient.shared.fetchIngredients(withRecipeId: recipeId) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let ingredients):
                    self.ingredients = ingredients
                    self.fetchNutrients()
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                    self.showAlert(with: "Could not fetch ingredients.")
                }
            }
        }
    }
    
    private func fetchNutrients() {
        guard let ingredients = ingredients else { return }
        // Fetch nutrients for each ingredient in the recipe
        let dispatchGroup = DispatchGroup()
        for ingredient in ingredients {
            dispatchGroup.enter()
            guard let ingredientId = ingredient.identifier else { return }
            FoodClient.shared.fetchNutrients(withIngredientId: ingredientId) { (response) in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let nutrients):
                        var updatedIngredient = ingredient
                        updatedIngredient.nutrients = nutrients
                        
                        // Add nutrients to fetched ingredient
                        guard let index = self.ingredients?.index(of: updatedIngredient) else { return }
                        self.ingredients?.remove(at: index)
                        self.ingredients?.insert(updatedIngredient, at: index)
                        
                        dispatchGroup.leave()
                    case .error(let error):
                        NSLog("Error fetching nutrients: \(error)")
                    }
                }
            }
        }
        // Once all nutrients have been fetched, aggregate all nutrients
        dispatchGroup.notify(queue: .main) {
            guard let ingredients = self.ingredients else { return }
            self.aggregateNutrients = self.aggregateNutrients(from: ingredients)
        }
    }
    
    private func saveNote() {
        let note = noteView.text
        
    }
    
    private func aggregateNutrients(from ingredients: [Ingredient]) -> [Nutrient] {
        var aggregateNutrients = [Int : Nutrient]()
        
        for ingredient in ingredients {
            guard let nutrients = ingredient.nutrients else { continue }
            
            for nutrient in nutrients {
                if var aggregateNutrient = aggregateNutrients[nutrient.nutrientId] { // If nutrient exists in dict, then sum up current and previous value
                    let sum = (Int(aggregateNutrient.value) ?? 0) + (Int(nutrient.value) ?? 0)
                    aggregateNutrient.value = String(sum)
                    aggregateNutrients[nutrient.nutrientId] = aggregateNutrient
                } else { // If nutrient doesn't exist, add it to dict
                    aggregateNutrients[nutrient.nutrientId] = nutrient
                }
            }
        }
        
        return Array(aggregateNutrients.values)
    }

}

extension MealDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                self.nutrientsView.alpha = 0
                self.ingredientsTableView.tableView.alpha = 0
                self.weatherView.alpha = 0
            })

            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5, animations: {
                self.noteView.center.y -= self.view.center.y
            })
        }, completion: nil)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a note"
            textView.textColor = UIColor.lightGray
        }
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                self.noteView.center.y += self.view.center.y
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5, animations: {
                self.nutrientsView.alpha = 1
                self.ingredientsTableView.tableView.alpha = 1
                self.weatherView.alpha = 1
            })
        }, completion: nil)
    }
}

extension MealDetailViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
}

fileprivate extension UITextView {
    
    var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
