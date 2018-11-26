//
//  StretchyHeaderLayout.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 13/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect), let offset = collectionView?.contentOffset else { return nil }
        
        if offset.y < 0 {
            let deltaY = abs(offset.y)
            for attributes in layoutAttributes {
                if let elementKind = attributes.representedElementKind {
                    if elementKind == UICollectionView.elementKindSectionHeader {
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + deltaY)
                        frame.origin.y = frame.minY - deltaY
                        attributes.frame = frame
                    }
                }
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
