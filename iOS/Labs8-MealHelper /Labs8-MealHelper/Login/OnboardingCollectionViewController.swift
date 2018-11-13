//
//  OnboardingCollectionViewController.swift
//  ios-meal-helper
//
//  Created by De MicheliStefano on 07.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class OnboardingCollectionViewController: UICollectionViewController {

    private var cellSize: CGSize!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Configuration
    
    private func setupView() {
        collectionView!.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        collectionView.isPagingEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isUserInteractionEnabled = true
        cellSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
    
        cell.delegate = self
        
        if indexPath.item == 0 { cell.isLastCell = true } // If user reaches last page, we want onboarding to finished and be saved
        
        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension OnboardingCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension OnboardingCollectionViewController: OnboardingCollectionViewCellDelegate {
    
    func save(user: User) {
        APIClient.shared.register(with: user) { (response) in
            
            DispatchQueue.main.async {
                switch response {
                case .success(let id):
                    print("success: \(id)")
                case .error(let error):
                    print(error)
                }
            }
        }
    }

    func previousCell() {
        let contentOffset = collectionView.contentOffset
        
        // If the user taps back on the first cell, she should be redirected to the login page
        if contentOffset.x == 0 { navigationController?.popViewController(animated: true) }
        
        // Move the user to the previous cell
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
    func nextCell() {
        let contentOffset = collectionView.contentOffset
        
        // Move the user to the next cell
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
}
