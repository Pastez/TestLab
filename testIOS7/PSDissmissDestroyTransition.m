//
//  PSDissmissDestroyTransition.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 10.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSDissmissDestroyTransition.h"
#import "UIImage+ImageEffects.h"

#define GRID_WIDTH      5
#define GRID_HEIGHT     5

@interface PSDissmissDestroyTransition()

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) NSTimer *watchTimer;
@property (strong,nonatomic) NSMutableArray *particles;

@end

@implementation PSDissmissDestroyTransition
{
    CGRect endFrame;
    id<UIViewControllerContextTransitioning> tCtx;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 3.60f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    tCtx = transitionContext;
    self.animator           = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
    self.particles          = [NSMutableArray array];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    endFrame = [transitionContext initialFrameForViewController:fromVC];
    
    UIView *toView = [toVC view];
    toView.frame = endFrame;
    [transitionContext.containerView addSubview:toView];
    
    UIView *fromView = [fromVC view];
    fromView.frame = endFrame;
    [transitionContext.containerView addSubview:fromView];
    
    CGFloat particleWidth = CGRectGetWidth(endFrame)/GRID_WIDTH;
    CGFloat particleHeight = CGRectGetHeight(endFrame)/GRID_HEIGHT;
    for (int dx = 0; dx < GRID_WIDTH; dx++) {
        for (int dy = 0; dy < GRID_HEIGHT; dy++)
        {
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(particleWidth,particleHeight), NO, 0);
            [transitionContext.containerView drawViewHierarchyInRect:CGRectMake(-dx * particleWidth,
                                                                                -dy * particleHeight,
                                                                                CGRectGetWidth(endFrame), CGRectGetHeight(endFrame))
                                                  afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *particleView = [[UIImageView alloc] initWithFrame:CGRectMake(dx * particleWidth,
                                                                                      dy * particleHeight,
                                                                                      particleWidth, particleHeight)];
            particleView.image = image;
            particleView.backgroundColor = [UIColor redColor];
            [transitionContext.containerView addSubview:particleView];
            
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[particleView] mode:UIPushBehaviorModeInstantaneous];
            pushBehavior.magnitude = 1.0f * drand48()*2.0;
            pushBehavior.angle = drand48() * M_PI * 2;
            [_animator addBehavior:pushBehavior];
            
            [_particles addObject:particleView];
        }
    }
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:_particles];
    [_animator addBehavior:gravity];
    
    [fromView removeFromSuperview];
    self.watchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(checkIfFinished:) userInfo:nil repeats:YES];
}

- (void)checkIfFinished:(id)sender
{
    for (UIImageView *particle in _particles) {
        if (CGRectIntersectsRect(endFrame, particle.frame)) {
            return;
        }
    }
    [self.watchTimer invalidate];
    [tCtx completeTransition:YES];
}


@end
