//
//  IngredientTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 28.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class IngredientTableViewController: UITableViewController  {

    let reuseCellId = "IngredientCell"
    
    var ingredients: [Ingredient]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: reuseCellId)
        tableView.separatorColor = .mountainBlue
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath) as! IngredientTableViewCell
        
        let ingredient = ingredients?[indexPath.row]
        cell.title = ingredient?.name
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        guard let recipe = self.foods?[indexPath.row] else { return nil }
//        
//        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (save, indexPath) in
//            let editRecipeVC = EditRecipeViewController()
//            editRecipeVC.ingredients = recipe.ingredients
//            editRecipeVC.recipeName = recipe.name
//            self.navigationController?.pushViewController(editRecipeVC, animated: true)
//        }
//        edit.backgroundColor = .green
//        
//        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { (remove, indexPath) in
//            let foodClient = FoodClient.shared
//            
//            if let id = recipe.identifier {
//                
//                foodClient.deleteRecipe(withId: String(id), completion: { (response) in
//                    switch response {
//                    case .success(let response):
//                        if response == 1 {
//                            guard let index = self.foods?.index(of: recipe) else { return }
//                            self.foods?.remove(at: index)
//                            self.tableView.reloadData()
//                        }
//                        
//                    case .error(let error):
//                        print(error)
//                        //Handle error
//                    }
//                })
//                
//            }
//        }
//        
//        return [remove, edit]
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
