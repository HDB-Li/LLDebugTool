//
//  LLRouter+AppInfo.m
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

#import "LLRouter+AppInfo.h"

#ifdef LLDEBUGTOOL_APP_INFO
#import "LLAppInfoHelper.h"
#endif

@implementation LLRouter (AppInfo)

+ (void)updateRequestDataTraffic:(unsigned long long)requestDataTraffic responseDataTraffic:(unsigned long long)responseDataTraffic {
#ifdef LLDEBUGTOOL_APP_INFO
    [[LLAppInfoHelper shared] updateRequestDataTraffic:requestDataTraffic
                                   responseDataTraffic:responseDataTraffic];
#endif
}

+ (NSString *)appInfoDescription {
#ifdef LLDEBUGTOOL_APP_INFO
    return [[LLAppInfoHelper shared] appInfoDescription];
#else
    return nil;
#endif
}

+ (void)addAppInfoObserver:(id)observer selector:(SEL)aSelector {
#ifdef LLDEBUGTOOL_APP_INFO
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:LLDebugToolUpdateAppInfoNotification
                                               object:nil];
#endif
}

+ (void)removeAppInfoObserver:(id)observer {
#ifdef LLDEBUGTOOL_APP_INFO
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:LLDebugToolUpdateAppInfoNotification
                                                  object:nil];
#endif
}

+ (NSString *)analysisAppInfoNotification:(NSNotification *)notification {
#ifdef LLDEBUGTOOL_APP_INFO
    NSString *cpu = notification.userInfo[LLAppInfoHelperCPUDescriptionKey];
    NSString *memory = notification.userInfo[LLAppInfoHelperMemoryUsedDescriptionKey];
    NSString *fps = notification.userInfo[LLAppInfoHelperFPSKey];
    NSNumber *stuckCount = notification.userInfo[LLAppInfoHelperStuckCountKey];
    NSString *maxInterval = notification.userInfo[LLAppInfoHelperMaxIntervalDescriptionKey];
    return [NSString stringWithFormat:@"CPU\t %@\nMEM\t %@\nFPS\t %@\nSTUCK\t %@\nMAX\t %@", cpu, memory, fps, stuckCount, maxInterval];
#else
    return @"";
#endif
}

@end
