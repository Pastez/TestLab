//
//  PSCustomPopTrasition.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCustomPopTrasition.h"
#import "UIImage+ImageEffects.h"

@implementation PSCustomPopTrasition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.60f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect endFrame = [transitionContext initialFrameForViewController:fromVC];
    
    UIView *toView = [toVC view];
    toView.frame = endFrame;
    [transitionContext.containerView addSubview:toView];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(endFrame), CGRectGetHeight(endFrame)), NO, 0);
    [transitionContext.containerView drawViewHierarchyInRect:endFrame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image applyLightEffect];
    
    UIView *blurViewContainer = [[UIView alloc] initWithFrame:endFrame];
    blurViewContainer.clipsToBounds = YES;
    UIImageView *bluredFromView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    bluredFromView.image = image;
    [blurViewContainer addSubview:bluredFromView];
    [transitionContext.containerView addSubview:blurViewContainer];
    
    UIView *fromView = [fromVC view];
    fromView.frame = endFrame;
    [transitionContext.containerView addSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromView.frame = CGRectMake(CGRectGetMinX(endFrame), CGRectGetMaxY(endFrame), CGRectGetWidth(endFrame), CGRectGetHeight(endFrame));
        
        blurViewContainer.frame = CGRectMake(0, CGRectGetHeight(endFrame), CGRectGetWidth(endFrame), 1.0);
        bluredFromView.frame = CGRectMake(0, -CGRectGetHeight(endFrame), image.size.width, image.size.height);
    } completion:^(BOOL finished) {
        [toView setNeedsUpdateConstraints];
        [transitionContext completeTransition:YES];
        
    }];
}

@end
