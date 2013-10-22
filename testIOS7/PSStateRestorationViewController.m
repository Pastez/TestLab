//
//  PSStateRestoration.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 21.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSStateRestorationViewController.h"

#define FONT_NAME_BOLD      @"HelveticaNeue-Bold"

@interface PSStateRestorationViewController() <UITextFieldDelegate>
{
    CGFloat topInset;
}

@property (strong,nonatomic) UITextField *testTfA;
@property (strong,nonatomic) UITextField *testTfB;
@end

@implementation PSStateRestorationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = @"PSStateRestorationViewController";
        self.restorationClass = [self class];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(appDidEnterBackgroundNotification:)
                                                     name: UIApplicationDidEnterBackgroundNotification
                                                   object: nil];
    }
    
    return self;
}

- (void)appDidEnterBackgroundNotification:(id)sender
{
    NSLog(@"enter foregroud");
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"viewControllerWithRestorationIdentifierPath: %@",identifierComponents);
    return [[PSStateRestorationViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"encode");
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.testTfA.text forKey:@"tfat"];
    [coder encodeObject:self.testTfB.text forKey:@"tfbt"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"decode %@",[coder decodeObjectForKey:@"title"]);
    self.title = [coder decodeObjectForKey:@"title"];
    self.testTfA.text = [coder decodeObjectForKey:@"tfat"];
    self.testTfB.text = [coder decodeObjectForKey:@"tfbt"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testTfA = [[UITextField alloc] init];
    _testTfA.restorationIdentifier = @"testTfA";
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
    _testTfB.restorationIdentifier = @"testTfB";
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
    
}

@end
