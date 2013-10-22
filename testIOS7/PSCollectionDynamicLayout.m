//
//  PSCollectionDynamicLayout.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCollectionDynamicLayout.h"

@interface PSCollectionDynamicLayout()

@property (strong,nonatomic) UIDynamicAnimator *animator;

@end

@implementation PSCollectionDynamicLayout

- (void)prepareLayout
{
    [super prepareLayout];
    if (!_animator)
    {
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        CGSize contentSize = self.collectionViewContentSize;
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for(UICollectionViewLayoutAttributes *currentItem in items){
            
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:currentItem attachedToAnchor:currentItem.center];
            
            spring.length = 0;
            spring.damping = 0.4 + drand48() * 0.4;
            spring.frequency = 0.8;
            
            [_animator addBehavior:spring];
            
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    // shift layout attributes by delta
    for(UIAttachmentBehavior *spring in _animator.behaviors){
        UICollectionViewLayoutAttributes *currentItem = spring.items.firstObject;
        
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat touchDistance = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat resistanceFactor = 0.002; // it simply works well
        
        CGPoint center = currentItem.center;
        // center.y += MIN(scrollDelta * touchDistance * resistanceFactor, scrollDelta);
        
        float resistedScroll = scrollDelta * touchDistance * resistanceFactor;
        float simpleScroll = scrollDelta;
        
        float actualScroll = MIN(abs(simpleScroll), abs(resistedScroll));
        if(simpleScroll < 0){
            actualScroll *= -1;
        }
        
        // NSLog(@"scrolls: %f, %f; %f", resistedScroll, simpleScroll, actualScroll);
        
        center.y += actualScroll;
        currentItem.center = center;
        
        [_animator updateItemUsingCurrentState:currentItem];
        
    }
    
    // notify dynamic animator
    return NO;
    
}

@end
