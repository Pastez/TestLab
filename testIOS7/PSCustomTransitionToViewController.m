//
//  PSCustomTransitionToViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCustomTransitionToViewController.h"

@implementation PSCustomTransitionToViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Blured View";
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
    [self.navigationItem setRightBarButtonItem:closeBarButton];
    
    UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeBt setTitle:@"Close" forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    closeBt.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:closeBt];

}

- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
