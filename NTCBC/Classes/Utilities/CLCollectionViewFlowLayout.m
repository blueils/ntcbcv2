//
//  CLCollectionViewFlowLayout.m
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-17.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import "CLCollectionViewFlowLayout.h"

@implementation CLCollectionViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOrigin = proposedContentOffset.x ;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalOriginal = layoutAttributes.frame.origin.x;
        
        if (ABS(itemHorizontalOriginal - horizontalOrigin) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalOriginal - horizontalOrigin;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
