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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        collectionView!.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        collectionView.isPagingEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        cellSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
    
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        cell.delegate = self
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
