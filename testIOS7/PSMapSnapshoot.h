//
//  PSMapSnapshoot.h
//  testIOS7
//
//  Created by Tomasz Kwolek on 11.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PSMapSnapshoot;

@protocol PSMapSnapshootProtocol <NSObject>

@optional

- (void)mapSnapshoot:(PSMapSnapshoot*)mapSnapshoot finishCreatingSnapshoot:(UIImage*)snapshoot;

@end

@interface PSMapSnapshoot : UIView

@property (strong,nonatomic) id<PSMapSnapshootProtocol> delegate;
@property (strong,nonatomic) UIImage *mapImage;

- (void)setRegion:(MKCoordinateRegion)region;
- (void)showUserLocation;

@end
