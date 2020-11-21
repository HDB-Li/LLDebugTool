//
//  LLTool.m
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

#import "LLTool.h"

#import <pthread/pthread.h>

#import "LLDebugConfig.h"
#import "LLDebugTool.h"
#import "LLFormatterTool.h"
#import "LLInternalMacros.h"
#import "LLLogDefine.h"

#import "NSUserDefaults+LL_Utils.h"

static unsigned long long _absolutelyIdentity = 0;

static pthread_mutex_t mutex_t = PTHREAD_MUTEX_INITIALIZER;

@implementation LLTool

#pragma mark - Class Method
+ (NSString *)absolutelyIdentity {
    unsigned long long identity = 0;
    pthread_mutex_lock(&mutex_t);
    identity = _absolutelyIdentity++;
    pthread_mutex_unlock(&mutex_t);
    return [NSString stringWithFormat:@"%lld", identity];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    if (!path) {
        return YES;
    }
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExist && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    if (!isExist || !isDirectory) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [self log:[NSString stringWithFormat:@"Create folder fail, path = %@, error = %@", path, error.description]];
            LL_ASSERT(error.description);
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (BOOL)removePath:(NSString *)path {
    if (!path) {
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            return YES;
        }
        [self log:[NSString stringWithFormat:@"Remove file failed, [%@]: %@", path, error.localizedDescription]];
        return NO;
    }
    return YES;
}

+ (CGRect)rectWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint {
    CGFloat x = LL_MIN(point.x, otherPoint.x);
    CGFloat y = LL_MIN(point.y, otherPoint.y);
    CGFloat maxX = LL_MAX(point.x, otherPoint.x);
    CGFloat maxY = LL_MAX(point.y, otherPoint.y);
    CGFloat width = maxX - x;
    CGFloat height = maxY - y;
    // Return rect nearby
    CGFloat gap = 1 / 2.0;
    if (width == 0) {
        width = gap;
    }
    if (height == 0) {
        height = gap;
    }
    return CGRectMake(x, y, width, height);
}

+ (NSString *)stringFromFrame:(CGRect)frame {
    return [NSString stringWithFormat:@"{{%@, %@}, {%@, %@}}", [LLFormatterTool formatNumber:@(frame.origin.x)], [LLFormatterTool formatNumber:@(frame.origin.y)], [LLFormatterTool formatNumber:@(frame.size.width)], [LLFormatterTool formatNumber:@(frame.size.height)]];
}

+ (UIWindow *)topWindow {
    UIWindow *topWindow = [self delegateWindow];
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (!win.isHidden && win.alpha > 0 && win.windowLevel > topWindow.windowLevel) {
            topWindow = win;
        }
    }
    return topWindow;
}

+ (UIWindow *)keyWindow {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
}

+ (UIWindow *)delegateWindow {
    __block UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
            window = [UIApplication sharedApplication].delegate.window;
        }
        if (!window) {
            [[UIApplication sharedApplication]
                    .connectedScenes enumerateObjectsUsingBlock:^(UIScene *_Nonnull obj, BOOL *_Nonnull stop) {
                if ([obj.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]) {
                    id<UIWindowSceneDelegate> delegate = (id<UIWindowSceneDelegate>)obj.delegate;
                    if ([delegate respondsToSelector:@selector(window)]) {
                        window = delegate.window;
                        if (window) {
                            *stop = YES;
                        }
                    }
                }
            }];
        }
    } else {
        window = [UIApplication sharedApplication].delegate.window;
    }
    return window;
}

+ (void)log:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([LLDebugConfig shared].isShowDebugToolLog) {
            NSLog(@"%@,%@", string, kLLDebugToolLogOpenIssueInGithub);
        }
    });
}

+ (void)log:(NSString *)string synchronous:(BOOL)synchronous withPrompt:(BOOL)prompt {
    if (synchronous) {
        if ([LLDebugConfig shared].isShowDebugToolLog) {
            NSLog(@"%@,%@", string, prompt ? kLLDebugToolLogOpenIssueInGithub : @"");
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([LLDebugConfig shared].isShowDebugToolLog) {
                NSLog(@"%@,%@", string, prompt ? kLLDebugToolLogOpenIssueInGithub : @"");
            }
        });
    }
}

static bool _statusBarClickable = YES;
+ (BOOL)statusBarClickable {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            _statusBarClickable = NO;
        }
    });
    return _statusBarClickable;
}

+ (UIView *)getUIStatusBarModern {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        // We can still get statusBar using the following code, but this is not recommended.
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].delegate.window.windowScene.statusBarManager;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                return [_localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
    }
#endif
    return [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
}

+ (void)availableDebugTool {
    [LLDebugTool sharedTool];
}

+ (void)startWorking {
    [[LLDebugTool sharedTool] startWorking];
}

@end

@implementation LLTool (NSUserDefault)

+ (BOOL)startWorkingAfterApplicationDidFinishLaunching {
    return [NSUserDefaults LL_boolForKey:@"startWorkingAfterApplicationDidFinishLaunching"];
}

+ (void)setStartWorkingAfterApplicationDidFinishLaunching:(BOOL)isStart {
    [NSUserDefaults LL_setBool:isStart forKey:@"startWorkingAfterApplicationDidFinishLaunching"];
}

@end
