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
#import "LLConst.h"

static LLWindowManager *_instance = nil;

@interface LLWindowManager ()

@property (nonatomic, strong) LLEntryWindow *entryWindow;

@property (nonatomic, assign) UIWindowLevel presentingWindowLevel;

@property (nonatomic, assign) UIWindowLevel presentWindowLevel;

@property (nonatomic, assign) UIWindowLevel normalWindowLevel;

@property (nonatomic, strong) NSMutableArray *visibleWindows;

@end

@implementation LLWindowManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLWindowManager alloc] init];
    });
    return _instance;
}

+ (LLFunctionWindow *)functionWindow {
    return [[LLFunctionWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLMagnifierWindow *)magnifierWindow {
    return [[LLMagnifierWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLNetworkWindow *)networkWindow {
    return [[LLNetworkWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLLogWindow *)logWindow {
    return [[LLLogWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLCrashWindow *)crashWindow {
    return [[LLCrashWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLAppInfoWindow *)appInfoWindow {
    return [[LLAppInfoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLSandboxWindow *)sandboxWindow {
    return [[LLSandboxWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLHierarchyWindow *)hierarchyWindow {
    return [[LLHierarchyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLHierarchyPickerWindow *)hierarchyPickerWindow {
    return [[LLHierarchyPickerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLHierarchyDetailWindow *)hierarchyDetailWindow {
    return [[LLHierarchyDetailWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (LLScreenshotWindow *)screenshotWindow {
    return [[LLScreenshotWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)showEntryWindow {
    [self showWindow:self.entryWindow animated:YES];
}

- (void)hideEntryWindow {
    [self hideWindow:self.entryWindow animated:YES];
}

- (void)showWindow:(UIWindow *)window animated:(BOOL)animated {
    [self showWindow:window animated:animated completion:nil];
}

- (void)showWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows addObject:window];
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows addObject:window];
    }
}

- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated {
    [self hideWindow:window animated:animated completion:nil];
}

- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows removeObject:window];
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows removeObject:window];
    }
}

- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated {
    [self presentWindow:window animated:animated completion:nil];
}

- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows addObject:window];
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows addObject:window];
    }
}

- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated {
    [self dismissWindow:window animated:animated completion:nil];
}

- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows removeObject:window];
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows removeObject:window];
    }
}

- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated {
    [self pushWindow:window animated:animated completion:nil];
}

- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows addObject:window];
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows addObject:window];
    }
}

- (void)popWindow:(UIWindow *)window animated:(BOOL)animated {
    [self popWindow:window animated:animated completion:nil];
}

- (void)popWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
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
            [self.visibleWindows removeObject:window];
        }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        if (completion) {
            completion();
        }
        [self.visibleWindows removeObject:window];
    }
}

- (void)removeVisibleWindow:(UIWindow *)window {
    [self.visibleWindows removeObject:window];
}

- (void)removeAllVisibleWindows {
    for (LLBaseWindow *window in self.visibleWindows) {
        [self removeWindow:window animated:YES animateStyle:window.animateStyle];
    }
    [self.visibleWindows removeAllObjects];
}

- (void)removeWindow:(UIWindow *)window animated:(BOOL)animated animateStyle:(LLBaseWindowAnimateStyle)animateStyle {
    switch (animateStyle) {
        case LLBaseWindowAnimateStyleFadeInFadeOut:{
            [self hideWindow:window animated:animated];
        }
            break;
        case LLBaseWindowAnimateStylePushInPopOut: {
            [self popWindow:window animated:animated];
        }
            break;
        case LLBaseWindowAnimateStylePresentInDismissOut:{
            [self dismissWindow:window animated:animated];
        }
        default:{
            NSAssert(NO, @"Must code animate style to remove window");
        }
            break;
    }
}

#pragma mark - Lazy
- (LLEntryWindow *)entryWindow {
    if (!_entryWindow) {
        _entryWindow = [[LLEntryWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _entryWindow;
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

- (NSMutableArray *)visibleWindows {
    if (!_visibleWindows) {
        _visibleWindows = [[NSMutableArray alloc] init];
    }
    return _visibleWindows;
}

@end
