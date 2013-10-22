//
//  PSCollectionViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCollectionViewController.h"
#import "PSCollectionLayout.h"
#import "PSCollectionDynamicLayout.h"
#import "PSCollectionViewCell.h"
#import "PSCollectionViewSFooter.h"

#define UI_DYNAMICS_ENABLED 1

@interface PSCollectionViewController() <UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

static NSString *CellUniqueIdentifier = @"Cell";
static NSString *FooterUniqueIdentifier = @"Footer";

@implementation PSCollectionViewController

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
    
    //UICollectionViewLayout *layout = [[PSCollectionLayout alloc] init];
    UICollectionViewLayout *layout = [[PSCollectionDynamicLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[PSCollectionViewCell class] forCellWithReuseIdentifier:CellUniqueIdentifier];
    [_collectionView registerClass:[PSCollectionViewSFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    
    NSDictionary *metrics = @{};
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:metrics views:views]];
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PSCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:CellUniqueIdentifier forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%d,%d",indexPath.row,indexPath.section];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        supplementaryView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        ((PSCollectionViewSFooter*)supplementaryView).label.text = [NSString stringWithFormat:@"Section %d",indexPath.section];
    }
    return supplementaryView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 11;
    }
    return 7;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

@end
