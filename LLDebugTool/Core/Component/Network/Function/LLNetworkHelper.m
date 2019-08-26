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
#import "LLURLProtocol.h"
#import "LLRoute.h"
#import "LLReachability.h"

static LLNetworkHelper *_instance = nil;

@interface LLNetworkHelper ()

@property (nonatomic, strong) LLReachability *reachability;

@end

@implementation LLNetworkHelper

+ (instancetype)sharedHelper {
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
    if (@available(iOS 13.0, *)) {
        return [self.reachability currentReachabilityStatus];
    } else {
        return [self networkStateFromStatebar];
    }
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
        [LLRoute logWithMessage:@"LLNetworkHelper reigsiter URLProtocol fail." event:kLLDebugToolEvent];
    }
}

- (void)unregisterLLURLProtocol {
    [NSURLProtocol unregisterClass:[LLURLProtocol class]];
}

- (LLNetworkStatus)networkStateFromStatebar {
    __block LLNetworkStatus returnValue = LLNetworkStatusNotReachable;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            returnValue = [self networkStateFromStatebar];
        });
        return returnValue;
    }
    if (@available(iOS 13.0, *)) {
        
    } else {
        UIApplication *app = [UIApplication sharedApplication];
        if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            // For iPhoneX
            NSArray *children = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
            for (UIView *view in children) {
                for (id child in view.subviews) {
                    if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                        returnValue = LLNetworkStatusReachableViaWiFi;
                        break;
                    }
                    if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                        NSString *originalText = [child valueForKey:@"_originalText"];
                        if ([originalText containsString:@"G"]) {
                            if ([originalText isEqualToString:@"2G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN2G;
                            } else if ([originalText isEqualToString:@"3G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN3G;
                            } else if ([originalText isEqualToString:@"4G"]) {
                                returnValue = LLNetworkStatusReachableViaWWAN4G;
                            } else {
                                returnValue = LLNetworkStatusReachableViaWWAN;
                            }
                            break;
                        }
                    }
                }
            }
        } else {
            // For others iPhone
            NSArray *children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
            int type = -1;
            for (id child in children) {
                if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
                }
            }
            switch (type) {
                case 0:
                    returnValue = LLNetworkStatusNotReachable;
                    break;
                case 1:
                    returnValue = LLNetworkStatusReachableViaWWAN2G;
                    break;
                case 2:
                    returnValue = LLNetworkStatusReachableViaWWAN3G;
                    break;
                case 3:
                    returnValue = LLNetworkStatusReachableViaWWAN4G;
                    break;
                case 4:
                    returnValue = LLNetworkStatusReachableViaWWAN;
                    break;
                case 5:
                    returnValue = LLNetworkStatusReachableViaWiFi;
                    break;
                default:
                    break;
            }
        }
    }
    
    return returnValue;
}

@end
