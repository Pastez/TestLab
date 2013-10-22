//
//  PSTextKitAdvancedViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 08.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSTextKitAdvancedViewController.h"
#import "PSTextKitTextStorage.h"

@interface PSTextKitAdvancedViewController() <UITextViewDelegate>

@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) PSTextKitTextStorage *textStorage;
@property (readwrite,nonatomic) CGSize keyboardSize;

@end

@implementation PSTextKitAdvancedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _textView.frame = self.view.bounds;
}

- (void)createTextView
{
    NSString *text = @"*Lorem ipsum*\n\n_Dolor_ sit amet, consectetur adipiscing ELIT in. Duis in pharetra massa. Aenean vel massa commodo, aliquam lacus non, vulputate lectus. Vivamus lacinia venenatis est, sed porta libero accumsan vel. Aenean congue molestie consectetur. Vivamus eu euismod elit. \n\nVivamus dictum ultrices leo sit amet varius. Nulla tempor libero vitae orci interdum, non imperdiet felis porta. Duis turpis ligula, pulvinar vitae eros quis, _consectetur_ adipiscing neque. Maecenas ultricies, lectus vel vestibulum accumsan, dolor purus suscipit nunc, et rutrum lectus leo ut magna. Sed convallis turpis mi, in ultrices arcu rutrum fermentum. DONEC ut sodales lorem. Donec placerat, sem nec commodo pharetra, leo turpis convallis nulla, consequat porttitor arcu nisi blandit nulla. consectetur adipiscing elit. Duis in pharetra massa. Aenean vel massa commodo, aliquam lacus non, vulputate lectus. Vivamus lacinia venenatis est, sed porta libero accumsan vel. Aenean congue molestie consectetur. Vivamus eu euismod elit.";
    
    // 1. Create the text storage that backs the editor
    NSDictionary* attrs = @{NSFontAttributeName:
                                [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:text
                                      attributes:attrs];
    self.textStorage = [PSTextKitTextStorage new];
    [_textStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = self.view.bounds;
    
    // 2. Create the layout manager
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    // 3. Create a text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    // 4. Create a UITextView
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect textContainer:container];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}

- (void)preferredContentSizeChanged:(NSNotification*)notification
{
     [_textStorage update];
}

- (void)keyboardDidShow:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    _keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self updateTextViewSize];
}

- (void)keyboardDidHide:(NSNotification *)nsNotification {
    _keyboardSize = CGSizeMake(0.0, 0.0);
    [self updateTextViewSize];
}

- (void)updateTextViewSize {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? _keyboardSize.width : _keyboardSize.height;
    
    _textView.frame = CGRectMake(0, 0,
                                 CGRectGetWidth(self.view.frame),
                                 CGRectGetHeight(self.view.frame) - keyboardHeight);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
