//
//  SettingsViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 28/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func showLogin()
}

class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let settingsId = "settingsId"
    let aboutId = "aboutId"
    
    let loadingIndicator = LoadingIndicator()
    
    let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.delegate = self
            
        return mb
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
    }
    
    //MARK: - Functions
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: settingsId)
        collectionView.register(AboutCell.self, forCellWithReuseIdentifier: aboutId)
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        
        view.addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16), size: CGSize(width: 24, height: 24))
        
        let menuBarWidth = (self.view.frame.width / 4) * 2
        
        view.addSubview(menuBar)
        menuBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0), size: CGSize(width: menuBarWidth, height: 40))
        menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0))
    }
    
    func showErrorAlert(with text: String) {
        showAlert(with: text)
    }
    
    //MARK: - ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.barViewLeftConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

//MARK: - NEEDS TO BE REFACTORED

extension SettingsViewController: SettingsCellDelegate {
    func changeEmail() {
        let alert = UIAlertController(title: "Change email", message: nil, preferredStyle: .alert)
        alert.addTextField { (emailTextField) in
            emailTextField.placeholder = "New email"
        }
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Your password"
            passwordTextField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            
            guard let newEmail = alert.textFields?[0].text, newEmail.contains("@"), newEmail.contains("."), let password = alert.textFields?[1].text else {
                self.showAlert(with: "Please make sure you entered a valid email and password.")
                return
            }
            
            self.loadingIndicator.showLoadingAnimation()
            
            let userId = UserDefaults.standard.loggedInUserId()
            APIClient.shared.changeEmail(with: userId, newEmail: newEmail, password: password, completion: { (response) in
                
                DispatchQueue.main.async {
                    switch response {
                    case .success:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "You have successfully changed your email to \(newEmail)")
                    case .error:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "An error occured when changing your email, please check your internet connection and try again.")
                    }
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func changeZip() {
        let alert = UIAlertController(title: "Change zip code", message: nil, preferredStyle: .alert)
        alert.addTextField { (zipTextField) in
            zipTextField.placeholder = "New zip"
        }
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Your password"
            passwordTextField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            
            guard let newZip = alert.textFields?[0].text, let zipInt = Int(newZip), let password = alert.textFields?[1].text else {
                self.showAlert(with: "Please make sure you entered a valid zip and password.")
                return
            }
            
            self.loadingIndicator.showLoadingAnimation()
            
            let userId = UserDefaults.standard.loggedInUserId()
            APIClient.shared.changeZip(with: userId, newZip: zipInt, password: password, completion: { (response) in
                DispatchQueue.main.async {
                    switch response {
                    case .success:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "You have successfully changed your zip to \(newZip)")
                    case .error:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "An error occured when changing your zip code, please check your internet connection and try again.")
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func changePassword() {
        let alert = UIAlertController(title: "Change password", message: nil, preferredStyle: .alert)
        alert.addTextField { (newPasswordTextField) in
            newPasswordTextField.placeholder = "New password"
            newPasswordTextField.isSecureTextEntry = true
            
        }
        alert.addTextField { (oldPasswordTextField) in
            oldPasswordTextField.placeholder = "Old password"
            oldPasswordTextField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            
            guard let newPassword = alert.textFields?[0].text, newPassword.count > 2, let oldPassword = alert.textFields?[1].text, oldPassword.count > 2 else {
                self.showAlert(with: "Please make sure your new password is at least 3 characters long.")
                return
            }
            
            self.loadingIndicator.showLoadingAnimation()
            
            let userId = UserDefaults.standard.loggedInUserId()
            APIClient.shared.changePassword(with: userId, newPassword: newPassword, oldPassword: oldPassword, completion: { (response) in
                DispatchQueue.main.async {
                    switch response {
                    case .success:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "You have successfully changed your password!")
                    case .error:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "An error occured when changing your password, please check your internet connection and try again.")
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteUser() {
        let alert = UIAlertController(title: "Are you sure you want to delete your account? This action cannot be undone.", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            self.loadingIndicator.showLoadingAnimation()
            let userId = UserDefaults.standard.loggedInUserId()
            APIClient.shared.deleteUser(with: userId, completion: { (response) in
                
                DispatchQueue.main.async {
                    switch response {
                    case .success:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.dismiss(animated: true, completion: {
                        self.delegate?.showLogin()
                    })
                    case .error:
                        self.loadingIndicator.finishLoadingAnimation()
                        self.showAlert(with: "Error deleting your account, please check your internet connection and try again.")
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            self.dismiss(animated: true, completion: {
                self.delegate?.showLogin()
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: MenuBarDelegate {
    func selectedMenuItemDidChange(to index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
