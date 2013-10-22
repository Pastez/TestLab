//
//  PSMapSnapshootViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 11.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSMapSnapshootViewController.h"
#import "PSMapSnapshoot.h"
#import <MapKit/MapKit.h>

#define MARGIN 10

@interface PSMapSnapshootViewController() <PSMapSnapshootProtocol>

@property (strong,nonatomic) PSMapSnapshoot *mapSnapshoot;
@property (strong,nonatomic) UIImageView *snapshootView;

@end

@implementation PSMapSnapshootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.snapshootView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, 230, CGRectGetWidth(self.view.frame)-2*MARGIN, 200 )];
    [self.view addSubview:_snapshootView];
    
    self.mapSnapshoot = [[PSMapSnapshoot alloc] initWithFrame:CGRectMake(MARGIN, MARGIN,
                                                                         CGRectGetWidth(self.view.frame)-2*MARGIN,
                                                                         200)];
    _mapSnapshoot.delegate = self;
    _mapSnapshoot.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_mapSnapshoot];
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(50.2833, 18.6667);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [_mapSnapshoot setRegion:MKCoordinateRegionMake(coordinate, span)];
    
}

- (void)mapSnapshoot:(PSMapSnapshoot *)mapSnapshoot finishCreatingSnapshoot:(UIImage *)snapshoot
{
    _snapshootView.image = snapshoot;
}

@end
