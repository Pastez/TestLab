//
//  PSMapViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 17.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSMapViewController.h"
#import "PSMapViewMarker.h"

@interface PSMapViewController() <MKMapViewDelegate>

@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) PSMapViewMarker *marker;

@end

@implementation PSMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLLocationCoordinate2D glc = CLLocationCoordinate2DMake(50.2833, 18.6667);
    
    
    self.mapView = [[MKMapView alloc] init];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.delegate = self;
    _mapView.centerCoordinate = glc;
    [self.view addSubview:_mapView];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeMarkerPosition:)];
    [_mapView addGestureRecognizer:gesture];
    
    self.marker = [[PSMapViewMarker alloc] initWithCoordinate:glc];
    [_mapView addAnnotation:_marker];
    
    UIBarButtonItem *userLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(trackButtonTop:)];
    [self.navigationItem setRightBarButtonItem:userLocationButton];
    
    NSDictionary *viewsToLayout = NSDictionaryOfVariableBindings(_mapView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_mapView]|" options:0 metrics:nil views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:viewsToLayout]];
}

- (void)trackButtonTop:(id)sender
{
    _mapView.showsUserLocation = !_mapView.showsUserLocation;
    NSLog(@"track user: %d",_mapView.showsUserLocation);
}

- (void)changeMarkerPosition:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if (!_mapView.showsUserLocation) {
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
            return;
        
        CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
        
        _marker.coordinate = touchMapCoordinate;
    }
}

- (void)myShowDetailsMethod:(id)sender
{
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[PSMapViewMarker class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
        
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(myShowDetailsMethod:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
    _marker.coordinate = userLocation.location.coordinate;
}

@end
