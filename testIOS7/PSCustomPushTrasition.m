//
//  PSCustomTrasition.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCustomPushTrasition.h"
#import "UIImage+ImageEffects.h"

@implementation PSCustomPushTrasition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.60f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect endFrame = [transitionContext initialFrameForViewController:fromVC];
    
    UIView *fromView = [fromVC view];
    fromView.frame = endFrame;
    [transitionContext.containerView addSubview:fromView];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(endFrame), CGRectGetHeight(endFrame)), NO, 0);
    [transitionContext.containerView drawViewHierarchyInRect:endFrame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image applyLightEffect];
    
    UIView *blurViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(endFrame), CGRectGetWidth(endFrame), 1.0)];
    blurViewContainer.clipsToBounds = YES;
    UIImageView *bluredFromView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -image.size.height, image.size.width, image.size.height)];
    bluredFromView.image = image;
    [blurViewContainer addSubview:bluredFromView];
    [transitionContext.containerView addSubview:blurViewContainer];
    
    UIView *toView = [toVC view];
    toView.frame = CGRectMake(CGRectGetMinX(endFrame), CGRectGetMaxY(endFrame), CGRectGetWidth(endFrame), CGRectGetHeight(endFrame));
    [transitionContext.containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toView.frame = endFrame;
        toView.alpha = 1;
        blurViewContainer.frame = endFrame;
        bluredFromView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    } completion:^(BOOL finished) {
        [toView setNeedsUpdateConstraints];
        [transitionContext completeTransition:YES];
        
    }];
}

/*
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect endFrame = [transitionContext initialFrameForViewController:fromVC];
    
    UIView *fromView = [fromVC view];
    fromView.frame = endFrame;
    [transitionContext.containerView addSubview:fromView];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(endFrame), CGRectGetHeight(endFrame)), NO, 0);
    [transitionContext.containerView drawViewHierarchyInRect:endFrame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image applyDarkEffect];
    
    UIImageView *bluredFromView = [[UIImageView alloc] initWithFrame:endFrame];
    bluredFromView.alpha = 0.0;
    bluredFromView.image = image;
    [transitionContext.containerView addSubview:bluredFromView];
    
    UIView *toView = [toVC view];
    toView.frame = CGRectMake(CGRectGetMinX(endFrame), CGRectGetMaxY(endFrame), CGRectGetWidth(endFrame), CGRectGetHeight(endFrame));
    [transitionContext.containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toView.frame = endFrame;
        bluredFromView.alpha = 1;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        [toView setNeedsUpdateConstraints];
        [transitionContext completeTransition:YES];
        
    }];
}
*/
@end
