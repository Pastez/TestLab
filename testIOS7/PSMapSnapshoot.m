//
//  PSMapSnapshoot.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 11.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSMapSnapshoot.h"

@interface PSMapSnapshoot() <MKMapViewDelegate>

@property (strong,nonatomic) UIActivityIndicatorView *activitiView;
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation PSMapSnapshoot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 3.0f;
}

- (void)createMapView
{
    if (!_mapView) {
        self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        _mapView.userInteractionEnabled = NO;
        _mapView.delegate = self;
    }
    if (!_mapView.superview) {
        [self addSubview:_mapView];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_mapImage) {
        [_mapImage drawInRect:self.bounds];
    }
}

- (void)setRegion:(MKCoordinateRegion)region
{
    [self createMapView];
    [_mapView setRegion:region animated:NO];
}

- (void)showUserLocation
{
    [self createMapView];
    _mapView.showsUserLocation = YES;
}

#pragma mark - MKMapView delegate


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.showsUserLocation = NO;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if (!_activitiView) {
        self.activitiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activitiView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)*0.2f, CGRectGetWidth(self.frame)*0.2f);
        _activitiView.layer.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor;
        _activitiView.layer.cornerRadius = 3.0f;
        _activitiView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _activitiView.alpha = 0.0f;
        [self addSubview:_activitiView];
    }
    
    [_activitiView startAnimating];
    [UIView animateWithDuration:0.5f animations:^{
        _activitiView.alpha = 1.0f;
    }];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    [UIView animateWithDuration:0.5f animations:^{
        _activitiView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_activitiView stopAnimating];
        [_activitiView removeFromSuperview];
        self.activitiView = nil;
    }];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NO, 0);
    [_mapView drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    self.mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
    
    [_mapView removeFromSuperview];
    _mapView.delegate = nil;
    self.mapView = nil;
    
    if (_delegate && [_delegate respondsToSelector:@selector(mapSnapshoot:finishCreatingSnapshoot:)]) {
        [_delegate mapSnapshoot:self finishCreatingSnapshoot:_mapImage];
    }
}

@end
