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

#import "LLComponent.h"
#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLEntryAppInfoView.h"
#import "LLEntryBallView.h"
#import "LLEntryBigTitleView.h"
#import "LLEntryTitleView.h"
#import "LLFunctionItemModel.h"
#import "LLInternalMacros.h"
#import "LLSettingManager.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"

@interface LLEntryViewController ()

@property (nonatomic, strong) LLEntryView *activeView;

@property (nonatomic, strong) LLEntryBallView *ballView;

@property (nonatomic, strong) LLEntryBigTitleView *bigTitleView;

@property (nonatomic, strong) LLEntryAppInfoView *appInfoView;

@property (nonatomic, strong) LLEntryView *netView;

@property (nonatomic, strong) LLEntryView *powerView;

@property (nonatomic, assign) LLDebugConfigEntryWindowStyle style;

@end

@implementation LLEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.updateBackgroundColor = NO;
    self.style = [LLDebugConfig shared].entryWindowStyle;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolUpdateWindowStyleNotification:) name:LLDebugToolUpdateWindowStyleNotification object:nil];
}

#pragma mark - Primary
- (void)updateStyle:(LLDebugConfigEntryWindowStyle)style {
    [self.activeView removeFromSuperview];
    switch (style) {
        case LLDebugConfigEntryWindowStyleBall: {
            self.activeView = self.ballView;
        } break;
        case LLDebugConfigEntryWindowStyleTitle: {
            self.activeView = self.bigTitleView;
        } break;
        case LLDebugConfigEntryWindowStyleAppInfo: {
            self.activeView = self.appInfoView;
        } break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLDebugConfigEntryWindowStyleNetBar: {
            self.activeView = self.netView;
        } break;
        case LLDebugConfigEntryWindowStylePowerBar: {
            self.activeView = self.powerView;
        } break;
#pragma clang diagnostic pop
    }
    [self.view addSubview:self.activeView];
    [self.delegate LLEntryViewController:self style:self.activeView.styleModel];
}

- (UIView *)activeEntryView {
    switch (self.style) {
        case LLDebugConfigEntryWindowStyleBall:
            return self.ballView;
        case LLDebugConfigEntryWindowStyleTitle:
            return self.bigTitleView;
        case LLDebugConfigEntryWindowStyleAppInfo:
            return self.appInfoView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLDebugConfigEntryWindowStyleNetBar:
            return self.netView;
        case LLDebugConfigEntryWindowStylePowerBar:
            return self.powerView;
#pragma clang diagnostic pop
    }
}

#pragma mark - LLDebugToolUpdateWindowStyleNotification
- (void)didReceiveDebugToolUpdateWindowStyleNotification:(NSNotification *)notification {
    self.style = [LLDebugConfig shared].entryWindowStyle;
}

#pragma mark - Lazy
- (void)setStyle:(LLDebugConfigEntryWindowStyle)style {
    _style = style;
    [self updateStyle:style];
}

- (LLEntryBallView *)ballView {
    if (!_ballView) {
        CGFloat width = [LLDebugConfig shared].entryWindowBallWidth;
        CGRect frame = CGRectZero;
        frame.origin = [LLDebugConfig shared].entryWindowFirstDisplayPosition;
        frame.size = CGSizeMake(width, width);
        _ballView = [[LLEntryBallView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _ballView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLDebugConfigEntryWindowStyleBall moveableRect:CGRectNull frame:frame];
    }
    return _ballView;
}

- (LLEntryBigTitleView *)bigTitleView {
    if (!_bigTitleView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLDebugConfig shared].entryWindowFirstDisplayPosition;
        _bigTitleView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectZero];
        frame.size = _bigTitleView.LL_size;
        _bigTitleView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLDebugConfigEntryWindowStyleTitle moveableRect:CGRectNull frame:frame];
    }
    return _bigTitleView;
}

- (LLEntryAppInfoView *)appInfoView {
    if (!_appInfoView) {
        CGRect frame = CGRectZero;
        frame.origin = [LLDebugConfig shared].entryWindowFirstDisplayPosition;
        _appInfoView = [[LLEntryAppInfoView alloc] initWithFrame:CGRectZero];
        frame.size = _appInfoView.LL_size;
        _appInfoView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLDebugConfigEntryWindowStyleAppInfo moveableRect:CGRectNull frame:frame];
    }
    return _appInfoView;
}

- (LLEntryView *)netView {
    if (!_netView) {
        CGRect frame = CGRectZero;
        if (LL_IS_SPECIAL_SCREEN) {
            _netView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectZero];
            frame = CGRectMake(LL_LAYOUT_HORIZONTAL(25), (LL_STATUS_BAR_HEIGHT - _netView.LL_height) / 2.0, _netView.LL_width, _netView.LL_height);
        } else {
            _netView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            frame = CGRectMake(0, 0, _netView.LL_width, _netView.LL_height);
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _netView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLDebugConfigEntryWindowStyleNetBar moveableRect:CGRectNull frame:frame];
#pragma clang diagnostic pop
    }
    return _netView;
}

- (LLEntryView *)powerView {
    if (!_powerView) {
        CGRect frame = CGRectZero;
        if (LL_IS_SPECIAL_SCREEN) {
            _powerView = [[LLEntryBigTitleView alloc] initWithFrame:CGRectZero];
            frame = CGRectMake(LL_SCREEN_WIDTH - LL_LAYOUT_HORIZONTAL(25) - _powerView.LL_width, (LL_STATUS_BAR_HEIGHT - _powerView.LL_height) / 2.0, _powerView.LL_width, _powerView.LL_height);
        } else {
            _powerView = [[LLEntryTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            frame = CGRectMake(LL_SCREEN_WIDTH - _powerView.LL_width, 0, _powerView.LL_width, _powerView.LL_height);
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _powerView.styleModel = [[LLEntryStyleModel alloc] initWithWindowStyle:LLDebugConfigEntryWindowStylePowerBar moveableRect:CGRectNull frame:frame];
#pragma clang diagnostic pop
    }
    return _powerView;
}

@end
