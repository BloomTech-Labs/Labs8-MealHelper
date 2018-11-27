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
        label.font = Appearance.appFont(with: 10)
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
        label.font = Appearance.appFont(with: 10)
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
    
    let healthConditionLabel: UILabel =
    {
        let label = UILabel()
        label.text = "HEALTH CONDITION"
        label.font = Appearance.appFont(with: 10)
        label.textColor = .white
        label.sizeToFit()
        label.alpha = 0
        
        return label
    }()
    
    let healthConditionTextField: LeftIconTextField =
    {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "user_male")
        tf.alpha = 0
        tf.isHidden = true
        
        return tf
    }()
    
    let zipCodeLabel: UILabel =
    {
        let label = UILabel()
        label.text = "ZIP CODE"
        label.font = Appearance.appFont(with: 10)
        label.textColor = .white
        label.sizeToFit()
        label.alpha = 0
        
        return label
    }()
    
    let zipCodeTextField: LeftIconTextField =
    {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "location")
        tf.alpha = 0
        tf.isHidden = true
        tf.keyboardType = .decimalPad
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        stackViewHeight?.constant = isInLoginState ? 230 : 120
        healthConditionLabel.isHidden = isInLoginState ? false : true
        healthConditionTextField.isHidden = isInLoginState ? false : true
        zipCodeLabel.isHidden = isInLoginState ? false : true
        zipCodeTextField.isHidden = isInLoginState ? false : true
        welcomeLabel.text = isInLoginState ? "Welcome aboard!" : "Good to see you!"
        
        UIView.animate(withDuration: 0.3) {
            self.healthConditionTextField.alpha = self.isInLoginState ? 1 : 0
            self.healthConditionLabel.alpha = self.isInLoginState ? 1 : 0
            self.zipCodeTextField.alpha = self.isInLoginState ? 1 : 0
            self.zipCodeLabel.alpha = self.isInLoginState ? 1 : 0
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
        
        guard password.count > 2, email.contains("@") else {
            showAlert(with: "Please make sure you entered a valid email and your password is at least 6 characters long.")
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
        authButton.startLoading()
        
        APIClient.shared.login(with: email, password: password) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let userId):
                    print("Login with \(userId.id!) completed")
                     UserDefaults().setIsLoggedIn(value: true, userId: userId.id!)
                    let homeVC = HomeViewController()
                    self.present(homeVC, animated: true, completion: nil)
                case .error(let error):
                    self.showAlert(with: "Something went wrong, please make sure you entered the right credentials and try again.")
                    self.authButton.stopLoading()
                    return
                }
            }
        }
    }
    
    private func handleRegistration(_ email: String, _ password: String)
    {
        guard let healthCondition = healthConditionTextField.text, let zipCode = zipCodeTextField.text, let zipCodeInt = Int(zipCode) else {
            showAlert(with: "Please make sure you have filled in all the fields.")
            return
        }
        
        let user = User(email: email, password: password, zip: zipCodeInt, healthCondition: healthCondition, id: nil)
        authButton.startLoading()
        APIClient.shared.register(with: user) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let userId):
                    UserDefaults().setIsLoggedIn(value: true, userId: userId.id!)
                    let homeVC = HomeViewController()
                    self.present(homeVC, animated: true, completion: nil)
                case .error(let error):
                    self.authButton.stopLoading()
                    print(error)
                    return
                }
            }
        }
    }
    
    private var stackViewCenterY: NSLayoutConstraint?
    private var stackViewHeight: NSLayoutConstraint?
    private var welcomeLabelTop: NSLayoutConstraint?
    private var welcomeLabelBottom: NSLayoutConstraint?
    
    private func setupViews()
    {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "foodbackground"))
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        
        view.addSubview(lightBlurEffect)
        lightBlurEffect.fillSuperview()
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, healthConditionTextField, zipCodeTextField])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), size: .zero)
        stackViewHeight = stackView.heightAnchor.constraint(equalToConstant: 120)
        stackViewHeight?.isActive = true
        stackViewCenterY = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        stackViewCenterY?.isActive = true
        
        view.addSubview(authButton)
        authButton.anchor(top: stackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 60))
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: nil, leading: nil, bottom: stackView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0), size: CGSize(width: 200, height: 30))
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(healthConditionLabel)
        view.addSubview(zipCodeLabel)
        
        emailLabel.anchor(top: nil, leading: emailTextField.leadingAnchor, bottom: emailTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 6, right: 0), size: .zero)
        
        passwordLabel.anchor(top: nil, leading: passwordTextField.leadingAnchor, bottom: passwordTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 6, right: 0), size: .zero)
        
        healthConditionLabel.anchor(top: nil, leading: healthConditionTextField.leadingAnchor, bottom: healthConditionTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 6, right: 0), size: .zero)
        
        zipCodeLabel.anchor(top: nil, leading: zipCodeTextField.leadingAnchor, bottom: zipCodeTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 6, right: 0), size: .zero)
        
        view.addSubview(welcomeLabel)
        
        welcomeLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: .zero)
        welcomeLabelTop = welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        welcomeLabelBottom = welcomeLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -35)
        welcomeLabelTop?.isActive = true
    }
}
