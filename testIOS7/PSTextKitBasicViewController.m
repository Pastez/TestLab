//
//  PSTextKitTestViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSTextKitBasicViewController.h"

@interface PSTextKitBasicViewController()

@property (strong,nonatomic) UIScrollView *scrollView;;
@property (readwrite,nonatomic) UIEdgeInsets labelInsets;
@property (strong,nonatomic) UILabel *label;

@end

@implementation PSTextKitBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    
    self.labelInsets = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
    
    self.label = [[UILabel alloc] init];
    _label.text = @"Lorem ipsum\n\ndolor sit amet, consectetur adipiscing elit. Duis in pharetra massa. Aenean vel massa commodo, aliquam lacus non, vulputate lectus. Vivamus lacinia venenatis est, sed porta libero accumsan vel. Aenean congue molestie consectetur. Vivamus eu euismod elit.\n\nVivamus dictum ultrices leo sit amet varius. Nulla tempor libero vitae orci interdum, non imperdiet felis porta. Duis turpis ligula, pulvinar vitae eros quis, consectetur adipiscing neque. Maecenas ultricies, lectus vel vestibulum accumsan, dolor purus suscipit nunc, et rutrum lectus leo ut magna. Sed convallis turpis mi, in ultrices arcu rutrum fermentum. Donec ut sodales lorem. Donec placerat, sem nec commodo pharetra, leo turpis convallis nulla, consequat porttitor arcu nisi blandit nulla. consectetur adipiscing elit. Duis in pharetra massa. Aenean vel massa commodo, aliquam lacus non, vulputate lectus. Vivamus lacinia venenatis est, sed porta libero accumsan vel. Aenean congue molestie consectetur. Vivamus eu euismod elit.";
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    [_scrollView addSubview:_label];
    
    NSMutableDictionary *views = [NSDictionaryOfVariableBindings(_scrollView,_label) mutableCopy];
    NSDictionary *metrics = @{};
    
    NSString *verticalConstraints = @"V:|[_scrollView]|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints options:0 metrics:metrics views:views]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)updateLabel
{
    _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGSize labelSize = [_label.text sizeWithFont:_label.font constrainedToSize:CGSizeMake(CGRectGetWidth(_scrollView.frame)-(_labelInsets.left+_labelInsets.right), CGFLOAT_MAX)];
    _label.frame = CGRectMake(_labelInsets.left, _labelInsets.top, labelSize.width, labelSize.height);
    _scrollView.contentSize = CGSizeMake(labelSize.width, labelSize.height + _labelInsets.top + _labelInsets.bottom);
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self updateLabel];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateLabel];
}

- (void)preferredContentSizeChanged:(NSNotification*)notification
{
    [self updateLabel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
