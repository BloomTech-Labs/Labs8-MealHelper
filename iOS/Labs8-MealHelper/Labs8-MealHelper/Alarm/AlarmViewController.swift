//
//  AlarmViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 27/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Alarms"
        label.textColor = .white
        label.textAlignment = .center
        label.font = Appearance.appFont(with: 20)
        label.sizeToFit()
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        
        return view
    }()
    
    let tableView: AlarmTableView = {
        let tv = AlarmTableView(frame: .zero, style: .plain)
        
        return tv
    }()
    
    lazy var createAlarmView: CreateAlarmView = {
        let cav = CreateAlarmView(frame: .zero)
        cav.delegate = self
        
        return cav
    }()
    
    private var createAlarmViewTopToBottom: NSLayoutConstraint?
    private var createAlarmViewTopToTop: NSLayoutConstraint?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mountainDark
        
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        setupViews()
        
        createAlarmView.headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateAlarmView)))
        
        APIClient.shared.fetchAlarms(userId: UserDefaults.standard.loggedInUserId()) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let alarms):
                    self.tableView.alarms = alarms
                case .error:
                    self.showAlert(with: "We couldn't find your alarms, please check your internet connection and try again.")
                    return
                }
            }
        }
    }
    
    private func setupAlarm(alarm: Alarm) {

        
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
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            createAlarmViewTopToBottom?.isActive = false
            createAlarmViewTopToTop?.isActive = true
            createAlarmView.headerView.isUserInteractionEnabled = false
            createAlarmView.addAlarmButton.isUserInteractionEnabled = false
            createAlarmView.doneButton.isHidden = false
        case UIResponder.keyboardWillHideNotification:
            createAlarmViewTopToBottom?.isActive = true
            createAlarmViewTopToTop?.isActive = false
            createAlarmView.headerView.isUserInteractionEnabled = true
            createAlarmView.addAlarmButton.isUserInteractionEnabled = true
            createAlarmView.doneButton.isHidden = true
        default:
            break
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @objc private func animateAlarmView() {
        
        createAlarmViewTopToBottom?.constant = createAlarmView.isCollapsed ? -400 : -60
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (completed) in
            
            self.createAlarmView.isCollapsed = self.createAlarmView.isCollapsed ? false : true
        }
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(alarmLabel)
        alarmLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20))
        alarmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16), size: CGSize(width: 24, height: 24))
        
        view.addSubview(seperatorLine)
        seperatorLine.anchor(top: alarmLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0.4))
        
        view.addSubview(tableView)
        tableView.anchor(top: seperatorLine.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0))
        
        view.addSubview(createAlarmView)
        createAlarmView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 450))
        createAlarmViewTopToBottom = createAlarmView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        createAlarmViewTopToBottom?.isActive = true
        createAlarmViewTopToTop = createAlarmView.topAnchor.constraint(equalTo: seperatorLine.bottomAnchor)
    }
}

extension AlarmViewController: CreateAlarmViewDelegate {
    func shouldAnimateView() {
        animateAlarmView()
    }
    
    func didSetAlarm(with time: String, note: String) {
        animateAlarmView()
        
        APIClient.shared.uploadAlarm(time: time, note: note, userId: UserDefaults.standard.loggedInUserId()) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let alarm):
                    self.tableView.alarms?.append(alarm)
                    self.setupAlarm(alarm: alarm)
                case .error:
                    self.showAlert(with: "There was a problem when setting up your alarm, please try again.")
                }
            }
        }
    }
}
