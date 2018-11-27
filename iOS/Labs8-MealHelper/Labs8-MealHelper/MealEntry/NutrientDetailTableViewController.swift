//
//  NutrientDetailTableViewController.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 27.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NutrientDetailTableViewController: UITableViewController {

    var nutrients: [Nutrient]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cellReuseId = "nutrientCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrients?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        
        let nutrient = nutrients?[indexPath.row]
        
        cell.textLabel?.text = nutrient?.name
        cell.detailTextLabel?.text = nutrient?.unit
        
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = nutrient?.value
        cell.accessoryView = label
        
        return cell
    }

}
