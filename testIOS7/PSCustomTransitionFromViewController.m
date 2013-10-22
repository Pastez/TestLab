//
//  PSCustomTransitionFromViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 09.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCustomTransitionFromViewController.h"
#import "PSCustomTransitionToViewController.h"
#import "PSCustomPushTrasition.h"
#import "PSCustomPopTrasition.h"
#import "PSDissmissDestroyTransition.h"

@interface PSCustomTransitionFromViewController() <UIViewControllerTransitioningDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong,nonatomic) NSArray *pushTransitions;
@property (readwrite,nonatomic) Class pushTransitionClass;
@property (strong,nonatomic) UIPickerView *pushTransitionPicker;

@property (strong,nonatomic) NSArray *popTransitions;
@property (readwrite,nonatomic) Class popTransitionClass;
@property (strong,nonatomic) UIPickerView *popTransitionPicker;

@end

@implementation PSCustomTransitionFromViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = image;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];
    
    UIBarButtonItem *showModalBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showModalView:)];
    [self.navigationItem setRightBarButtonItem:showModalBt];
    
    self.pushTransitions        = @[NSStringFromClass([PSCustomPushTrasition class])];
    self.pushTransitionClass    = NSClassFromString(_pushTransitions[0]);
    self.pushTransitionPicker   = [[UIPickerView alloc] init];
    _pushTransitionPicker.dataSource = self;
    _pushTransitionPicker.delegate = self;
    _pushTransitionPicker.translatesAutoresizingMaskIntoConstraints = NO;
    _pushTransitionPicker.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.view addSubview:_pushTransitionPicker];
    
    self.popTransitions         = @[NSStringFromClass([PSCustomPopTrasition class]),
                                    NSStringFromClass([PSDissmissDestroyTransition class])];
    self.popTransitionClass     = NSClassFromString(_popTransitions[0]);
    self.popTransitionPicker    = [[UIPickerView alloc] init];
    _popTransitionPicker.dataSource = self;
    _popTransitionPicker.delegate = self;
    _popTransitionPicker.translatesAutoresizingMaskIntoConstraints = NO;
    _popTransitionPicker.backgroundColor = _pushTransitionPicker.backgroundColor;
    [self.view addSubview:_popTransitionPicker];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_pushTransitionPicker,_popTransitionPicker);
    NSDictionary *metrics = @{@"pickerHeight":@100};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_pushTransitionPicker]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_popTransitionPicker]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pushTransitionPicker][_popTransitionPicker]|" options:0 metrics:metrics views:views]];
}

- (void)showModalView:(id)sender
{
    UINavigationController *toVc = [[UINavigationController alloc] initWithRootViewController:[[PSCustomTransitionToViewController alloc] init]];
    
    toVc.transitioningDelegate = self;
    toVc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:toVc animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> transition = [[_pushTransitionClass alloc] init];
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> transition = [[_popTransitionClass alloc] init];
    return transition;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _pushTransitionPicker) {
        return _pushTransitions.count;
    }
    return _popTransitions.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if(pickerView == _pushTransitionPicker)
    {
        title = _pushTransitions[ row ];
    }
    else
    {
        title = _popTransitions[ row ];
    }
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:title];
    [result addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _pushTransitionPicker) {
        self.pushTransitionClass = NSClassFromString(_pushTransitions[row]);
    }else
    {
        self.popTransitionClass = NSClassFromString(_popTransitions[row]);
    }
}

@end
