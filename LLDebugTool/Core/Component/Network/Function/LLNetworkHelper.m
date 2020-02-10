//
//  LLNetworkHelper.m
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

#import "LLNetworkHelper.h"

#import "LLReachability.h"
#import "LLURLProtocol.h"
#import "LLConfig.h"
#import "LLTool.h"

#import "LLRouter+Network.h"

static LLNetworkHelper *_instance = nil;

@interface LLNetworkHelper ()

@property (nonatomic, strong) LLReachability *reachability;

@end

@implementation LLNetworkHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLNetworkHelper alloc] init];
    });
    return _instance;
}

- (void)setEnable:(BOOL)enable {
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self registerLLURLProtocol];
        } else {
            [self unregisterLLURLProtocol];
        }
    }
}

- (LLNetworkStatus)currentNetworkStatus {
//    if (@available(iOS 13.0, *)) {
//        return [self.reachability currentReachabilityStatus];
//    } else {
        return [LLRouter networkStateFromStatebar];
//    }
}

#pragma mark - Primary
- (instancetype)init {
    if (self = [super init]) {
        self.reachability = [LLReachability reachabilityWithHostName:@"www.apple.com"];
        [self.reachability startNotifier];
    }
    return self;
}

- (void)registerLLURLProtocol {
    if (![NSURLProtocol registerClass:[LLURLProtocol class]]) {
        [LLTool log:@"LLNetworkHelper reigsiter URLProtocol fail"];
    }
    if ([LLConfig shared].observerWebView) {
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
        if (cls && [cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cls performSelector:sel withObject:@"http"];
            [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
        }
    }
}

- (void)unregisterLLURLProtocol {
    [NSURLProtocol unregisterClass:[LLURLProtocol class]];
    if ([LLConfig shared].observerWebView) {
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
        if (cls && [cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cls performSelector:sel withObject:@"http"];
            [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
        }
    }
}

@end
