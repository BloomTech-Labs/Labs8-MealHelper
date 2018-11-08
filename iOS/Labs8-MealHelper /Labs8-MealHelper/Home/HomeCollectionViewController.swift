//
//  HomieTableViewController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import ExpandableButton

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "mealCell"
    private let footerId = "footerId"
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var expandableButtonView: ExpandableButtonView = {
        let ebv = ExpandableButtonView(buttonSizes: CGSize(width: 50, height: 50))
        ebv.buttonImages(main: UIImage(named: "plus")!, mostLeft: UIImage(named: "plus")!, left: UIImage(named: "plus")!, right: UIImage(named: "plus")!, mostRight: UIImage(named: "plus")!)
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
        
        setupCollectionView()
        setupFooterView()
        let footerView = UIView()
        footerView.backgroundColor = .green
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupFooterView() {
        view.addSubview(footerView)
        footerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0), size: CGSize(width: view.frame.width, height: 50))
        
        footerView.addSubview(expandableButtonView)
        expandableButtonView.centerInSuperview(size: CGSize(width: 300, height: 53))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MealCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}

extension HomeCollectionViewController: ExpandableButtonViewDelegate {
    
    func didTapButton(at position: ExpandableButtonPosition) {
        switch position {
        case .mostLeft:
            print("Most Left")
        case .left:
            print("Left")
        case .right:
            print("Right")
        case .mostRight:
            print("Most Right")
        }
    }
}
