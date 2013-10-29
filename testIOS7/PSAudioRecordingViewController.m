//
//  PSAudioRecordingViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 29.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//


#import "PSAudioRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PSAudioRecorder.h"
#import "PSAudioTableCell.h"

@interface PSAudioRecordingViewController () <UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,PSAudioRectorderDelegate>

@property (assign,nonatomic) NSFileManager *fm;
@property (strong,nonatomic) NSArray *dirContent;

@property (strong,nonatomic) PSAudioRecorder *audioRecorder;

@property (strong,nonatomic) UIButton *recordButton;
@property (strong,nonatomic) UITableView *recordsTableView;
@property (strong,nonatomic) UIProgressView *recordPeak;

@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong,nonatomic) NSTimer *playingTimer;

@end

@implementation PSAudioRecordingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fm = [NSFileManager defaultManager];
    }
    return self;
}

static NSString *cellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"error opening audio session: %@",error);
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [_recordButton setTitle:@"Recording" forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchDragOutside];
    _recordButton.translatesAutoresizingMaskIntoConstraints = NO;
    _recordButton.layer.borderWidth = 0.5f;
    _recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_recordButton];
    
    if (!session.inputAvailable) {
        [_recordButton setEnabled:NO];
    }
    
    self.recordPeak = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _recordPeak.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_recordPeak];
    
    self.recordsTableView = [[UITableView alloc] init];
    [_recordsTableView registerClass:[PSAudioTableCell class] forCellReuseIdentifier:cellIdentifier];
    _recordsTableView.delegate = self;
    _recordsTableView.dataSource = self;
    _recordsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_recordsTableView];
    
    [self reloadContent];
    [_recordsTableView reloadData];
    
    id<UILayoutSupport> topGuide = self.topLayoutGuide;
    NSDictionary *viewsToLayout = NSDictionaryOfVariableBindings(topGuide,_recordPeak,_recordButton,_recordsTableView);
    NSDictionary *metrics = @{};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_recordPeak]|" options:0 metrics:metrics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide][_recordPeak]" options:0 metrics:metrics views:viewsToLayout]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_recordButton]-|" options:0 metrics:metrics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_recordsTableView]|" options:0 metrics:metrics views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-[_recordButton(40)]-[_recordsTableView]-|" options:0 metrics:metrics views:viewsToLayout]];
    
}

- (void)record:(id)sender
{
    [self stopPlaying];
    [self.audioRecorder record:sender];
}

- (void)finishRecord:(id)sender
{
    [self.audioRecorder finish:sender];
    [_recordPeak setProgress:0.0f animated:YES];
}

- (void)cancelRecord:(id)sender
{
    [self.audioRecorder cancel:sender];
    [_recordPeak setProgress:0.0f animated:YES];
}

- (PSAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        self.audioRecorder = [[PSAudioRecorder alloc] init];
        _audioRecorder.delegate = self;
    }
    return _audioRecorder;
}

#pragma mark - PSAudioRecorderDelegate

- (void)audioRecorder:(PSAudioRecorder *)audioRecorder didFinishRecordingOfAudoAtURL:(NSURL *)url
{
    NSMutableArray *dirContent = [NSMutableArray arrayWithArray:_dirContent];
    [dirContent addObject:[url lastPathComponent]];
    _dirContent = dirContent;
    [_recordsTableView beginUpdates];
    [_recordsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dirContent.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_recordsTableView endUpdates];
}

- (void)audioRecorder:(PSAudioRecorder *)audioRecorder currentDuration:(NSTimeInterval)duration peakPower:(float)power
{
    int min = floorf(duration/60.0f);
    int sec = floorf(duration-min*60);
    NSString *recTime = [NSString stringWithFormat:@"%d:%d",min,sec];
    [_recordButton setTitle:recTime forState:UIControlStateHighlighted];
    
    [_recordPeak setProgress:power animated:NO];
}

#pragma mark - player

- (void)playURL:(NSURL*)audioURL
{
    if (_player) {
        if (_player.isPlaying) [_player stop];
        self.player = nil;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [_player setDelegate:self];
    [_player prepareToPlay];
    self.playingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(onPlaying) userInfo:nil repeats:YES];
    [_player play];
}

- (void)stopPlaying
{
    [_player stop];
    self.player = nil;
    [_playingTimer invalidate];
    [_recordPeak setProgress:0.0f animated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlaying];
    NSLog(@"finish playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"decode error: %@",error);
}

- (void)onPlaying
{
    [_recordPeak setProgress:_player.currentTime / _player.duration animated:NO];
}

#pragma mark - file manager

- (void)reloadContent
{
    NSError *error;
    self.dirContent = [_fm contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    if (error) {
        NSLog(@"error while listing directory %@",error);
        return;
    }
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] '.m4a'"];
    self.dirContent = [_dirContent filteredArrayUsingPredicate:predict];
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dirContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [((PSAudioTableCell*)cell) setAudioPath:NSTemporaryDirectory() forFile:_dirContent[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:_dirContent[indexPath.row]];
    [self playURL:[NSURL fileURLWithPath:path]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        [_fm removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:_dirContent[indexPath.row]] error:&error];
        if (!error) {
            [self reloadContent];
            [_recordsTableView beginUpdates];
            [_recordsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_recordsTableView endUpdates];
        }else
        {
            NSLog(@"error while removing item: %@",error);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
