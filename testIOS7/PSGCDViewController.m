//
//  PSGCDViewController.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 16.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSGCDViewController.h"

@interface PSGCDViewController()

@property (strong,nonatomic) UIProgressView *progressView;

@end

@implementation PSGCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    _progressView.progress = 1.0;
    [self.view addSubview:_progressView];
    
    [self taskAB];
    
}

- (void)taskAB
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_group_t grup = dispatch_group_create();
        
        dispatch_group_async(grup, queue, ^{
            double x = 1;
            int largerNumber = 999999999;
            for (int i = 0; i < largerNumber; i++) {
                x += x * i;
                
                if (i % 10000 == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _progressView.progress = (float)i / (float)largerNumber;
                    });
                }
            }
            NSLog(@"block A");
        });
        
        dispatch_group_wait(grup, DISPATCH_TIME_FOREVER);
        
        dispatch_group_async(grup, queue, ^{
            NSLog(@"block B");
        });
        
        dispatch_group_notify(grup, dispatch_get_main_queue(), ^{
            NSLog(@"all task done");
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    });
}

- (void)taskBA
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t grup = dispatch_group_create();
    
    
    dispatch_group_async(grup, queue, ^{
        double x = 1;
        for (int i = 0; i < INT_MAX; i++) {
            x += x * i;
        }
        NSLog(@"block A");
    });
    
    //dispatch_group_wait(grup, DISPATCH_TIME_FOREVER);
    
    dispatch_group_async(grup, queue, ^{
        NSLog(@"block B");
    });
    
    dispatch_group_notify(grup, dispatch_get_main_queue(), ^{
        NSLog(@"all task done");
    });
}

@end
