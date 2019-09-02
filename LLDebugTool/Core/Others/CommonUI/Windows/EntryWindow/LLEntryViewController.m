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
#import "LLSettingManager.h"
#import "LLEntryRectView.h"
#import "LLTool.h"

@interface LLEntryViewController ()

@property (nonatomic, strong) LLEntryBallView *ballView;

@property (nonatomic, strong) LLEntryRectView *rectView;

@property (nonatomic, assign) LLConfigEntryWindowStyle style;

@property (nonatomic, assign) BOOL statusBarClickable;

@end

@implementation LLEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Primary
- (void)initial {
    self.view.backgroundColor = [UIColor clearColor];
    self.style = [LLConfig shared].entryWindowStyle;
    self.statusBarClickable = [LLTool statusBarClickable];
    
    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:doubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUIApplicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateWindowStyleNotificationNameNotification:) name:LLConfigDidUpdateWindowStyleNotificationName object:nil];
}

- (void)updateStyle:(LLConfigEntryWindowStyle)style {
    switch (style) {
        case LLConfigEntryWindowStyleSuspensionBall: {
            [_rectView removeFromSuperview];
            [self.view addSubview:self.ballView];
        }
            break;
        case LLConfigEntryWindowStyleNetBar: {
            [_ballView removeFromSuperview];
            [self.view addSubview:self.rectView];
            if (self.statusBarClickable) {
                self.rectView.LL_left = LL_IS_SPECIAL_SCREEN ? LL_LAYOUT_HORIZONTAL(25) : 0;
                self.rectView.moveableRect = CGRectNull;
            } else {
                self.rectView.LL_left = 0;
                self.rectView.moveableRect = CGRectMake(self.rectView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + self.rectView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - self.rectView.LL_height / 2.0);
            }
            
        }
            break;
        case LLConfigEntryWindowStylePowerBar: {
            [_ballView removeFromSuperview];
            [self.view addSubview:self.rectView];
            if (self.statusBarClickable) {
                self.rectView.LL_right = LL_IS_SPECIAL_SCREEN ? LL_SCREEN_WIDTH - LL_LAYOUT_HORIZONTAL(25) :  LL_SCREEN_WIDTH;
                self.rectView.moveableRect = CGRectNull;
            } else {
                self.rectView.LL_right = LL_SCREEN_WIDTH;
                self.rectView.moveableRect = CGRectMake(LL_SCREEN_WIDTH - self.rectView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + self.rectView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - self.rectView.LL_height / 2.0);
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)tapGR:(UITapGestureRecognizer *)sender {
    [[LLSettingManager shared].entryViewClickComponent componentDidLoad:nil];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
    [[LLSettingManager shared].entryViewDoubleClickComponent componentDidLoad:nil];
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
        case LLConfigEntryWindowStyleSuspensionBall:
            return self.ballView;
        case LLConfigEntryWindowStyleNetBar:
            return self.rectView;
        case LLConfigEntryWindowStylePowerBar:
            return self.rectView;
    }
}

#pragma mark - UIApplicationDidChangeStatusBarOrientationNotification
- (void)didReceiveUIApplicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [_ballView updateOrientation:orientation];
}

#pragma mark - LLConfigDidUpdateWindowStyleNotificationName
- (void)didReceiveLLConfigDidUpdateWindowStyleNotificationNameNotification:(NSNotification *)notifi {
    self.style = [LLConfig shared].entryWindowStyle;
}

#pragma mark - Lazy
- (void)setStyle:(LLConfigEntryWindowStyle)style {
    _style = style;
    [self updateStyle:style];
}

- (LLEntryBallView *)ballView {
    if (!_ballView) {
        CGFloat width = [LLConfig shared].suspensionBallWidth;
        _ballView = [[LLEntryBallView alloc] initWithFrame:CGRectMake(-[LLConfig shared].suspensionWindowHideWidth, [LLConfig shared].suspensionWindowTop, width, width)];
    }
    return _ballView;
}

- (LLEntryRectView *)rectView {
    if (!_rectView) {
        CGFloat height = LL_IS_SPECIAL_SCREEN ? 25 : 20;
        CGFloat y = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (self.statusBarClickable) {
            y = ([UIApplication sharedApplication].statusBarFrame.size.height - height) / 2.0;
        } else {
            y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
#pragma clang diagnostic pop
        _rectView = [[LLEntryRectView alloc] initWithFrame:CGRectMake(0, y, 100, height)];
    }
    return _rectView;
}

@end
