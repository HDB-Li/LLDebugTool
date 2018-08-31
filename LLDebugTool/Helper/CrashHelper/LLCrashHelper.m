//
//  LLCrashHelper.m
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

#import "LLCrashHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "LLStorageManager.h"
#import "LLCrashModel.h"
#import "LLAppHelper.h"
#import "LLConfig.h"
#import "LLTool.h"

static LLCrashHelper *_instance = nil;

@interface LLCrashHelper ()

@end

@implementation LLCrashHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLCrashHelper alloc] init];
    });
    return _instance;
}

- (void)setEnable:(BOOL)enable {
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self registerCatch];
        } else {
            [self unregisterCatch];
        }
    }
}

#pragma mark - Primary
- (void)registerCatch {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

- (void)unregisterCatch {
    NSSetUncaughtExceptionHandler(nil);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

- (void)saveException:(NSException *)exception {
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    if (exception.name)
    {
        [detail setObject:exception.name forKey:@"name"];
    }
    if (exception.reason)
    {
        [detail setObject:exception.reason forKey:@"reason"];
    }
    if (exception.userInfo)
    {
        [detail setObject:exception.userInfo forKey:@"userInfo"];
    }
    if (exception.callStackSymbols)
    {
        [detail setObject:exception.callStackSymbols forKey:@"stackSymbols"];
    }
    NSString *date = [LLTool stringFromDate:[NSDate date]];
    if (date) {
        [detail setObject:date forKey:@"date"];
    }
    if ([LLConfig sharedConfig].userIdentity) {
        [detail setObject:[LLConfig sharedConfig].userIdentity forKey:@"userIdentity"];
    }
    NSArray *appInfos = [[LLAppHelper sharedHelper] appInfos];
    if ([appInfos count]) {
        [detail setObject:appInfos forKey:@"appInfos"];
    }
    LLCrashModel *model = [[LLCrashModel alloc] initWithDictionary:detail];
    [[LLStorageManager sharedManager] saveModel:model complete:^(BOOL result) {
        NSLog(@"Save crash model success");
    } synchronous:YES];
}

void HandleException(NSException *exception)
{
    [[LLCrashHelper sharedHelper] saveException:exception];
    [exception raise];
}

void SignalHandler(int sig)
{

}
@end
