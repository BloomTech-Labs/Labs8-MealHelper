//
//  SettingsCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 03/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate: class {
    func deleteUser()
    func logout()
}

class SettingsCell: UICollectionViewCell {
    
    weak var delegate: SettingsCellDelegate?
    
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
    
    let zipCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Change zip"
        
        let zipLabel = UILabel()
        zipLabel.text = "3300"
        zipLabel.textAlignment = .right
        zipLabel.textColor = .lightGray
        
        cell.addSubview(zipLabel)
        zipLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 100, height: 20))
        zipLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
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
    
    lazy var logoutCell: UITableViewCell = {
        let cell = UITableViewCell()
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        cell.addSubview(logoutButton)
        logoutButton.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, size: CGSize(width: 0, height: 40))
        
        return cell
    }()
    
    lazy var deleteCell: UITableViewCell = {
        let cell = UITableViewCell()
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete account", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        cell.addSubview(deleteButton)
        deleteButton.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, size: CGSize(width: 0, height: 40))
        
        return cell
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 40, right: 30))
    }
    
    @objc private func logout() {
        delegate?.logout()
    }
    
    @objc private func deleteAccount() {
        delegate?.deleteUser()
    }
    
    private func changeEmail() {
        
    }
    
    private func changeZip() {
        
    }
    
    private func changePassword() {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: changeEmail()
            case 1: changeZip()
            case 2: changePassword()
            default: fatalError("Wrong number of rows")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 3
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
            case 1: return zipCell
            case 2: return passwordCell
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
        case 1: return "v0.0.1"
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = Appearance.appFont(with: 12)
        header?.textLabel?.textColor = UIColor.init(white: 0.9, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cornerRadius: CGFloat = 10
        
        // Top corners
        let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shapeLayerTop = CAShapeLayer()
        shapeLayerTop.frame = cell.bounds
        shapeLayerTop.path = maskPathTop.cgPath
        
        //Bottom corners
        let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shapeLayerBottom = CAShapeLayer()
        shapeLayerBottom.frame = cell.bounds
        shapeLayerBottom.path = maskPathBottom.cgPath
        
        // All corners
        let maskPathAll = UIBezierPath(roundedRect: cell.contentView.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: cornerRadius / 2, height: cornerRadius / 2))
        let shapeLayerAll = CAShapeLayer()
        shapeLayerAll.frame = cell.contentView.bounds
        shapeLayerAll.path = maskPathAll.cgPath
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.mask = shapeLayerAll
        } else if indexPath.row == 0 {
            cell.layer.mask = shapeLayerTop
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.mask = shapeLayerBottom
        }
    }
}
