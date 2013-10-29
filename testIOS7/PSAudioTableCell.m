//
//  PSAudioTableCell.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 29.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSAudioTableCell.h"

@implementation PSAudioTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAudioPath:(NSString *)path forFile:(NSString *)file
{
    _path = path;
    _filename = file;
    
    self.textLabel.text = _filename;
}

@end
