//
//  LLEntryViewController.m
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

#import "LLEntryViewController.h"
#import "LLEntryBallView.h"
#import "LLConfig.h"
#import "UIView+LL_Utils.h"
#import "LLMacros.h"

@interface LLEntryViewController ()

@property (nonatomic, strong) LLEntryBallView *ballView;

@property (nonatomic, assign) LLConfigWindowStyle style;

@end

@implementation LLEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Primary
- (void)initial {
    self.view.backgroundColor = [UIColor clearColor];
    self.style = [LLConfig sharedConfig].windowStyle;

    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:doubleTap];
}

- (void)updateStyle:(LLConfigWindowStyle)style {
    switch (style) {
        case LLConfigWindowSuspensionBall: {
            [self.view addSubview:self.ballView];
        }
            break;
        case LLConfigWindowNetBar: {
            [_ballView removeFromSuperview];
        }
            break;
        case LLConfigWindowPowerBar: {
            [_ballView removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

- (void)tapGR:(UITapGestureRecognizer *)sender {
//    [_delegate LLEntryWindow:self didTapAt:1];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
//    [_delegate LLEntryWindow:self didTapAt:2];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *activeView = [self activeEntryView];
    CGPoint activePoint = [self.view convertPoint:point toView:activeView];
    if ([activeView pointInside:activePoint withEvent:event]) {
        return YES;
    }
    return NO;
}

- (UIView *)activeEntryView {
    switch (self.style) {
        case LLConfigWindowSuspensionBall:
            return self.ballView;
        case LLConfigWindowNetBar:
            return nil;
        case LLConfigWindowPowerBar:
            return nil;
    }
}

#pragma mark - Lazy
- (void)setStyle:(LLConfigWindowStyle)style {
    _style = style;
    [self updateStyle:style];
}

- (LLEntryBallView *)ballView {
    if (!_ballView) {
        CGFloat width = [LLConfig sharedConfig].suspensionBallWidth;
        _ballView = [[LLEntryBallView alloc] initWithFrame:CGRectMake(-[LLConfig sharedConfig].suspensionWindowHideWidth, [LLConfig sharedConfig].suspensionWindowTop, width, width)];
    }
    return _ballView;
}

@end
