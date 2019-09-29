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
#import "LLEntryTitleView.h"
#import "LLEntryBigTitleView.h"
#import "LLTool.h"
#import "LLConst.h"
#import "LLFunctionItemModel.h"

@interface LLEntryViewController ()

@property (nonatomic, strong) LLEntryView *activeView;

@property (nonatomic, strong) LLEntryBallView *ballView;

@property (nonatomic, strong) LLEntryBigTitleView *bigTitleView;

@property (nonatomic, strong) LLEntryView *leadingView;

@property (nonatomic, strong) LLEntryView *trailingView;

@property (nonatomic, strong) LLEntryView *netView;

@property (nonatomic, strong) LLEntryView *powerView;

@property (nonatomic, assign) LLConfigEntryWindowStyle style;

@property (nonatomic, assign) BOOL statusBarClickable;

@end

@implementation LLEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarClickable = [LLTool statusBarClickable];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.style = [LLConfig shared].entryWindowStyle;
    
    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:doubleTap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateWindowStyleNotificationNameNotification:) name:LLConfigDidUpdateWindowStyleNotificationName object:nil];
}

#pragma mark - Over write
- (void)backgroundColorChanged {
    [super backgroundColorChanged];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)becomeVisable {
    [super becomeVisable];
    [self.activeView resignActive:NO];
}

#pragma mark - Primary
- (void)updateStyle:(LLConfigEntryWindowStyle)style {
    switch (style) {
        case LLConfigEntryWindowStyleBall: {
            [self.activeView removeFromSuperview];
            self.activeView = self.ballView;
            [self.view addSubview:self.ballView];
        }
            break;
        case LLConfigEntryWindowStyleTitle: {
            [self.activeView removeFromSuperview];
            self.activeView = self.bigTitleView;
            [self.view addSubview:self.bigTitleView];
        }
            break;
        case LLConfigEntryWindowStyleLeading: {
            [self.activeView removeFromSuperview];
            self.activeView = self.leadingView;
            [self.view addSubview:self.leadingView];
        }
            break;
        case LLConfigEntryWindowStyleTrailing: {
            [self.activeView removeFromSuperview];
            self.activeView = self.trailingView;
            [self.view addSubview:self.trailingView];
        }
            break;
#ifndef __IPHONE_13_0
        case LLConfigEntryWindowStyleNetBar: {
            [self.activeView removeFromSuperview];
            self.activeView = self.netView;
            [self.view addSubview:self.netView];
        }
            break;
        case LLConfigEntryWindowStylePowerBar: {
            [self.activeView removeFromSuperview];
            self.activeView = self.powerView;
            [self.view addSubview:self.powerView];
        }
            break;
#endif
    }
}

- (void)tapGR:(UITapGestureRecognizer *)sender {
    [self.activeView animatedBecomeActive];
    [[[LLFunctionItemModel alloc] initWithAction:[LLConfig shared].clickAction].component componentDidLoad:nil];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
    [self.activeView animatedBecomeActive];
    [[[LLFunctionItemModel alloc] initWithAction:[LLConfig shared].doubleClickAction].component componentDidLoad:nil];
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
        case LLConfigEntryWindowStyleBall:
            return self.ballView;
        case LLConfigEntryWindowStyleTitle:
            return self.bigTitleView;
        case LLConfigEntryWindowStyleLeading:
            return self.leadingView;
        case LLConfigEntryWindowStyleTrailing:
            return self.trailingView;
#ifndef __IPHONE_13_0
        case LLConfigEntryWindowStyleNetBar:
            return self.netView;
        case LLConfigEntryWindowStylePowerBar:
            return self.powerView;
#endif
    }
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
        CGFloat width = [LLConfig shared].entryWindowBallWidth;
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        frame.size = CGSizeMake(width, width);
        _ballView = [[LLEntryBallView alloc] initWithFrame:frame];
    }
    return _ballView;
}

- (LLEntryBigTitleView *)bigTitleView {
    if (!_bigTitleView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        frame.size = CGSizeMake(100, kLLEntryWindowBigTitleViewHeight);
        _bigTitleView = [[LLEntryBigTitleView alloc] initWithFrame:frame];
    }
    return _bigTitleView;
}

- (LLEntryView *)leadingView {
    if (!_leadingView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        frame.size = CGSizeMake(100, kLLEntryWindowBigTitleViewHeight);
        _leadingView = [[LLEntryBigTitleView alloc] initWithFrame:frame];
        _leadingView.moveableRect = CGRectMake(_leadingView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + _leadingView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - _leadingView.LL_height / 2.0);
    }
    return _leadingView;
}

- (LLEntryView *)trailingView {
    if (!_trailingView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        frame.size = CGSizeMake(100, kLLEntryWindowBigTitleViewHeight);
        _trailingView = [[LLEntryBigTitleView alloc] initWithFrame:frame];
        _trailingView.LL_right = LL_SCREEN_WIDTH;
        _trailingView.moveableRect = CGRectMake(LL_SCREEN_WIDTH - _trailingView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + _trailingView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - _trailingView.LL_height / 2.0);
    }
    return _trailingView;
}

- (LLEntryView *)netView {
    if (!_netView) {
        if (LL_IS_SPECIAL_SCREEN) {
            _netView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
            _netView.LL_y = (LL_STATUS_BAR_HEIGHT - kLLEntryWindowBigTitleViewHeight) / 2.0;
            _netView.LL_left = LL_LAYOUT_HORIZONTAL(25);
        } else {
            _netView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        }
        _netView.moveable = NO;
    }
    return _netView;
}

- (LLEntryView *)powerView {
    if (!_powerView) {
        if (LL_IS_SPECIAL_SCREEN) {
            _powerView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
            _powerView.LL_y = (LL_STATUS_BAR_HEIGHT - kLLEntryWindowBigTitleViewHeight) / 2.0;
            _powerView.LL_right = LL_SCREEN_WIDTH - LL_LAYOUT_HORIZONTAL(25);
        } else {
            _powerView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            _powerView.LL_right = LL_SCREEN_WIDTH;
        }
        _powerView.moveable = NO;
    }
    return _powerView;
}

@end
