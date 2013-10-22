//
//  PSTableTestViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 03.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSTableTestViewController.h"
#import "PSLabelsViewController.h"
#import "PSCollectionViewController.h"
#import "PSTextKitBasicViewController.h"
#import "PSTextKitAdvancedViewController.h"
#import "PSEffectsViewController.h"
#import "PSBlurViewController.h"
#import "PSCustomTransitionFromViewController.h"
#import "PSDynamicsViewController.h"
#import "PSMapSnapshootViewController.h"
#import "PSVideoViewController.h"
#import "PSGCDViewController.h"
#import "PSMapViewController.h"
#import "PSStateRestorationViewController.h"

@interface PSTableTestCellData : NSObject

@property (readwrite,nonatomic) Class destinationViewClass;
@property (strong,nonatomic) NSString *name;

@end

@implementation PSTableTestCellData

- (id)initWithName:(NSString*)name andDestinationViewControllerClass:(Class)destinationViewController
{
    self = [super init];
    if (self) {
        self.name = name;
        self.destinationViewClass = destinationViewController;
    }
    return self;
}

+ (PSTableTestCellData*)cellDataWithName:(NSString*)name andDestinationViewControllerClass:(Class)destinationViewController
{
    return [[PSTableTestCellData alloc] initWithName:name andDestinationViewControllerClass:destinationViewController];
}

@end

@interface PSTableTestViewController() <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) UITableView *myTable;
@property (strong,nonatomic) NSMutableArray *data;

@end

@implementation PSTableTestViewController

static NSString *cellIdentifier = @"Cell";

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[PSTableTestViewController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"pasLab";
    
    self.restorationIdentifier = self.title;
    
    self.myTable = [[UITableView alloc] init];
    [_myTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    _myTable.delegate = self;
    _myTable.dataSource = self;
    _myTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_myTable];
    
#pragma mark apply layout
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _myTable );
    NSDictionary *metrics = @{};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_myTable]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_myTable]|" options:0 metrics:metrics views:views]];
    
    
#pragma mark reload after delay
    self.data = [NSMutableArray array];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (NSInteger i = 0; i < 10; i++) {
            [self.data addObject:[PSTableTestCellData cellDataWithName:[NSString stringWithFormat:@"cell %d",i] andDestinationViewControllerClass:nil]];
        }
        
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Labels" andDestinationViewControllerClass:[PSLabelsViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Custom Layout" andDestinationViewControllerClass:[PSCollectionViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Blur View" andDestinationViewControllerClass:[PSBlurViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Effects" andDestinationViewControllerClass:[PSEffectsViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Custom Transition" andDestinationViewControllerClass:[PSCustomTransitionFromViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"UIDynamics" andDestinationViewControllerClass:[PSDynamicsViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"TextKit Basic" andDestinationViewControllerClass:[PSTextKitBasicViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"TextKit Advanced" andDestinationViewControllerClass:[PSTextKitAdvancedViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Map Snapshoot" andDestinationViewControllerClass:[PSMapSnapshootViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Map Location Picker" andDestinationViewControllerClass:[PSMapViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Video" andDestinationViewControllerClass:[PSVideoViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"Grand Central Dispatch" andDestinationViewControllerClass:[PSGCDViewController class]]];
        [self.data addObject:[PSTableTestCellData cellDataWithName:@"StateRestoration" andDestinationViewControllerClass:[PSStateRestorationViewController class]]];
        
#pragma mark scrolling to bottom afrer reloading data
        
        [_myTable reloadData];
        NSInteger itemsCnt = [self tableView:_myTable numberOfRowsInSection:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemsCnt-1 inSection:0];
        [_myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)preferredContentSizeChanged:(NSNotification*)notification
{
    [_myTable reloadData];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    NSLog(@"%@",coder);
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"%@",coder);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableTestCellData *cellData = _data[ indexPath.row ];
    if (cellData.destinationViewClass) {
        UIViewController *destinationViewController = [[cellData.destinationViewClass alloc] init];
        if ([destinationViewController conformsToProtocol:@protocol(UIViewControllerRestoration)]) {
            destinationViewController.restorationIdentifier = cellData.name;
        }
        //destinationViewController.restorationClass = cellData.destinationViewClass;
        destinationViewController.title = cellData.name;
        [self.navigationController pushViewController:destinationViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static UILabel* label;
    if (!label) {
        label = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
        label.text = @"test";
    }
    
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [label sizeToFit];
    return label.frame.size.height * 1.7;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PSTableTestCellData *cellData = _data[ indexPath.row ];
    
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UIColor* textColor = [UIColor redColor];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                                        NSFontAttributeName : font/*,
                                  NSTextEffectAttributeName : NSTextEffectLetterpressStyle*/};
    
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:cellData.name
                                      attributes:attrs];
    
    cell.textLabel.attributedText = attrString;
    
    return cell;
}

@end
