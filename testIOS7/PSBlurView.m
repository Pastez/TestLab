//
//  PSBlurView.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 10.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSBlurView.h"
#import "UIImage+ImageEffects.h"

@interface PSBlurView()

@property (strong,nonatomic) UIImage *bluredImage;

@end

@implementation PSBlurView
{
    CGSize size;
    CGRect drawRect;
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self update];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self update];
}

- (void)update
{
    size = CGSizeMake(self.frame.size.width,self.frame.size.height);
    drawRect = CGRectMake(-self.frame.origin.x, -self.frame.origin.y, CGRectGetWidth(self.superview.frame), CGRectGetHeight(self.superview.frame));
    
    self.alpha = 0.0;
    [self setNeedsDisplay];
    self.alpha = 1.0;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self.superview drawViewHierarchyInRect:drawRect afterScreenUpdates:YES];
    self.bluredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.bluredImage = [_bluredImage applyLightEffect];
    
    
    [self.bluredImage drawInRect:self.bounds];
}

@end
