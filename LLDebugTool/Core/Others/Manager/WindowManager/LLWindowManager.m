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

@property (nonatomic, strong) UIWindow *keyWindow;

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
    [self addWindow:self.entryWindow animated:YES completion:nil];
}

- (void)hideEntryWindow {
    [self removeWindow:self.entryWindow animated:YES automaticallyShowEntry:NO completion:nil];
}

- (void)showWindow:(LLBaseWindow *)window animated:(BOOL)animated {
    [self showWindow:window animated:animated completion:nil];
}

- (void)showWindow:(LLBaseWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [self addWindow:window animated:animated completion:completion];
}

- (void)hideWindow:(LLBaseWindow *)window animated:(BOOL)animated {
    [self hideWindow:window animated:animated completion:nil];
}

- (void)hideWindow:(LLBaseWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    [self removeWindow:window animated:animated automaticallyShowEntry:YES completion:nil];
}

#pragma mark - Primary
- (void)addWindow:(LLBaseWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
    [self removeAllVisibleWindows];
    
    if (window == self.entryWindow) {
        [self.keyWindow makeKeyWindow];
    } else {
        if (![[UIApplication sharedApplication].keyWindow isKindOfClass:[LLBaseWindow class]]) {
            self.keyWindow = [UIApplication sharedApplication].keyWindow;
        }
    }
    
    [self.visibleWindows addObject:window];
    if (animated) {
        __block CGFloat alpha = window.alpha;
        __block CGFloat x = window.LL_x;
        __block CGFloat y = window.LL_y;
        
        switch (window.showAnimateStyle) {
            case LLBaseWindowShowAnimateStyleFade:{
                window.alpha = 0;
            }
                break;
            case LLBaseWindowShowAnimateStylePresent:{
                window.LL_y = LL_SCREEN_HEIGHT;
            }
                break;
            case LLBaseWindowShowAnimateStylePush:{
                window.LL_x = LL_SCREEN_WIDTH;
            }
                break;
        }
        window.hidden = NO;
        window.windowLevel = self.presentingWindowLevel;
        [UIView animateWithDuration:0.25 animations:^{
            window.alpha = alpha;
            window.LL_x = x;
            window.LL_y = y;
        } completion:^(BOOL finished) {
            window.windowLevel = self.presentWindowLevel;
            if (window != self.entryWindow) {
                [window makeKeyWindow];
            }
            if (completion) {
                completion();
            }
        }];
    } else {
        window.hidden = NO;
        window.windowLevel = self.presentWindowLevel;
        if (window != self.entryWindow) {
            [window makeKeyWindow];
        }
        if (completion) {
            completion();
        }
    }
}

- (void)removeWindow:(LLBaseWindow *)window animated:(BOOL)animated automaticallyShowEntry:(BOOL)automaticallyShowEntry completion:(void (^)(void))completion {
    if (!window) {
        return;
    }
    
    [self removeVisibleWindow:window automaticallyShowEntry:automaticallyShowEntry];
    
    if (animated) {
        __block CGFloat alpha = window.alpha;
        __block CGFloat x = window.LL_x;
        __block CGFloat y = window.LL_y;
        [UIView animateWithDuration:0.25 animations:^{
            switch (window.hideAnimateStyle) {
                case LLBaseWindowHideAnimateStyleFade: {
                    window.alpha = 0;
                }
                    break;
                case LLBaseWindowHideAnimateStyleDismiss:{
                    window.LL_y = LL_SCREEN_HEIGHT;
                }
                    break;
                case LLBaseWindowHideAnimateStylePop: {
                    window.LL_x = LL_SCREEN_WIDTH;
                }
                    break;
                default:
                    break;
            }
        } completion:^(BOOL finished) {
            window.hidden = YES;
            window.alpha = alpha;
            window.LL_x = x;
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

- (void)removeAllVisibleWindows {
    for (LLBaseWindow *window in self.visibleWindows) {
        [self removeWindow:window animated:YES automaticallyShowEntry:NO completion:nil];
    }
    [self.visibleWindows removeAllObjects];
}

- (void)removeVisibleWindow:(LLBaseWindow *)window automaticallyShowEntry:(BOOL)automaticallyShowEntry {
    [self.visibleWindows removeObject:window];
    if (automaticallyShowEntry) {
        if (self.visibleWindows.count == 0) {
            [self showEntryWindow];
        }
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
