//
//  loginView.swift
//  ios-meal-helper
//
//  Created by De MicheliStefano on 06.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func handleLogin(for user: String?, with password: String?)
    func createAccount()
}

class LoginView: UIView, UITextFieldDelegate {

    // MARK: - Properties
    
    var padding: CGFloat = 35.0
    var delegate: LoginDelegate?
    
    private lazy var backgroundImageView : UIImageView = {
        let image = UIImage(named: "backgroundImage")!
        let iv = UIImageView(image: image)
        return iv
    }()
    
    let lightBlurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frost.effect = nil
        return frost
    }()
    
    private let usernameLabel: InputField = {
        let inputField = InputField(placeholder: "Username")
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    private let passwordLabel: InputField = {
        let inputField = InputField(placeholder: "Password")
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.backgroundColor = .red
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create a new account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 35.0)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        return spinner
    }()
    
    enum LoginErrorTypes: String {
        case incorrectLogin = "Incorrect username or password."
        case network = "Could not connect to a network."
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - User Actions
    
    @objc func handleLogin() {
        if inputIsValid() {
            errorLabel.text = nil
            delegate?.handleLogin(for: usernameLabel.text, with: passwordLabel.text)
            animateLogin()
        }
    }
    
    @objc func createAccount() {
        delegate?.createAccount()
    }
    
    func clear() { // Clear input fields and revert login animation
        usernameLabel.text = nil
        passwordLabel.text = nil
        
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.spinner.center = CGPoint(x: -20.0, y: 16.0)
            self.spinner.alpha = 0.0
            self.loginButton.bounds.size.width -= 80.0
            self.loginButton.center.y -= 60.0
            self.createAccountButton.isHidden = false
            self.lightBlurEffect.effect = nil // TODO: Refactor into CALayer animation, since the performance is quite laggy
        }, completion: nil)
    }
    
    // MARK: - Public
    
    func showError(for type: LoginErrorTypes) { // Clear input fields and show error text
        self.clear()
        errorLabel.text = type.rawValue
    }
    
    // MARK: - Helper methods
    
    private func inputIsValid() -> Bool {
        var inputIsValid = true
        
        if let username = usernameLabel.text, username.count < 1 {
            animateInputError(for: usernameLabel)
            inputIsValid = false
        }
        
        if let password = passwordLabel.text, password.count < 1 {
            animateInputError(for: passwordLabel)
            inputIsValid = false
        }
        
        return inputIsValid
    }
    
    // MARK: - Animations
    
    private func animateInputError(for input: UITextField) { // Shakes the corresponding input to indicate that input was not valid.
        input.center.x -= 10.0
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, animations: {
            input.center.x += 10.0
        })
    }
    
    private func animateLogin() { // Animates login button and adds a spinner to indicate that the login process is in progress.
        endEditing(true) //  Resign first responder status of the view.

        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, animations: {
            self.loginButton.bounds.size.width += 80
        }, completion: nil)
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, animations: {
            self.loginButton.center.y += 60
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height / 2)
            self.spinner.alpha = 1.0
            self.createAccountButton.isHidden = true
        }, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.lightBlurEffect.effect = UIBlurEffect(style: .light)
        }
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubview(lightBlurEffect)
        self.addSubview(header)
        self.addSubview(usernameLabel)
        self.addSubview(passwordLabel)
        self.addSubview(errorLabel)
        self.addSubview(loginButton)
        loginButton.addSubview(spinner)
        self.addSubview(createAccountButton)
        
        // Background image
        backgroundImageView.fillSuperview()
        lightBlurEffect.fillSuperview()
        
        // Header
        header.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: UIScreen.main.bounds.maxX * 0.15, left: 20.0, bottom: 0.0, right: 20.0))
        
        // Text fields & Buttons
        usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        usernameLabel.anchor(top: header.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: padding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.maxX * 0.8, height: 35.0))
        
        passwordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordLabel.anchor(top: usernameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: padding - 15.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.maxX * 0.8, height: 35.0))
        
        errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorLabel.anchor(top: passwordLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: padding / 4, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.maxX * 0.8, height: 15.0))
        
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.anchor(top: passwordLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: padding, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 220.0, height: 50.0))
        
        createAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        createAccountButton.anchor(top: loginButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: padding / 2, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 220.0, height: 15.0))
        
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        lightBlurEffect.fillSuperview()
    }
    

}
