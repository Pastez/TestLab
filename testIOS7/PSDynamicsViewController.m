//
//  PSDynamicsViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSDynamicsViewController.h"

@interface PSDynamicsViewController()

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIGravityBehavior *gravityBeahavior;
@property (strong,nonatomic) UICollisionBehavior *collisionBeahavior;
@property (strong,nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (strong,nonatomic) UIAttachmentBehavior *attachmentBehavior;


@end

@implementation PSDynamicsViewController
{
    UIView<UIDynamicItem> *currentItem;
    CGPoint attachmentPoint;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBeahavior = [[UIGravityBehavior alloc] init];
    
    self.collisionBeahavior = [[UICollisionBehavior alloc] init];
    _collisionBeahavior.translatesReferenceBoundsIntoBoundary = YES;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] init];
    attachmentPoint = CGPointZero;
    
    [_animator addBehavior:_gravityBeahavior];
    [_animator addBehavior:_collisionBeahavior];
    [_animator addBehavior:_itemBehavior];
    
    int itemCnt = 10;
    int itemWidth = CGRectGetWidth(self.view.frame)/(itemCnt/2);
    int itemHeight = 30;
    CGFloat dx = 0;
    CGFloat dy = 50;
    for (int i = 0; i < itemCnt; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        [button setTitle:@"tapMe!" forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIApplication sharedApplication].delegate.window.tintColor.CGColor;
        button.frame = CGRectMake(dx, dy, itemWidth, itemHeight);
        dx += itemWidth / 2;
        dy += itemHeight;
        [self.view addSubview:button];
        [_itemBehavior addItem:button];
        [_collisionBeahavior addItem:button];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    attachmentPoint = [touch locationInView:self.view];
    for (UIView* item in self.view.subviews) {
        if (CGRectContainsPoint(item.frame, attachmentPoint)) {
            currentItem = item;
            
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:currentItem attachedToAnchor:attachmentPoint];
            _attachmentBehavior.length = 40.0f;
            [_animator addBehavior:_attachmentBehavior];
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    attachmentPoint = [touch locationInView:self.view];
    if (_attachmentBehavior) {
        [_attachmentBehavior setAnchorPoint:attachmentPoint];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_animator removeBehavior:_attachmentBehavior];
    [_gravityBeahavior addItem:currentItem];
}

@end
