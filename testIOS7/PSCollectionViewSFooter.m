//
//  PSCollectionViewSFooter.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCollectionViewSFooter.h"

@implementation PSCollectionViewSFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0f];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize labelSize = [_label.text sizeWithFont:_label.font];
    _label.frame = CGRectMake(2, CGRectGetHeight(self.frame) / 2.0f - labelSize.height / 2.0f, labelSize.width, labelSize.height);
}

@end
