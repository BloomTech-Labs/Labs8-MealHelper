//
//  HomieTableViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import ExpandableButton

class HomeViewController: UIViewController, UICollectionViewDelegate {

    let headerView: HomeHeaderView = {
        let hv = HomeHeaderView()
        
        return hv
    }()
    
    lazy var collectionView: HomeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = HomeCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.scrollDelegate = self
        
        return cv
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var expandableButtonView: ExpandableButtonView = {
        let ebv = ExpandableButtonView(buttonSizes: CGSize(width: 50, height: 50))
        ebv.buttonImages(main: UIImage(named: "plus")!, mostLeft: UIImage(named: "plus")!, left: UIImage(named: "apple")!, right: UIImage(named: "plus")!, mostRight: UIImage(named: "plus")!)
        ebv.buttonColors(main: .black, mostLeft: .black, left: .black, right: .black, mostRight: .black)
        ebv.isLineHidden = false
        ebv.lineColor = .lightGray
        ebv.lineWidth = 0.5
        ebv.collapseWhenTapped = true
        ebv.delegate = self
        
        return ebv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFooterView()
    }
    
    func resetHeaderHeight() {
        self.headerViewHeightAnchor?.constant = 200
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private var headerViewHeightAnchor: NSLayoutConstraint?
    
    private func setupFooterView() {
        
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        headerViewHeightAnchor = headerView.heightAnchor.constraint(equalToConstant: 200)
        headerViewHeightAnchor?.isActive = true
        
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        view.addSubview(footerView)
        footerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0), size: CGSize(width: view.frame.width, height: 50))
        
        footerView.addSubview(expandableButtonView)
        expandableButtonView.centerInSuperview(size: CGSize(width: 300, height: 53))
    }
    
}

extension HomeViewController: ExpandableButtonViewDelegate {
    
    func didTapButton(at position: ExpandableButtonPosition) {
        switch position {
        case .mostLeft:
            print("Most Left")
        case .left:
            let mealsTableViewController = MealsTableViewController(navTitle: "Meals")
            let navController = UINavigationController(rootViewController: mealsTableViewController)
            navController.navigationBar.prefersLargeTitles = true
            present(navController, animated: true, completion: nil)
            print("Left")
        case .right:
            print("Right")
        case .mostRight:
            print("Most Right")
        }
    }
}

extension HomeViewController: HomeCollectionViewDelegate {
    
    func didScrollDown(offsetY: CGFloat) {
        headerViewHeightAnchor?.constant += abs(offsetY)
    }
    
    func didScrollUp(offsetY: CGFloat) {
        if headerViewHeightAnchor?.constant ?? 0 > 65 {
            headerViewHeightAnchor?.constant -= offsetY/75
            if headerViewHeightAnchor?.constant ?? 0 < 65 {
                headerViewHeightAnchor?.constant = 65
            }
        }
    }
    
    func didEndDragging() {
        if headerViewHeightAnchor?.constant ?? 0 > 200 {
            resetHeaderHeight()
        }
    }
}
