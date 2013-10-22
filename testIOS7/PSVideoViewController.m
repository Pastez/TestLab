//
//  PSVideoViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 17.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+ImageEffects.h"

@interface PSVideoViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIImageView *backgroundView;
@property (strong,nonatomic) UIImageView *snapshootView;
@property (strong,nonatomic) NSDictionary *pickedMediaInfo;
@property (strong,nonatomic) MPMoviePlayerController *movieController;
@property (strong,nonatomic) MPMoviePlayerViewController *videoPlayer;

@end

@implementation PSVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *pickVideo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pickVideo:)];
    [self.navigationItem setRightBarButtonItem:pickVideo];
    
    self.backgroundView = [[UIImageView alloc] init];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.frame = self.view.bounds;
    [self.view addSubview:_backgroundView];
    
    self.snapshootView = [[UIImageView alloc] init];
    _snapshootView.layer.shadowColor = [UIColor blackColor].CGColor;
    _snapshootView.layer.shadowOpacity = 0.6f;
    _snapshootView.layer.shadowRadius = 7.0f;
    _snapshootView.layer.shadowOffset = CGSizeZero;
    _snapshootView.contentMode = UIViewContentModeScaleAspectFill;
    _snapshootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_snapshootView];
    
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:UIImagePickerControllerReferenceURL];
    if (path) {
        self.pickedMediaInfo = @{UIImagePickerControllerReferenceURL: [NSURL URLWithString:path]};
        if (_pickedMediaInfo) {
            UIImage *videSnapshoot = [self snapshootOfVideo:[_pickedMediaInfo objectForKey:UIImagePickerControllerReferenceURL]];
            _snapshootView.image = videSnapshoot;
            
            [self createBackgroundImageWithImage:videSnapshoot];
        }
    }
    
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    _snapshootView.userInteractionEnabled = YES;
    [_snapshootView addGestureRecognizer:videoTap];
    
    id<UILayoutSupport> topGuide = self.topLayoutGuide;
    NSDictionary *viewsToLayout = NSDictionaryOfVariableBindings(topGuide, _snapshootView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_snapshootView]-|" options:0 metrics:nil views:viewsToLayout]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_snapshootView(200)]" options:0 metrics:nil views:viewsToLayout]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_snapshootView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)createBackgroundImageWithImage:(UIImage*)image
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *bluredImage = [image applyLightEffect];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backgroundView.alpha = 0.0;
            _backgroundView.image = bluredImage;
            [UIView animateWithDuration:0.5 animations:^{
                _backgroundView.alpha = 1.0;
            }];
        });
    });
}

- (void)pickVideo:(id)sender
{
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.allowsEditing = NO;
    videoPicker.delegate = self;
    videoPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self.navigationController presentViewController:videoPicker animated:YES completion:nil];
}

- (UIImage*)snapshootOfVideo:(NSURL*)path
{
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:path options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    return image;
}

- (void)playVideo:(id)sender
{
    if (_movieController) {
        [_movieController stop];
        [_movieController.view removeFromSuperview];
    }
    else if (_pickedMediaInfo) {
//        self.videoPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[_pickedMediaInfo objectForKey:UIImagePickerControllerReferenceURL]];
//        [self.navigationController presentViewController:_videoPlayer animated:YES completion:nil];
        self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:[_pickedMediaInfo objectForKey:UIImagePickerControllerReferenceURL]];
        _movieController.view.frame = _snapshootView.frame;
        [self.view addSubview:_movieController.view];
        [_movieController play];
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pickedMediaInfo = info;
    UIImage *videSnapshoot = [self snapshootOfVideo:[info objectForKey:UIImagePickerControllerReferenceURL]];
    _snapshootView.image = videSnapshoot;
    [self createBackgroundImageWithImage:videSnapshoot];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]]
                                              forKey:UIImagePickerControllerReferenceURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
