//
//  QuestionCollectionViewFlowLayout.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/6/19.
//

import UIKit


public class QuestionCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var insertingTopCells: Bool = false
    var sizeForTopInsertions: CGSize = CGSize.zero
    var lastPoint: CGPoint = CGPoint.zero
    
    override public func prepare() {
        
        super.prepare()
        
        let oldSize: CGSize = sizeForTopInsertions
        
        if insertingTopCells {
            
            let newSize: CGSize  = collectionViewContentSize
            let xOffset: CGFloat = collectionView!.contentOffset.x + (newSize.width - oldSize.width)
            let newOffset: CGPoint = CGPoint(x: xOffset, y: collectionView!.contentOffset.y)
            collectionView!.contentOffset = newOffset
        }
        else {
            insertingTopCells = false
        }
        
        sizeForTopInsertions = collectionViewContentSize
    }
    
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var layoutAttributes: Array = layoutAttributesForElements(in: collectionView!.bounds)!
        
        if layoutAttributes.count == 0 {
            return proposedContentOffset
        }
        var targetIndex = layoutAttributes.count / 2
        
        let velocityX = velocity.x
        
        if velocityX > 0 {
            targetIndex += 1
        } else if velocityX < 0.0 {
            targetIndex -= 1
        }else if velocityX == 0 {
            return lastPoint
        }
        
        if targetIndex >= layoutAttributes.count {
            targetIndex = layoutAttributes.count - 1
        }
        
        if targetIndex < 0 {
            targetIndex = 0
        }
        
        let targetAttribute = layoutAttributes[targetIndex]
        
        lastPoint = CGPoint(x: targetAttribute.center.x - collectionView!.bounds.size.width * 0.5, y: proposedContentOffset.y)
        return lastPoint
    }
    
}
