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

#import "LLDebugConfig.h"
#import "LLNetworkModel.h"
#import "LLNetworkTool.h"
#import "LLNetworkViewController.h"
#import "LLReachability.h"
#import "LLTool.h"
#import "LLURLProtocol.h"

@interface LLNetworkHelper ()

@property (nonatomic, strong) LLReachability *reachability;

@end

@implementation LLNetworkHelper

#pragma mark - Over write
- (void)start {
    [super start];
    [self registerURLProtocol];
}

- (void)stop {
    [super stop];
    [self unregisterURLProtocol];
}

#pragma mark - LLNetworkHelperDelegate
- (LLNetworkStatus)currentNetworkStatus {
    //    if (@available(iOS 13.0, *)) {
    //        return [self.reachability currentReachabilityStatus];
    //    } else {
    return [LLNetworkTool networkStateFromStatebar];
    //    }
}

- (UIViewController *)networkViewControllerWithLaunchDate:(NSString *)launchDate {
    Class cls = [self networkViewControllerClass];
    if (!cls) {
        return nil;
    }
    UIViewController *vc = [[cls alloc] init];
    [vc setValue:launchDate forKey:@"launchDate"];
    return vc;
}

- (Class)networkModelClass {
    return [LLNetworkModel class];
}

- (Class)networkViewControllerClass {
    return [LLNetworkViewController class];
}

#pragma mark - Primary
- (instancetype)init {
    if (self = [super init]) {
        self.reachability = [LLReachability reachabilityWithHostName:@"www.apple.com"];
        [self.reachability startNotifier];
    }
    return self;
}

- (void)registerURLProtocol {
    if (![NSURLProtocol registerClass:[LLURLProtocol class]]) {
        [LLTool log:@"LLNetworkHelper reigsiter URLProtocol fail"];
    }
    if ([LLDebugConfig shared].observerWebView) {
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
        if ([cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cls performSelector:sel
                      withObject:@"http"];
            [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
        }
    }
}

- (void)unregisterURLProtocol {
    [NSURLProtocol unregisterClass:[LLURLProtocol class]];
    if ([LLDebugConfig shared].observerWebView) {
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
        if ([cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cls performSelector:sel
                      withObject:@"http"];
            [cls performSelector:sel withObject:@"https"];
#pragma clang diagnostic pop
        }
    }
}

@end
