//
//  SettingsCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 03/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    let emailCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Change email"
        
        let emailLabel = UILabel()
        emailLabel.text = "Test@test.dk"
        emailLabel.textAlignment = .right
        emailLabel.textColor = .lightGray
        
        cell.addSubview(emailLabel)
        emailLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 100, height: 20))
        emailLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        return cell
    }()
    
    let passwordCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Change password"
        
        let passwordLabel = UILabel()
        passwordLabel.text = "********"
        passwordLabel.textAlignment = .right
        passwordLabel.textColor = .lightGray
        
        cell.addSubview(passwordLabel)
        passwordLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 100, height: 20))
        passwordLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        return cell
    }()
    
    let logoutCell: UITableViewCell = {
        let cell = UITableViewCell()
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        cell.addSubview(logoutButton)
        logoutButton.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 40))
        
        return cell
    }()
    
    let deleteCell: UITableViewCell = {
        let cell = UITableViewCell()
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete account", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        cell.addSubview(deleteButton)
        deleteButton.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 40))
        
        return cell
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30))
    }
    
    @objc private func logout() {
        print("Logout")
    }
    
    @objc private func deleteAccount() {
        print("Delete account")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 2
        case 1:
            return 2
        default:
            fatalError("Wrong number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return emailCell
            case 1: return passwordCell
            default: fatalError("Wrong number of cells in \(indexPath.section)")
            }
        case 1:
            switch indexPath.row {
            case 0: return logoutCell
            case 1: return deleteCell
            default: fatalError("Wrong number of cells in \(indexPath.section)")
            }
        default: fatalError("Wrong number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "User credentials"
        case 1: return nil
        default: fatalError()
        }
    }
}
