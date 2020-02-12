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

#import "LLEntryBigTitleView.h"
#import "LLFunctionItemModel.h"
#import "LLInternalMacros.h"
#import "LLSettingManager.h"
#import "LLEntryTitleView.h"
#import "LLEntryBallView.h"
#import "LLComponent.h"
#import "LLConfig.h"
#import "LLConst.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"

@interface LLEntryViewController ()

@property (nonatomic, strong) LLEntryView *activeView;

@property (nonatomic, strong) LLEntryBallView *ballView;

@property (nonatomic, strong) LLEntryBigTitleView *bigTitleView;

@property (nonatomic, strong) LLEntryView *leadingView;

@property (nonatomic, strong) LLEntryView *trailingView;

@property (nonatomic, strong) LLEntryView *netView;

@property (nonatomic, strong) LLEntryView *powerView;

@property (nonatomic, assign) LLConfigEntryWindowStyle style;

@end

@implementation LLEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.updateBackgroundColor = NO;
    self.style = [LLConfig shared].entryWindowStyle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateWindowStyleNotificationNameNotification:) name:LLConfigDidUpdateWindowStyleNotificationName object:nil];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
#pragma clang diagnostic pop
    }
    [self.delegate LLEntryViewController:self style:self.activeView.styleModel];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLConfigEntryWindowStyleNetBar:
            return self.netView;
        case LLConfigEntryWindowStylePowerBar:
            return self.powerView;
#pragma clang diagnostic pop
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
        _ballView = [[LLEntryBallView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _ballView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStyleBall moveableRect:CGRectNull frame:frame];
    }
    return _ballView;
}

- (LLEntryBigTitleView *)bigTitleView {
    if (!_bigTitleView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        _bigTitleView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
        frame.size = _bigTitleView.LL_size;
        _bigTitleView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStyleTitle moveableRect:CGRectNull frame:frame];
    }
    return _bigTitleView;
}

- (LLEntryView *)leadingView {
    if (!_leadingView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        _leadingView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
        frame.size = _leadingView.LL_size;
        _leadingView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStyleLeading moveableRect:CGRectMake(_leadingView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + _leadingView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - _leadingView.LL_height / 2.0) frame:frame];
    }
    return _leadingView;
}

- (LLEntryView *)trailingView {
    if (!_trailingView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLConfig shared].entryWindowFirstDisplayPosition;
        _trailingView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
        frame.size = _trailingView.LL_size;
        frame.origin.x = LL_SCREEN_WIDTH - frame.size.width;
        _trailingView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStyleTrailing moveableRect:CGRectMake(LL_SCREEN_WIDTH - _trailingView.LL_width / 2.0, LL_STATUS_BAR_HEIGHT + _trailingView.LL_height / 2.0, 0, LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - LL_STATUS_BAR_HEIGHT - _trailingView.LL_height / 2.0) frame:frame];
    }
    return _trailingView;
}

- (LLEntryView *)netView {
    if (!_netView) {
        CGRect frame = CGRectZero;
        if (LL_IS_SPECIAL_SCREEN) {
            _netView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
            frame = CGRectMake(LL_LAYOUT_HORIZONTAL(25), (LL_STATUS_BAR_HEIGHT - kLLEntryWindowBigTitleViewHeight) / 2.0, _netView.LL_width, _netView.LL_height);
        } else {
            _netView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            frame = CGRectMake(0, 0, _netView.LL_width, _netView.LL_height);
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _netView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStyleNetBar moveableRect:CGRectNull frame:frame];
#pragma clang diagnostic pop
    }
    return _netView;
}

- (LLEntryView *)powerView {
    if (!_powerView) {
        CGRect frame = CGRectZero;
        if (LL_IS_SPECIAL_SCREEN) {
            _powerView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, kLLEntryWindowBigTitleViewHeight)];
            frame.size = _powerView.LL_size;
            frame.origin = CGPointMake(LL_SCREEN_WIDTH - LL_LAYOUT_HORIZONTAL(25) - frame.size.width, (LL_STATUS_BAR_HEIGHT - kLLEntryWindowBigTitleViewHeight) / 2.0);
        } else {
            _powerView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            frame.size = _powerView.LL_size;
            frame.origin.x = LL_SCREEN_WIDTH - frame.size.width;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _powerView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLConfigEntryWindowStylePowerBar moveableRect:CGRectNull frame:frame];
#pragma clang diagnostic pop
    }
    return _powerView;
}

@end
