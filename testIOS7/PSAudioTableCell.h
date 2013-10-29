//
//  PSAudioTableCell.h
//  testIOS7
//
//  Created by Tomasz Kwolek on 29.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAudioTableCell : UITableViewCell

@property (readonly,nonatomic) NSString *filename;
@property (readonly,nonatomic) NSString *path;

- (void)setAudioPath:(NSString*)path forFile:(NSString*)file;

@end
