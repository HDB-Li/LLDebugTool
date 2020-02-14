//
//  LLRouter.m
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

#import "LLRouter.h"

@implementation LLRouter

#pragma mark - Public
+ (void)setCrashHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self crashHelper]];
}

+ (void)setLogHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self logHelper]];
}

+ (void)setNetworkHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self networkHelper]];
}

+ (void)setAppInfoHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self appInfoHelper]];
}

+ (void)setScreenshotHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self screenshotHelper]];
}

+ (void)setLocationHelperEnable:(BOOL)isEnable {
    [self setEnable:isEnable className:[self locationHelper]];
}

#pragma mark - Primary
+ (void)setEnable:(BOOL)isEnable className:(NSString *)className {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selector = @selector(setEnable:);
#pragma clang diagnostic pop
    id sharedInstance = [self sharedWithClassName:className];
    if (!sharedInstance) {
        return;
    }
    NSAssert([sharedInstance respondsToSelector:selector], @"Invoke %@ Failed.", NSStringFromSelector(selector));
    NSMethodSignature *signature = [sharedInstance methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:sharedInstance];
    [invocation setSelector:selector];
    [invocation setArgument:&isEnable atIndex:2];
    [invocation invoke];
}

+ (id _Nullable)sharedWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    if (!cls) {
        return nil;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSAssert([cls respondsToSelector:@selector(shared)], @"Get shared instance failed.");
    return [cls performSelector:@selector(shared)];
#pragma clang diagnostic pop
}

#pragma mark Getters
/// CrashHelper class name.
+ (NSString *)crashHelper {
    return @"LLCrashHelper";
}

/// LogHelper class name.
+ (NSString *)logHelper {
    return @"LLLogHelper";
}

/// NetworkHelper class name.
+ (NSString *)networkHelper {
    return @"LLNetworkHelper";
}

/// AppInfoHelper class name.
+ (NSString *)appInfoHelper {
    return @"LLAppInfoHelper";
}

/// ScreenshotHelper class name.
+ (NSString *)screenshotHelper {
    return @"LLScreenshotHelper";
}

/// LocationHelper class name.
+ (NSString *)locationHelper {
    return @"LLLocationHelper";
}

@end
