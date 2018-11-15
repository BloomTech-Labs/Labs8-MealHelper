//
//  LoginViewController.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 14/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    private var isInLoginState = true
    
    let lightBlurEffect: UIVisualEffectView =
    {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return frost
    }()
    
    let welcomeLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Good to see you!"
        label.font = Appearance.appFont(with: 26)
        label.textColor = .white
        label.isHidden = true
        label.alpha = 0
        label.sizeToFit()
        
        return label
    }()
    
    let segmentedControl: UISegmentedControl =
    {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .lightPurple
        sc.addTarget(self, action: #selector(segmentedStateChanged), for: .valueChanged)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: Appearance.appFont(with: 14)], for: .normal)
        
        return sc
    }()
    
    let emailLabel: UILabel =
    {
        let label = UILabel()
        label.text = "EMAIL ADDRESS"
        label.font = Appearance.appFont(with: 12)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    let emailTextField: LeftIconTextField =
    {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "message")
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    let passwordLabel: UILabel =
    {
        let label = UILabel()
        label.text = "PASSWORD"
        label.font = Appearance.appFont(with: 12)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    let passwordTextField: LeftIconTextField =
    {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "password")
        tf.isSecureTextEntry = true

        return tf
    }()
    
    let usernameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "USERNAME"
        label.font = Appearance.appFont(with: 12)
        label.textColor = .white
        label.sizeToFit()
        label.alpha = 0
        
        return label
    }()
    
    let usernameTextField: LeftIconTextField =
    {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "user_male")
        tf.alpha = 0
        tf.isHidden = true
        
        return tf
    }()
    
    let authButton: LoadingButton =
    {
        let button = LoadingButton(type: .system)
        button.titleLabel?.font = Appearance.appFont(with: 20)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleAuthentication), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        authButton.layer.cornerRadius = authButton.frame.height / 2
        authButton.setGradientBackground(colorOne: UIColor.correctGreen.cgColor, colorTwo: UIColor.lightPurple.cgColor, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .clear
        hideKeyboardWhenTappedAround()
        setupViews()
        
        setupKeyboardNotifications()
    }
    
    private func setupKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboard(notification: NSNotification)
    {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        var willShow = false
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            willShow = true
            stackViewCenterY?.constant -= 150
        case UIResponder.keyboardWillHideNotification:
            willShow = false
            stackViewCenterY?.constant = 0
        default:
            willShow = false
            break
        }
        
        stackViewCenterY?.constant = willShow ? -140 : 0
        welcomeLabelTop?.isActive = willShow ? false : true
        welcomeLabelBottom?.isActive = willShow ? true : false
        
        if willShow
        {
            welcomeLabel.isHidden = false
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            
            self.segmentedControl.alpha = willShow ? 0 : 1
            self.welcomeLabel.alpha = willShow ? 1 : 0
            self.view.layoutIfNeeded()
            
        }) { (completed) in
            
            if !willShow
            {
                self.welcomeLabel.isHidden = true
            }
        }
    }
    
    @objc private func segmentedStateChanged()
    {
        registrationTransition()
        buttonFlipAnimation()
        isInLoginState = isInLoginState ? false : true
    }
    
    private func registrationTransition()
    {
        stackViewHeight?.constant = isInLoginState ? 197.5 : 120
        usernameLabel.isHidden = isInLoginState ? false : true
        usernameTextField.isHidden = isInLoginState ? false : true
        welcomeLabel.text = isInLoginState ? "Welcome aboard!" : "Good to see you!"
        
        UIView.animate(withDuration: 0.3) {
            self.usernameTextField.alpha = self.isInLoginState ? 1 : 0
            self.usernameLabel.alpha = self.isInLoginState ? 1 : 0
            self.authButton.setTitle(self.isInLoginState ? "Register" : "Login", for: .normal)
            self.view.layoutIfNeeded()
        }
    }
    
    private func buttonFlipAnimation()
    {
        let animation = CATransition()
        animation.type = .init(rawValue: "flip")
        animation.startProgress = 0
        animation.endProgress = 1
        animation.subtype = CATransitionSubtype(rawValue: isInLoginState ? "fromTop" : "fromBottom")
        animation.duration = 0.3
        animation.repeatCount = 0
        
        authButton.layer.add(animation, forKey: "animation")
    }
    
    @objc private func handleAuthentication()
    {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Please fill in the email and password fields.")
            return
        }
        
        guard password.count > 5, email.contains("@") else {
            showAlert(with: "Please make sure you entered a valid email and your password is at least 6 characters long.")
            authButton.stopLoading()
            return
        }
        
        if isInLoginState
        {
            handleLogin(email, password)
        }
        else
        {
            handleRegistration(email, password)
        }
    }
    
    private func handleLogin(_ email: String, _ password: String)
    {
        APIClient.shared.login(with: email, password: password) { (response) in
            
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
        
        authButton.startLoading()
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            
            if let error = error
            {
                self.showAlert(with: "Something went wrong, please make sure you entered the right credentials and try again.")
                self.authButton.stopLoading()
                NSLog("Failed to login: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.authButton.stopLoading()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - INCOMPLETE
    private func handleRegistration(_ email: String, _ password: String)
    {
        guard let username = usernameTextField.text, username.count > 1 else {
            showAlert(with: "Please choose a username that is at least 2 characters long.")
            return
        }
        
        authButton.startLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error
            {
                self.showAlert(with: "Something went wrong, check your internet connection or try another email.")
                self.authButton.stopLoading()
                NSLog("Failed to register: \(error)")
                return
            }
            
            guard let uid = user?.user.uid else { return }
            let dictionary = [uid: ["email": email, "username": username]]
            
            Database.database().reference().child("users").updateChildValues(dictionary)
            //needs to save username in db
            
            DispatchQueue.main.async {
                self.authButton.stopLoading()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private var stackViewCenterY: NSLayoutConstraint?
    private var stackViewHeight: NSLayoutConstraint?
    private var welcomeLabelTop: NSLayoutConstraint?
    private var welcomeLabelBottom: NSLayoutConstraint?
    
    private func setupViews()
    {
        view.addSubview(lightBlurEffect)
        lightBlurEffect.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, usernameTextField])
        stackView.axis = .vertical
        stackView.spacing = 35
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 0)
        stackViewHeight = stackView.heightAnchor.constraint(equalToConstant: 120)
        stackViewHeight?.isActive = true
        stackViewCenterY = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        stackViewCenterY?.isActive = true
        
        view.addSubview(authButton)
        authButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: 40, paddingBottom: 0, width: 0, height: 60)
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: nil, left: nil, bottom: stackView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -50, width: 200, height: 30)
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(usernameLabel)
        
        emailLabel.anchor(top: nil, left: emailTextField.leftAnchor, bottom: emailTextField.topAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: -6, width: 0, height: 0)
        
        passwordLabel.anchor(top: nil, left: passwordTextField.leftAnchor, bottom: passwordTextField.topAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: -6, width: 0, height: 0)
        
        usernameLabel.anchor(top: nil, left: usernameTextField.leftAnchor, bottom: usernameTextField.topAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: -6, width: 0, height: 0)
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        welcomeLabelTop = welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        welcomeLabelBottom = welcomeLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -35)
        welcomeLabelTop?.isActive = true
    }
}
