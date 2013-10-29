//
//  PSAudioRecording.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 29.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface PSAudioRecorder() <AVAudioRecorderDelegate>

@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) NSTimer *recordingTimer;

@end

@implementation PSAudioRecorder

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createRecorder
{
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[self temporaryFileURL] settings:[self settings] error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (NSMutableDictionary*)settings
{
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    return recordSetting;
}

- (NSURL*)temporaryFileURL
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.m4a",[NSDate timeIntervalSinceReferenceDate]]];
#if DEBUG
    NSLog(@"recording into:%@",path);
#endif
    return [NSURL fileURLWithPath:path];
}

#pragma mark - interface

- (void)record:(id)sender
{
    if (!_recorder.isRecording)
    {
        [self createRecorder];
        [_recorder record];
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(onRecording) userInfo:nil repeats:YES];
    }
#if DEBUG
    else
    {
        NSLog(@"already recording");
    }
#endif
    
}

- (void)finish:(id)sender
{
    if (_recorder.isRecording) {
        [_recordingTimer invalidate];
        [_recorder stop];
        if (_delegate && [_delegate respondsToSelector:@selector(audioRecorder:didFinishRecordingOfAudoAtURL:)]) {
            [_delegate audioRecorder:self didFinishRecordingOfAudoAtURL:_recorder.url];
        }
    }
#if DEBUG
    else
    {
        NSLog(@"recorder not recording");
    }
#endif
}

- (void)cancel:(id)sender
{
    if (_recorder.isRecording) {
        [_recordingTimer invalidate];
        [_recorder stop];
        if (![_recorder deleteRecording]) {
            NSLog(@"error while removing audio file");
        }
    }
}

- (void)onRecording
{
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecorder:currentDuration:peakPower:)]) {
        [_recorder updateMeters];
        float power = [_recorder peakPowerForChannel:0] / -160.0;
        [_delegate audioRecorder:self currentDuration:_recorder.currentTime peakPower:power];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    if (flag) {
#if DEBUG
        NSLog(@"recording finished");
#endif
    }else
    {
#if DEBUG
        NSLog(@"recording finished unsuccessfull");
#endif
    }
}

@end
