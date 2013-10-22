//
//  PSMainViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 02.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSLabelsViewController.h"
#import "PSTableTestViewController.h"

#define FONT_NAME_BOLD      @"HelveticaNeue-Bold"

@interface PSLabelsViewController() <UITextFieldDelegate>
{
    CGFloat topInset;
}

@property (strong,nonatomic) UITextField *testTfA;
@property (strong,nonatomic) UITextField *testTfB;

@end

@implementation PSLabelsViewController

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testTfA = [[UITextField alloc] init];
    _testTfA.translatesAutoresizingMaskIntoConstraints = NO;
    _testTfA.returnKeyType = UIReturnKeyDone;
    _testTfA.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _testTfA.placeholder = @"placeholder";
    _testTfA.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _testTfA.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.8];
    _testTfA.textColor = [UIColor colorWithRed:0.08f green:0.74f blue:0.87f alpha:1.00f];
    _testTfA.delegate = self;
    
    
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    
    self.testTfB = [[UITextField alloc] init];
    _testTfB.translatesAutoresizingMaskIntoConstraints = NO;
    _testTfB.returnKeyType = UIReturnKeyDone;
    _testTfB.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _testTfB.placeholder = @"placeholder";
    _testTfB.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _testTfB.font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];
    _testTfB.textColor = [UIColor colorWithRed:0.08f green:0.74f blue:0.87f alpha:1.00f];
    
    [self.view addSubview:_testTfA];
    [self.view addSubview:_testTfB];
    
#pragma mark Layout
    
    NSString *verticalConstraint = @"V:|[_testTfA(40)][_testTfB(40)]";
    NSMutableDictionary *views = [NSDictionaryOfVariableBindings( _testTfA, _testTfB ) mutableCopy];
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        views[@"topLayoutGuide"] = self.topLayoutGuide;
        verticalConstraint = @"V:[topLayoutGuide][_testTfA(40)][_testTfB(40)]";
    }
    
    
    NSDictionary *metrics = @{@"topOffset": [NSNumber numberWithFloat:topInset]};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_testTfA]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_testTfB]-|" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint options:0 metrics:metrics views:views]];
    
#pragma mark UIBarButtonItem
    
    UIBarButtonItem *nextBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(continueTap:)];
    self.navigationItem.rightBarButtonItem = nextBBI;
    
}

- (void)continueTap:(id)sender
{
    PSTableTestViewController *tableTestVC = [[PSTableTestViewController alloc] init];
    [self.navigationController pushViewController:tableTestVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_testTfA becomeFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _testTfA) {
        [self.view endEditing:YES];
    }
    return NO;
}

@end
