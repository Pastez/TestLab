//
//  PSCollectionLayout.h
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCollectionLayoutSettings : NSObject

@property (readwrite,nonatomic) UIEdgeInsets layoutInsets;
@property (readwrite,nonatomic) UIEdgeInsets footerInsets;
@property (readwrite,nonatomic) CGFloat bigItemRightMagin;
@property (readwrite,nonatomic) CGSize bigItemSize;
@property (readwrite,nonatomic) CGSize smallItemSize;
@property (readwrite,nonatomic) CGFloat footerHeight;

@end

@interface PSCollectionLayout : UICollectionViewLayout

@property (strong,nonatomic) PSCollectionLayoutSettings *settings;

- (id)initWithCollectionLayoutSettings:(PSCollectionLayoutSettings*)settings;

@end
