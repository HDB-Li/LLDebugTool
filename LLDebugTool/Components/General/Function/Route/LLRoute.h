//
//  LLRoute.h
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

#import <Foundation/Foundation.h>
#import "LLConfig.h"

// Event
FOUNDATION_EXPORT NSString * _Nonnull const kLLDebugToolEvent;
FOUNDATION_EXPORT NSString * _Nonnull const kLLFailedLoadingResourceEvent;

// Define
FOUNDATION_EXPORT NSString * _Nonnull const kLLUseBetaAlertPrompt;
FOUNDATION_EXPORT NSString * _Nonnull const kLLOpenIssueInGithubPrompt;

static NSString * _Nonnull const kLLNetworkVCName = @"LLNetworkVC";
static NSString * _Nonnull const kLLLogVCName = @"LLLogVC";
static NSString * _Nonnull const kLLNetworkModelName = @"LLNetworkModel";
static NSString * _Nonnull const kLLLogModelName = @"LLLogModel";
static NSString * _Nonnull const kLLCrashModelName = @"LLCrashModel";

@interface LLRoute : NSObject

#pragma mark - DebugTool Route
/**
 If LLDebugTool exists, set new availables to LLDebugTool, otherwise nothing will be done.
 */
+ (void)setNewAvailables:(LLConfigAvailableFeature)availables;

/**
 If LLDebugTool exists, LLDebugTool's window called showWindow method, otherwise nothing will be done.
 */
+ (void)showWindow;

/**
 If LLDebugTool exists, LLDebugTool's window called hideWindow method, otherwise nothing will be done.
 */
+ (void)hideWindow;
    
#pragma mark - Log Route
/**
 Called NSLog.
 */
+ (void)logWithMessage:(NSString *_Nonnull)message event:(NSString *_Nullable)event;

#pragma mark - App Route
/**
 If LLAppHelper exists, LLAppHelper is called, otherwise nothing will be done.
 */
+ (void)updateRequestDataTraffic:(unsigned long long)requestDataTraffic responseDataTraffic:(unsigned long long)responseDataTraffic;

/**
 If LLAppHelper exists, LLAppHelper is called, otherwise nothing will be done.
 */
+ (NSMutableArray <NSArray <NSDictionary <NSString *,NSString *>*>*>*_Nonnull)appInfos;
    
/**
 If LLAppHelper exists, LLAppHelper is called, otherwise nothing will be done.
 */
+ (NSDictionary <NSString *, NSString *>*_Nonnull)dynamicAppInfos;

#pragma mark - Base
    
/**
 Return viewController if class is exist.
 */
+ (UIViewController *_Nullable)viewControllerWithName:(NSString *_Nonnull)name params:(NSDictionary <NSString *,id>*_Nullable)params;

@end
