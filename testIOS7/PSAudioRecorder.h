//
//  PSAudioRecording.h
//  testIOS7
//
//  Created by Tomasz Kwolek on 29.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSAudioRecorder;

@protocol PSAudioRectorderDelegate <NSObject>

- (void)audioRecorder:(PSAudioRecorder*)audioRecorder didFinishRecordingOfAudoAtURL:(NSURL*)url;

@optional

- (void)audioRecorder:(PSAudioRecorder *)audioRecorder currentDuration:(NSTimeInterval)duration peakPower:(float)power;

@end

@interface PSAudioRecorder : NSObject

@property (assign,nonatomic) id<PSAudioRectorderDelegate> delegate;

- (void)record:(id)sender;
- (void)finish:(id)sender;
- (void)cancel:(id)sender;

@end
