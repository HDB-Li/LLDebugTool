//
//  LLRoute.m
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

#import "LLRoute.h"
#import "LLBaseViewController.h"

#ifndef INSTALLED_LLDEBUGTOOL
#define INSTALLED_LLDEBUGTOOL (__has_include("LLDebugTool.h") || __has_include("<LLDebugTool.h>"))
#endif

#ifndef LL_HAS_INCLUDE_APP_HELPER
#define LL_HAS_INCLUDE_APP_HELPER (__has_include("LLAppHelper.h") || __has_include("<LLAppHelper.h>"))
#endif

#if __has_include("LLDebugTool.h")
#import "LLDebugTool.h"
#import "LLNetworkHelper.h"
#import "LLLogHelper.h"
#import "LLCrashHelper.h"
#import "LLAppHelper.h"
#import "LLScreenshotHelper.h"
#import "LLWindow.h"
#import "LLDebugToolMacros.h"
#elif __has_include("<LLDebugTool.h>")
#import "<LLDebugTool.h>"
#import "<LLNetworkHelper.h>"
#import "<LLLogHelper.h>"
#import "<LLCrashHelper.h>"
#import "<LLAppHelper.h>"
#import "<LLScreenshotHelper.h>"
#import "<LLWindow.h>"
#import "<LLDebugToolMacros.h"
#endif

#if __has_include("LLLogHelper.h")
#import "LLLogHelper.h"
#import "LLDebugToolMacros.h"
#elif __has_include("<LLLogHelper.h>")
#import "<LLLogHelper.h>"
#import "<LLDebugToolMacros.h>"
#endif

#if __has_include("LLAppHelper.h")
#import "LLAppHelper.h"
#elif __has_include("<LLAppHelper.h>")
#import "<LLAppHelper.h>"
#endif

// Event
NSString * const kLLDebugToolEvent = @"LLDebugTool";
NSString * const kLLFailedLoadingResourceEvent = @"Resource Failed";

// Define
NSString * const kLLUseBetaAlertPrompt = @"You are using a Beta version, please use release version.";
NSString * const kLLOpenIssueInGithubPrompt = @" Open an issue in \"https://github.com/HDB-Li/LLDebugTool\" if you need to get more help.";

@implementation LLRoute

+ (void)logWithMessage:(NSString *_Nonnull)message event:(NSString *_Nullable)event {
    if ([LLConfig sharedConfig].showDebugToolLog) {
        NSString *header = @"\n--------Debug Tool--------";
        NSString *onEventString = [NSString stringWithFormat:@"\nEvent:<%@>",event];
        NSString *messageString = [NSString stringWithFormat:@"\nDesc:<%@>",message];
        NSString *footer = @"\n--------------------------";
        NSLog(@"%@%@%@%@",header,onEventString,messageString,footer);
    }
}

+ (void)setNewAvailables:(LLConfigAvailableFeature)availables {
#if INSTALLED_LLDEBUGTOOL
    if ([LLDebugTool sharedTool].isWorking) {
        BOOL networkEnable = availables & LLConfigAvailableNetwork;
        BOOL logEnable = availables & LLConfigAvailableLog;
        BOOL crashEnable = availables & LLConfigAvailableCrash;
        BOOL appInfoEnable = availables & LLConfigAvailableAppInfo;
        BOOL screenshotEnable = availables & LLConfigAvailableScreenshot;
        [[LLNetworkHelper sharedHelper] setEnable:networkEnable];
        [[LLLogHelper sharedHelper] setEnable:logEnable];
        [[LLCrashHelper sharedHelper] setEnable:crashEnable];
        [[LLAppHelper sharedHelper] setEnable:appInfoEnable];
        [[LLScreenshotHelper sharedHelper] setEnable:screenshotEnable];
    }
#endif
}

+ (void)showWindow {
#if INSTALLED_LLDEBUGTOOL
    [[LLDebugTool sharedTool].window showWindow];
#endif
}

+ (void)hideWindow {
#if INSTALLED_LLDEBUGTOOL
    [[LLDebugTool sharedTool].window hideWindow];
#endif
}

+ (void)updateRequestDataTraffic:(unsigned long long)requestDataTraffic responseDataTraffic:(unsigned long long)responseDataTraffic {
#if LL_HAS_INCLUDE_APP_HELPER
    [[LLAppHelper sharedHelper] updateRequestDataTraffic:requestDataTraffic responseDataTraffic:responseDataTraffic];
#endif
}
    
+ (NSMutableArray <NSArray <NSDictionary <NSString *,NSString *>*>*>*_Nonnull)appInfos {
#if LL_HAS_INCLUDE_APP_HELPER
    return [[LLAppHelper sharedHelper] appInfos];
#endif
    return nil;
}
    
+ (NSDictionary <NSString *, NSString *>*_Nonnull)dynamicAppInfos {
#if LL_HAS_INCLUDE_APP_HELPER
    return [[LLAppHelper sharedHelper] dynamicAppInfos];
#endif
    return nil;
}

+ (UIViewController *_Nullable)viewControllerWithName:(NSString *_Nonnull)name params:(NSDictionary <NSString *,id>*)params {
    Class cls = NSClassFromString(name);
    if (cls) {
        if ([cls isSubclassOfClass:LLBaseViewController.class]) {
            LLBaseViewController *vc = [[cls alloc] initWithStyle:UITableViewStyleGrouped];
            for (NSString *key in params) {
                id value = params[key];
                [vc setValue:value forKey:key];
            }
            return vc;
        }
    }
    return nil;
}
    
@end
