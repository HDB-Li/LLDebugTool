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
#import "LLConfig.h"
#import "UIView+LL_Utils.h"
#import "LLMacros.h"

static LLWindowManager *_instance = nil;

@interface LLWindowManager () <LLSuspensionWindowDelegate>

@property (nonatomic, strong) LLSuspensionWindow *suspensionWindow;

@property (nonatomic, strong) LLFunctionWindow *functionWindow;

@property (nonatomic, strong) LLMagnifierWindow *magnifierWindow;

@property (nonatomic, strong) LLMagnifierInfoWindow *magnifierColorWindow;

@property (nonatomic, strong) LLNetworkWindow *networkWindow;

@property (nonatomic, strong) LLLogWindow *logWindow;

@property (nonatomic, strong) LLCrashWindow *crashWindow;

@property (nonatomic, strong) LLAppInfoWindow *appInfoWindow;

@property (nonatomic, strong) LLSandboxWindow *sandboxWindow;

@property (nonatomic, strong) LLHierarchyWindow *hierarchyWindow;

@property (nonatomic, strong) LLHierarchyPickerWindow *hierarchyPickerWindow;

@property (nonatomic, strong) LLHierarchyInfoWindow *hierarchyInfoWindow;

@property (nonatomic, assign) UIWindowLevel presentingWindowLevel;

@property (nonatomic, assign) UIWindowLevel presentWindowLevel;

@property (nonatomic, assign) UIWindowLevel normalWindowLevel;

@end

@implementation LLWindowManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLWindowManager alloc] init];
    });
    return _instance;
}

- (void)showWindow:(UIWindow *)window animated:(BOOL)animated {
    [self showWindow:window animated:animated completion:nil];
}

- (void)showWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat alpha = window.alpha;
        window.alpha = 0;
        window.hidden = NO;
        window.windowLevel = self.presentingWindowLevel;
        [UIView animateWithDuration:0.25 animations:^{
            window.alpha = alpha;
        } completion:^(BOOL finished) {
            window.windowLevel = self.presentWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated {
    [self hideWindow:window animated:animated completion:nil];
}

- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat alpha = window.alpha;
        [UIView animateWithDuration:0.25 animations:^{
            window.alpha = 0;
        } completion:^(BOOL finished) {
            window.hidden = YES;
            window.alpha = alpha;
            window.windowLevel = self.normalWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated {
    [self presentWindow:window animated:animated completion:nil];
}

- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat y = window.LL_y;
        window.LL_y = LL_SCREEN_HEIGHT;
        window.hidden = NO;
        window.windowLevel = self.presentingWindowLevel;
        [UIView animateWithDuration:0.25 animations:^{
            window.LL_y = y;
        } completion:^(BOOL finished) {
            window.windowLevel = self.presentWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated {
    [self dismissWindow:window animated:animated completion:nil];
}

- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat y = window.LL_y;
        [UIView animateWithDuration:0.25 animations:^{
            window.LL_y = LL_SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            window.hidden = YES;
            window.LL_y = y;
            window.windowLevel = self.normalWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated {
    [self pushWindow:window animated:animated completion:nil];
}

- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat x = window.LL_x;
        window.LL_x = LL_SCREEN_WIDTH;
        window.hidden = NO;
        window.windowLevel = self.presentingWindowLevel;
        [UIView animateWithDuration:0.25 animations:^{
            window.LL_x = x;
        } completion:^(BOOL finished) {
            window.windowLevel = self.presentWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)popWindow:(UIWindow *)window animated:(BOOL)animated {
    [self popWindow:window animated:animated completion:nil];
}

- (void)popWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        CGFloat x = window.LL_x;
        [UIView animateWithDuration:0.25 animations:^{
            window.LL_x = LL_SCREEN_WIDTH;
        } completion:^(BOOL finished) {
            window.hidden = YES;
            window.LL_x = x;
            window.windowLevel = self.normalWindowLevel;
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
    }
}

- (void)reloadFunctionWindow {
    _functionWindow = nil;
}

- (void)reloadMagnifierWindow {
    _magnifierWindow = nil;
}

- (void)reloadNetworkWindow {
    _networkWindow = nil;
}

- (void)reloadLogWindow {
    _logWindow = nil;
}

- (void)reloadCrashWindow {
    _crashWindow = nil;
}

- (void)reloadAppInfoWindow {
    _appInfoWindow = nil;
}

- (void)reloadSandboxWindow {
    _sandboxWindow = nil;
}

- (void)reloadHierarchyWindow {
    _hierarchyWindow = nil;
}

- (void)reloadMagnifierColorWindow {
    _magnifierColorWindow = nil;
}

- (void)reloadHierarchyPickerWindow {
    _hierarchyPickerWindow = nil;
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
        NSInteger width = [LLConfig sharedConfig].magnifierZoomLevel * [LLConfig sharedConfig].magnifierSize;
        _magnifierWindow = [[LLMagnifierWindow alloc] initWithFrame:CGRectMake((LL_SCREEN_WIDTH - width) / 2, (LL_SCREEN_HEIGHT - width) / 2, width, width)];
    }
    return _magnifierWindow;
}

- (LLMagnifierInfoWindow *)magnifierColorWindow {
    if (!_magnifierColorWindow) {
        CGFloat gap = 10;
        CGFloat height = 60;
        _magnifierColorWindow = [[LLMagnifierInfoWindow alloc] initWithFrame:CGRectMake(gap, LL_SCREEN_HEIGHT - gap * 2 - height, LL_SCREEN_WIDTH - gap * 2, height)];
    }
    return _magnifierColorWindow;
}

- (LLNetworkWindow *)networkWindow {
    if (!_networkWindow) {
        _networkWindow = [[LLNetworkWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _networkWindow;
}

- (LLLogWindow *)logWindow {
    if (!_logWindow) {
        _logWindow = [[LLLogWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _logWindow;
}

- (LLCrashWindow *)crashWindow {
    if (!_crashWindow) {
        _crashWindow = [[LLCrashWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _crashWindow;
}

- (LLAppInfoWindow *)appInfoWindow {
    if (!_appInfoWindow) {
        _appInfoWindow = [[LLAppInfoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _appInfoWindow;
}

- (LLSandboxWindow *)sandboxWindow {
    if (!_sandboxWindow) {
        _sandboxWindow = [[LLSandboxWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    }
    return _sandboxWindow;
}

- (LLHierarchyWindow *)hierarchyWindow {
    if (!_hierarchyWindow) {
        _hierarchyWindow = [[LLHierarchyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _hierarchyWindow;
}

- (LLHierarchyPickerWindow *)hierarchyPickerWindow {
    if (!_hierarchyPickerWindow) {
        _hierarchyPickerWindow = [[LLHierarchyPickerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _hierarchyPickerWindow;
}

- (LLHierarchyInfoWindow *)hierarchyInfoWindow {
    if (!_hierarchyInfoWindow) {
        CGFloat gap = 10;
        CGFloat height = 60;
        _hierarchyInfoWindow = [[LLHierarchyInfoWindow alloc] initWithFrame:CGRectMake(gap, LL_SCREEN_HEIGHT - gap * 2 - height, LL_SCREEN_WIDTH - gap * 2, height)];
    }
    return _hierarchyInfoWindow;
}

- (UIWindowLevel)presentingWindowLevel {
    if (!_presentingWindowLevel) {
        _presentingWindowLevel = UIWindowLevelStatusBar - 100;
    }
    return _presentingWindowLevel;
}

- (UIWindowLevel)presentWindowLevel {
    if (!_presentWindowLevel) {
        _presentWindowLevel = UIWindowLevelStatusBar - 200;
    }
    return _presentWindowLevel;
}

- (UIWindowLevel)normalWindowLevel {
    if (!_normalWindowLevel) {
        _normalWindowLevel = UIWindowLevelStatusBar - 300;
    }
    return _normalWindowLevel;
}

#pragma mark - LLSuspensionWindowDelegate
- (void)llSuspensionWindow:(LLSuspensionWindow *)window didTapAt:(NSInteger)numberOfTap {
    switch (numberOfTap) {
        case 1:
            [[LLWindowManager shared] presentWindow:[LLWindowManager shared].functionWindow animated:YES completion:^{
                [[LLWindowManager shared] hideWindow:[LLWindowManager shared].suspensionWindow animated:NO];
            }];
            break;
        case 2:
            [[LLWindowManager shared] showWindow:[LLWindowManager shared].magnifierWindow animated:NO];
            break;
        default:
            break;
    }
}

@end
