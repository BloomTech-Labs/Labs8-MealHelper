//
//  AlarmTableView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 28/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AlarmTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    let cellId = "AlarmCell"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(AlarmCell.self, forCellReuseIdentifier: cellId)
        separatorColor = .mountainBlue
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}