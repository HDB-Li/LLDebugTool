//
//  LLSandboxVideoPreviewController.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLSandboxVideoPreviewController.h"

#import <AVKit/AVKit.h>

#import "LLInternalMacros.h"

@interface LLSandboxVideoPreviewController ()

@property (nonatomic, strong) AVPlayerViewController *avPlayerViewController;

@property (nonatomic, strong) AVPlayer *avPlayer;

@end

@implementation LLSandboxVideoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    [self.view addSubview:self.avPlayerViewController.view];
}

#pragma mark - Over write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.avPlayerViewController.view.frame = CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT - LL_NAVIGATION_HEIGHT);
}

#pragma mark - Getters and setters
- (AVPlayerViewController *)avPlayerViewController {
    if (!_avPlayerViewController) {
        _avPlayerViewController = [[AVPlayerViewController alloc] init];
        _avPlayerViewController.player = self.avPlayer;
    }
    return _avPlayerViewController;
}

- (AVPlayer *)avPlayer {
    if (!_avPlayer) {
        _avPlayer = [[AVPlayer alloc] initWithURL:self.fileURL];
    }
    return _avPlayer;
}

@end
