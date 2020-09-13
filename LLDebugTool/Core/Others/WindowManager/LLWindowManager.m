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

#import "LLComponentHandle.h"
#import "LLComponentWindow.h"
#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"

static LLWindowManager *_instance = nil;

@interface LLWindowManager ()

@property (nonatomic, assign) UIWindowLevel presentWindowLevel;

@property (nonatomic, assign) UIWindowLevel normalWindowLevel;

@property (nonatomic, assign) UIWindowLevel entryWindowLevel;

@property (nonatomic, strong) NSMutableArray *visibleWindows;

@property (nonatomic, strong) UIWindow *keyWindow;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation LLWindowManager

#pragma mark - Public
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLWindowManager alloc] init];
    });
    return _instance;
}

- (void)showWindow:(LLComponentWindow *)window animated:(BOOL)animated {
    [self showWindow:window animated:animated completion:nil];
}

- (void)showWindow:(LLComponentWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    [self addWindow:window animated:animated completion:completion];
}

- (void)hideWindow:(LLComponentWindow *)window animated:(BOOL)animated {
    [self hideWindow:window animated:animated completion:nil];
}

- (void)hideWindow:(LLComponentWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    [self removeWindow:window animated:animated showEntry:YES completion:nil];
}

- (LLComponentWindow *)visibleWindow {
    return [self.visibleWindows lastObject];
}

- (void)removeAllVisibleWindows {
    for (LLComponentWindow *window in self.visibleWindows) {
        [self removeWindow:window animated:YES showEntry:NO completion:nil];
    }
    [self.visibleWindows removeAllObjects];
}

#pragma mark - Primary
- (instancetype)init {
    if (self = [super init]) {
        self.visibleWindows = [[NSMutableArray alloc] init];
        _presentWindowLevel = UIWindowLevelStatusBar - 200;
        _normalWindowLevel = UIWindowLevelStatusBar - 300;
        _entryWindowLevel = UIWindowLevelStatusBar + 1;
    }
    return self;
}

- (void)addWindow:(LLComponentWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    // Avoid call on child thread.
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self addWindow:window animated:animated completion:completion];
        });
        return;
    }

    if (!window) {
        if (completion) {
            completion();
        }
        return;
    }
    [self removeAllVisibleWindows];

    [self recordKeywindowAndStatusBar:window animated:animated];

    [self.visibleWindows addObject:window];

    [self performAddWindow:window animated:animated completion:completion];
}

- (void)recordKeywindowAndStatusBar:(UIWindow *)window animated:(BOOL)animated {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([window isKindOfClass:NSClassFromString(@"LLEnryWindow")]) {
        if (self.keyWindow) {
            [self.keyWindow makeKeyWindow];
            self.keyWindow = nil;
            [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
        }
        window.hidden = NO;
        window.windowLevel = self.entryWindowLevel;
    } else {
        UIWindow *keyWindow = [LLTool keyWindow];
        if (![keyWindow isKindOfClass:[LLComponentWindow class]]) {
            self.keyWindow = keyWindow;
            self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
            [[UIApplication sharedApplication] setStatusBarStyle:[LLThemeManager shared].statusBarStyle animated:animated];
        }
        [window makeKeyAndVisible];
        window.windowLevel = self.presentWindowLevel;
    }
#pragma clang diagnostic pop
}

- (void)performAddWindow:(LLComponentWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        __block CGFloat alpha = window.alpha;
        __block CGFloat x = window.LL_x;
        __block CGFloat y = window.LL_y;

        switch (window.showAnimateStyle) {
            case LLBaseWindowShowAnimateStyleFade: {
                window.alpha = 0;
            } break;
            case LLBaseWindowShowAnimateStylePresent: {
                window.LL_y = LL_SCREEN_HEIGHT;
            } break;
            case LLBaseWindowShowAnimateStylePush: {
                window.LL_x = LL_SCREEN_WIDTH;
            } break;
        }

        [UIView animateWithDuration:0.25
            animations:^{
                window.alpha = alpha;
                window.LL_x = x;
                window.LL_y = y;
            }
            completion:^(BOOL finished) {
                [window windowDidShow];
                if (completion) {
                    completion();
                }
            }];
    } else {
        [window windowDidShow];
        if (completion) {
            completion();
        }
    }
}

- (void)removeWindow:(LLComponentWindow *)window animated:(BOOL)animated showEntry:(BOOL)showEntry completion:(void (^)(void))completion {
    // Avoid call on child thread.
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self removeWindow:window animated:animated showEntry:showEntry completion:completion];
        });
        return;
    }

    if (!window) {
        if (completion) {
            completion();
        }
        return;
    }

    [self removeVisibleWindow:window showEntry:showEntry];

    [self performRemoveWindow:window animated:animated completion:completion];
}

- (void)performRemoveWindow:(LLComponentWindow *)window animated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        __block CGFloat alpha = window.alpha;
        __block CGFloat x = window.LL_x;
        __block CGFloat y = window.LL_y;
        [UIView animateWithDuration:0.25
            animations:^{
                switch (window.hideAnimateStyle) {
                    case LLBaseWindowHideAnimateStyleFade: {
                        window.alpha = 0;
                    } break;
                    case LLBaseWindowHideAnimateStyleDismiss: {
                        window.LL_y = LL_SCREEN_HEIGHT;
                    } break;
                    case LLBaseWindowHideAnimateStylePop: {
                        window.LL_x = LL_SCREEN_WIDTH;
                    } break;
                }
            }
            completion:^(BOOL finished) {
                window.hidden = YES;
                window.alpha = alpha;
                window.LL_x = x;
                window.LL_y = y;
                window.windowLevel = self.normalWindowLevel;
                [window windowDidHide];
                if (completion) {
                    completion();
                }
            }];
    } else {
        window.hidden = YES;
        window.windowLevel = self.normalWindowLevel;
        [window windowDidHide];
        if (completion) {
            completion();
        }
    }
}

- (void)removeVisibleWindow:(LLComponentWindow *)window showEntry:(BOOL)showEntry {
    [self.visibleWindows removeObject:window];
    if (showEntry) {
        if (self.visibleWindows.count == 0) {
            [LLComponentHandle executeAction:LLDebugToolActionEntry data:nil];
        }
    }
}

@end

#pragma mark - Internal

@implementation LLWindowManager (Internal)

+ (LLComponentWindow *)createWindowWithClassName:(NSString *)className action:(LLDebugToolAction)action {
    Class cls = NSClassFromString(className);
    NSAssert(cls, ([NSString stringWithFormat:@"%@ can't register a class.", className]));
    __block LLComponentWindow *window = nil;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            window = [[cls alloc] initWithFrame:[UIScreen mainScreen].bounds];
        });
    } else {
        window = [[cls alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    window.action = action;
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        window.windowScene = [LLTool delegateWindow].windowScene;
    }
#endif
    NSAssert([window isKindOfClass:[LLComponentWindow class]], ([NSString stringWithFormat:@"%@ isn't a LLComponentWindow class", className]));
    return window;
}

@end
