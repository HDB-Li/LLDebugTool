//
//  LLRouter+Network.m
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

#import "LLRouter+Network.h"

#import "LLTool.h"

@implementation LLRouter (Network)

+ (LLNetworkStatus)networkStateFromStatebar {
    __block LLNetworkStatus returnValue = LLNetworkStatusNotReachable;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            returnValue = [self networkStateFromStatebar];
        });
        return returnValue;
    }
    UIView * statusBarModern = [LLTool getUIStatusBarModern];
    if (@available(iOS 13.0, *)) {
        if (statusBarModern) {
            // _UIStatusBarDataCellularEntry
            id currentData = [[statusBarModern valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                // If wifiEntry is enabled, is WiFi.
                returnValue = LLNetworkStatusReachableViaWiFi;
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type != nil) {
                    switch (type.integerValue) {
                        case 5:
                            returnValue = LLNetworkStatusReachableViaWWAN4G;
                            break;
                        case 4:
                            returnValue = LLNetworkStatusReachableViaWWAN3G;
                            break;
                            //                        case 1: // Return 1 when 1G.
                            //                            break;
                        case 0:
                            // Return 0 when no sim card.
                            returnValue = LLNetworkStatusNotReachable;
                        default:
                            returnValue = LLNetworkStatusReachableViaWWAN;
                            break;
                    }
                }
            }
        }
    } else {
        if ([statusBarModern isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            // For iPhoneX
            NSArray *children = [[[statusBarModern valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
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
                if (returnValue != LLNetworkStatusNotReachable) {
                    break;
                }
            }
        } else {
            // For others iPhone
            NSArray *children = [[statusBarModern valueForKeyPath:@"foregroundView"] subviews];
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
            }
        }
    }
    
    return returnValue;
}

+ (UIViewController *)networkViewControllerWithLaunchDate:(NSString *_Nullable)launchDate {
    Class cls = [self networkViewControllerClass];
    if (!cls) {
        return nil;
    }
    UIViewController *vc = [[cls alloc] init];
    [vc setValue:launchDate forKey:@"launchDate"];
    return vc;
}

+ (Class _Nullable)networkModelClass {
    return NSClassFromString(@"LLNetworkModel");
}

+ (Class _Nullable)networkViewControllerClass {
    return NSClassFromString(@"LLNetworkViewController");
}

@end
