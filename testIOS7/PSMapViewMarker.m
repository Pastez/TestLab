//
//  PSMapViewMarker.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 17.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSMapViewMarker.h"

@interface PSMapViewMarker()

@property (readwrite,nonatomic) CLLocationCoordinate2D cooridinate;

@end

@implementation PSMapViewMarker

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title { return @"Picked Location"; };

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"%f° N, %f° E",_cooridinate.latitude,_cooridinate.longitude];
}

- (CLLocationCoordinate2D)coordinate
{
    return _cooridinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _cooridinate = newCoordinate;
}

@end
