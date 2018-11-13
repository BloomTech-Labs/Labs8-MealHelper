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
    
    // MARK: - Life Cycle
    
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
        guard let user = user, let password = password else { return }
        APIClient.shared.login(with: user, password: password) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let email):
                    //navigate to homeview
                    print("Login with \(email) completed")
                case .error(let error):
                    self.loginView.showError(for: .incorrectLogin)
                    return
                }
            }
        }
        
//        let status = "successful" // to be handled by network completion --> add an error enum
//        switch status {
//        case "successful": // If response was successful, then show the home view for the user
//            break
//        case "incorrectLogin": // Show error if login incorrect
//            loginView.showError(for: .incorrectLogin)
//        default:
//            break
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.loginView.clear()
            print("logged in")
        })
    }
    
    func createAccount() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let onboardingVC = OnboardingCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
}
