//
//  LLWindowManager.m
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

#import "LLWindowManager.h"
#import "LLSuspensionWindow.h"
#import "LLFunctionWindow.h"
#import "LLMagnifierWindow.h"
#import "LLConfig.h"
#import "UIView+LL_Utils.h"
#import "LLMacros.h"

static LLWindowManager *_instance = nil;

@interface LLWindowManager () <LLSuspensionWindowDelegate>

@property (nonatomic, strong) LLSuspensionWindow *suspensionWindow;

@property (nonatomic, strong) LLFunctionWindow *functionWindow;

@property (nonatomic, strong) LLMagnifierWindow *magnifierWindow;

@end

@implementation LLWindowManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLWindowManager alloc] init];
    });
    return _instance;
}

- (void)showSuspensionWindow:(BOOL)animated {
    if (animated) {
        self.suspensionWindow.alpha = 0;
        self.suspensionWindow.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.suspensionWindow.alpha = 1;
        } completion:nil];
    } else {
        self.suspensionWindow.hidden = NO;
    }
}

- (void)hideSuspensionWindow:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.suspensionWindow.alpha = 0;
        } completion:^(BOOL finished) {
            self.suspensionWindow.hidden = YES;
            self.suspensionWindow.alpha = 1;
        }];
    } else {
        self.suspensionWindow.hidden = YES;
    }
}

- (void)showFunctionWindow:(BOOL)animated {
    if (animated) {
        self.functionWindow.LL_y = LL_SCREEN_HEIGHT;
        self.functionWindow.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.functionWindow.LL_y = 0;
        } completion:nil];
    } else {
        self.functionWindow.hidden = NO;
    }
}

- (void)hideFunctionWindow:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.functionWindow.LL_y = LL_SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            self.functionWindow.hidden = YES;
            self.functionWindow.LL_y = 0;
        }];
    } else {
        self.functionWindow.hidden = YES;
    }
}

- (void)showMagnifierWindow:(BOOL)animated {
    if (animated) {
        self.magnifierWindow.alpha = 0;
        self.magnifierWindow.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.magnifierWindow.alpha = 1;
        } completion:nil];
    } else {
        self.magnifierWindow.hidden = NO;
    }
}

- (void)hideMagnifierWindow:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.magnifierWindow.alpha = 0;
        } completion:^(BOOL finished) {
            self.magnifierWindow.hidden = YES;
            self.magnifierWindow.alpha = 1;
        }];
    } else {
        self.magnifierWindow.hidden = YES;
    }
}

#pragma mark - Lazy
- (LLSuspensionWindow *)suspensionWindow {
    if (!_suspensionWindow) {
        _suspensionWindow = [[LLSuspensionWindow alloc] initWithFrame:CGRectMake(-[LLConfig sharedConfig].suspensionWindowHideWidth, [LLConfig sharedConfig].suspensionWindowTop, [LLConfig sharedConfig].suspensionBallWidth, [LLConfig sharedConfig].suspensionBallWidth)];
        _suspensionWindow.delegate = self;
    }
    return _suspensionWindow;
}

- (LLFunctionWindow *)functionWindow {
    if (!_functionWindow) {
        _functionWindow = [[LLFunctionWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _functionWindow;
}

- (LLMagnifierWindow *)magnifierWindow {
    if (!_magnifierWindow) {
        CGFloat width = ceil([LLConfig sharedConfig].magnifierZoomLevel * [LLConfig sharedConfig].magnifierSize);
        _magnifierWindow = [[LLMagnifierWindow alloc] initWithFrame:CGRectMake((LL_SCREEN_WIDTH - width) / 2, (LL_SCREEN_HEIGHT - width) / 2, width, width)];
    }
    return _magnifierWindow;
}

#pragma mark - LLSuspensionWindowDelegate
- (void)llSuspensionWindow:(LLSuspensionWindow *)window didTapAt:(NSInteger)numberOfTap {
    switch (numberOfTap) {
        case 1:
            [self hideSuspensionWindow:YES];
            [self showFunctionWindow:YES];
            break;
        case 2:
            [self showMagnifierWindow:YES];
            break;
        default:
            break;
    }
}

@end
