//
//  PSCollectionViewCell.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCollectionViewCell.h"

@implementation PSCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
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
    _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    CGSize labelSize = [_label.text sizeWithFont:_label.font];
    _label.frame = CGRectMake(2, 2, labelSize.width, labelSize.height);
}

@end
