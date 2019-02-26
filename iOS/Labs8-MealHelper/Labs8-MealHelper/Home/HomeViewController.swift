//
//  HomieTableViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import ExpandableButton
import Lottie

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    var timer: Timer?
    var countdownTime = 10
    
    let alarmController = AlarmController()
    
    let skyView: SkyView = {
        let view = SkyView()
        view.clipsToBounds = true
        
        return view
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "mountain"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let scheduledMealLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = Appearance.appFont(with: 16)
        label.sizeToFit()
        
        return label
    }()
    
    let countDownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = Appearance.appFont(with: 32)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var collectionView: HomeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = HomeCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.layer.cornerRadius = 16
        cv.layer.masksToBounds = true
        cv.actionDelegate = self
        
        return cv
    }()
    
    lazy var expandableButtonView: ExpandableButtonView = {
        let ebv = ExpandableButtonView(buttonSizes: CGSize(width: 50, height: 50))
        ebv.buttonImages(mainCollapsed: UIImage(named: "plus-icon")!, mainExpanded: UIImage(named: "minus-icon")!, mostLeft: UIImage(named: "alarm_clock")!, left: UIImage(named: "create_new")!, right: UIImage(named: "export")!, mostRight: UIImage(named: "settings")!)
        ebv.buttonColors(main: .white, mostLeft: .white, left: .white, right: .white, mostRight: .white)
        ebv.isLineHidden = true
        ebv.collapseWhenTapped = true
        ebv.delegate = self
        
        return ebv
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.isLoggedIn() {
            fetchMeals()
            fetchAlarms()
        }
        skyView.fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        checkIfUserIsLoggedIn()
    }
    
    private func checkIfUserIsLoggedIn() {
        if !UserDefaults.standard.isLoggedIn() {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .overCurrentContext
            loginViewController.delegate = self
            self.present(loginViewController, animated: true, completion: nil)
        } else {
            fetchUser()
        }
    }
    
    private func fetchUser() {
        let userId = UserDefaults.standard.loggedInUserId()
        APIClient.shared.fetchUser(with: userId) { (response) in
            switch response {
            case .success(let user):
                UserDefaults.standard.setIsLoggedIn(value: true, userId: userId, zipCode: user.zip, email: user.email, token: user.token)
            case .error:
                NSLog("Couldn't fetch user details")
                return
            }
        }
    }
    
    private func fetchAlarms() {
        let userId = UserDefaults.standard.loggedInUserId()
        countdownTime = 10
        APIClient.shared.fetchAlarms(userId: userId) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let alarms):
                    guard let timeRemaining = self.alarmController.timeUntilNextAlarm(alarms: alarms) else {
                        self.scheduledMealLabel.text = "You haven't scheduled\nany meals yet"
                        return
                    }
                    self.setupAlarmCountdown(timeRemaining: timeRemaining)
                case .error:
                    self.showAlert(with: "Unable to load your alarms, please check your internet connection and try again.")
                }
            }
        }
    }
    
    func setupAlarmCountdown(timeRemaining: Int) {
        scheduledMealLabel.text = "Time until next\nscheduled meal"
        countdownTime = timeRemaining
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleCountdown), userInfo: nil, repeats: true)
    }
    
    @objc private func handleCountdown() {
        
        if countdownTime < 1 {
            displayCelebrationAnimation()
            timer?.invalidate()
            fetchAlarms()
            return
        }
        
        countdownTime -= 1
        countDownLabel.text = timeString(time: TimeInterval(countdownTime))
    }
    
    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    private func displayCelebrationAnimation() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let blackBackgroundView = UIView()
            blackBackgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
            blackBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            keyWindow.addSubview(blackBackgroundView)
            blackBackgroundView.fillSuperview()
            
            let animationView = LOTAnimationView()
            animationView.backgroundColor = .clear
            animationView.setAnimation(named: "star_success")
            animationView.layer.cornerRadius = 16
            animationView.layer.masksToBounds = true
            animationView.translatesAutoresizingMaskIntoConstraints = false
            blackBackgroundView.addSubview(animationView)
            animationView.centerInSuperview(size: CGSize(width: 200, height: 200))
            animationView.play { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    animationView.alpha = 0
                    blackBackgroundView.alpha = 0
                    
                }, completion: { (completed) in
                    animationView.removeFromSuperview()
                    blackBackgroundView.removeFromSuperview()
                })
            }
        }
    }
    
    private func fetchMeals() {
        let userId = UserDefaults.standard.loggedInUserId()
        APIClient.shared.fetchMeals(with: userId) { (response) in
            DispatchQueue.main.async {
                switch response {
                case .success(let meals):
                    self.groupAndSort(meals: meals)
                case .error:
                    self.showAlert(with: "Unable to load your meals, please check your internet connection and try again.")
                }
            }
        }
    }
    
    private func groupAndSort(meals: [Meal]) {
        
        var groupedAndSortedMeals = [[Meal]]()
        
        let groupedMeals = Dictionary(grouping: meals) { (meal) -> String in
            return meal.date
        }
        
        let sortedKeys = groupedMeals.keys.sorted(by: { $0 > $1 })
        sortedKeys.forEach { (key) in
            let values = groupedMeals[key]
            groupedAndSortedMeals.append(values ?? [])
        }
        
        self.collectionView.meals = groupedAndSortedMeals
    }

    private func setupViews() {
        
        view.addSubview(skyView)
        skyView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 0))
        
        view.addSubview(scheduledMealLabel)
        scheduledMealLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0))
        scheduledMealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(countDownLabel)
        countDownLabel.anchor(top: scheduledMealLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0), size: .zero)
        countDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0))
        
        view.addSubview(collectionView)
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12), size: CGSize(width: 0, height: 320))
        
        view.addSubview(expandableButtonView)
        expandableButtonView.anchor(top: nil, leading: nil, bottom: collectionView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0), size: CGSize(width: 300, height: 50))
        expandableButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension HomeViewController: HomeCollectionViewDelegate {
    func didSelect(meal: Meal) {
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.meal = meal
        navigationController?.pushViewController(mealDetailViewController, animated: true)
    }
}

extension HomeViewController: ExpandableButtonViewDelegate {
    
    func didTapButton(at position: ExpandableButtonPosition) {
        switch position {
        case .mostLeft:
            let alarmViewController = AlarmViewController()
            present(alarmViewController, animated: true, completion: nil)
        case .left:
            //let mealsTableViewController = MealsTableViewController(navTitle: "Meals")
            let layout = UICollectionViewFlowLayout()
            let recipeTableViewController = RecipeCollectionViewController(collectionViewLayout: layout)
            let navController = WhiteStatusNavController(rootViewController: recipeTableViewController)
            navController.navigationBar.prefersLargeTitles = true
            present(navController, animated: true, completion: nil)
        case .right:
            print("Right")
        case .mostRight:
            let settingsViewController = SettingsViewController()
            settingsViewController.delegate = self
            settingsViewController.modalPresentationStyle = .overCurrentContext
            present(settingsViewController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: SettingsViewControllerDelegate {
    func showLogin() {
        UserDefaults.standard.setIsLoggedIn(value: false, userId: nil, zipCode: nil, email: nil, token: nil)
        countDownLabel.text = nil
        scheduledMealLabel.text = nil
        collectionView.meals.removeAll()
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .overCurrentContext
        loginViewController.delegate = self
        present(loginViewController, animated: false, completion: nil)
    }
}

extension HomeViewController: LoginViewControllerDelegate {
    func userDidLogin() {
        fetchMeals()
        fetchAlarms()
    }
}
