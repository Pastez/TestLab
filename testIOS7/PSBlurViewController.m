//
//  PSBlurViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 10.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSBlurViewController.h"
#import "PSBlurView.h"

@interface PSBlurViewController()

@property (strong,nonatomic) PSBlurView *blurView;

@end

@implementation PSBlurViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[PSBlurViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"testImage"]];
    
    self.blurView = [[PSBlurView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_blurView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _blurView.center = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _blurView.center = [touch locationInView:self.view];
}

@end
