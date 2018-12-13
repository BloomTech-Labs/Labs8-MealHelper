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
            noteView.note = meal?.notes
            fetchIngredients()
            fetchNutrients()
            guard let temp = meal?.temp, let humidity = meal?.humidity, let pressure = meal?.pressure else { return }
            weatherView.updateWeather(temperature: temp, humidity: humidity, pressure: pressure)
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
        ingredientsTableView.tableView.anchor(top: nutrientsView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 200))
        
        view.addSubview(weatherView)
        weatherView.anchor(top: ingredientsTableView.tableView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 80))
        
        view.addSubview(noteView)
        noteView.anchor(top: weatherView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 30, bottom: 40, right: 30), size: CGSize(width: 0, height: 150))
        noteView.delegate = self
        
        view.layoutIfNeeded()
        
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
                case .error(let error):
                    NSLog("Error fetching ingredients: \(error)")
                    self.showAlert(with: "Could not fetch ingredients.")
                }
            }
        }
    }
    
    private func fetchNutrients() {
        // Fetch nutrients of the recipe
        guard let meal = meal, let recipeId = meal.recipeId else { return }
        
        FoodClient.shared.fetchNutrients(withRecipeId: recipeId) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let nutrients):
                    self.aggregateNutrients = self.aggregateNutrients(from: nutrients)
                case .error(let error):
                    NSLog("Error fetching nutrients: \(error)")
                }
            }
        }
    }
    
    private func saveNote() {
        guard let note = noteView.text, let meal = meal else { return }
        print(meal)
        FoodClient.shared.add(note, to: meal.identifier) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(_): break
                case .error(let error):
                    NSLog("Error saving note: \(error)")
                    self.showAlert(with: "Could not save note, please try again.")
                }
            }
        }
    }
    
    private func aggregateNutrients(from nutrients: [Nutrient]) -> [Nutrient] {
        guard let meal = meal, let servingSize = meal.servings else { return nutrients }
        var aggregateNutrients = [Int : Nutrient]()
        
        for nutrient in nutrients {
            // Multiply nutrient value by meal serving size
            let multipliedNutrientValue = (Int(nutrient.value) ?? 0) * servingSize
            
            if var aggregateNutrient = aggregateNutrients[nutrient.nutrientId] {
                // Add nutrient value to existing nutrient in aggregateNutrients dict
                let sum = (Int(aggregateNutrient.value) ?? 0) + multipliedNutrientValue
                aggregateNutrient.value = String(sum)
                aggregateNutrients[nutrient.nutrientId] = aggregateNutrient
            } else {
                // Add a new nutrient to aggregateNutrients dict
                var updatedNutrient = nutrient
                updatedNutrient.value = String(multipliedNutrientValue)
                aggregateNutrients[nutrient.nutrientId] = updatedNutrient
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
                self.noteView.center.y -= self.view.center.y - 120
            })
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveNote()
        
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

fileprivate extension UITextView {
    
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
