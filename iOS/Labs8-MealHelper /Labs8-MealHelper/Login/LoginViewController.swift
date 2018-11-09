//
//  loginViewController.swift
//  ios-meal-helper
//
//  Created by De MicheliStefano on 06.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate {
    
    // MARK: - Properties
    
    var loginView: LoginView!
    let apiClient = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(frame: view.frame)
        loginView.delegate = self
        view.addSubview(loginView)
        loginView.fillSuperview()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func handleLogin(for user: String?, with password: String?) {
        
        
        // Send user details to the web server
        let status = "successful" // to be handled by network completion --> add an error enum
        switch status {
        case "successful": // If response was successful, then show the home view for the user
            break
        case "incorrectLogin": // Show error if login incorrect
            loginView.showError(for: .incorrectLogin)
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.loginView.clear()
            print("logged in")
        })
    }
    
    func createAccount() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let onboardingVC = OnboardingCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
}
