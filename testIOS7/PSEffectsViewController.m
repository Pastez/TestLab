//
//  PSEffectsViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 08.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSEffectsViewController.h"
#import "UIImage+ImageEffects.h"

@interface PSEffectsViewController()

@property (strong,nonatomic) UIViewController *modalController;
@property (strong,nonatomic) NSTimer *modalVisibleTimer;

@property (strong,nonatomic) UIImageView *modalImageView;
@property (strong,nonatomic) UIImage *modalBackgroundImage;

@end

@implementation PSEffectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"testImage"]];
    
    UIBarButtonItem *blurBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showModalView:)];
    [self.navigationItem setRightBarButtonItem:blurBt];
}

- (void)showModalView:(id)sender
{
    UIViewController *modalController = [[UIViewController alloc] init];
    modalController.title = @"Fx Test";
    modalController.view.backgroundColor = [UIColor redColor];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalController];
    
    UIBarButtonItem *closeBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideModalView:)];
    [modalController.navigationItem setRightBarButtonItem:closeBt];
    
    CGSize modalSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    UIGraphicsBeginImageContextWithOptions(modalSize, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    self.modalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.modalImageView = [[UIImageView alloc] initWithFrame:modalController.view.bounds];
    [modalController.view addSubview:_modalImageView];
    _modalImageView.image = [_modalBackgroundImage applyLightEffect];
    
    
    self.modalVisibleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(onModalVisible:) userInfo:nil repeats:YES];
    
    [self presentViewController:navController animated:YES completion:^{
        if (!_modalVisibleTimer) {
            
        }
    }];
}

- (void)hideModalView:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [_modalVisibleTimer invalidate];
        self.modalVisibleTimer = nil;
    }];
}

- (void)onModalVisible:(id)sender
{
    CGFloat dy = 0 - CGRectGetMaxY(self.presentedViewController.view.frame);
    NSLog(@"%f",dy);
    _modalImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

@end
