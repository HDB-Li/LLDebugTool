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

#include <execinfo.h>
#include <libkern/OSAtomic.h>

#import "LLCrashModel.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLFormatterTool.h"
#import "LLStorageManager.h"
#import "LLTool.h"

#import "NSObject+LL_Utils.h"

static NSUncaughtExceptionHandler *_originExceptionHandler = nil;

@interface LLCrashHelper ()

@end

@implementation LLCrashHelper

#pragma mark - Over write
- (void)start {
    [super start];
    [self registerCatch];
}

- (void)stop {
    [super stop];
    [self unregisterCatch];
}

#pragma mark - LLCrashHelperDelegate
- (void)saveException:(NSException *)exception {
    NSString *date = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle1];
    NSString *appInfoDescription = [LLDT_CC_AppInfo appInfoDescription];

    LLCrashModel *model = [[LLCrashModel alloc] initWithName:exception.name reason:exception.reason userInfo:exception.userInfo stackSymbols:exception.callStackSymbols date:date thread:[NSThread currentThread].description userIdentity:[LLDebugConfig shared].userIdentity appInfoDescription:appInfoDescription launchDate:[NSObject LL_launchDate]];
    [[LLStorageManager shared] saveModel:model
                                complete:^(BOOL result) {
                                    [LLTool log:@"Save crash model success"];
                                }
                             synchronous:YES];
    [LLTool log:[NSString stringWithFormat:@"%@", exception] synchronous:YES withPrompt:NO];
}

- (Class)crashModelClass {
    return NSClassFromString(@"LLCrashModel");
}

#pragma mark - Primary
- (void)registerCatch {
    _originExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&HandleException);

    NSArray *signs = @[@(SIGHUP), @(SIGINT), @(SIGQUIT), @(SIGILL), @(SIGTRAP), @(SIGABRT),
#ifdef SIGPOLL
                       @(SIGPOLL),
#endif
#ifdef SIGEMT
                       @(SIGEMT),
#endif
                       @(SIGFPE),
                       @(SIGKILL),
                       @(SIGBUS),
                       @(SIGSEGV),
                       @(SIGSYS),
                       @(SIGPIPE),
                       @(SIGALRM),
                       @(SIGTERM),
                       @(SIGURG),
                       @(SIGSTOP),
                       @(SIGTSTP),
                       @(SIGCONT),
                       @(SIGCHLD),
                       @(SIGTTIN),
                       @(SIGTTOU),
#ifdef SIGIO
                       @(SIGIO),
#endif
                       @(SIGXCPU),
                       @(SIGXFSZ),
                       @(SIGVTALRM),
                       @(SIGPROF),
#ifdef SIGWINCH
                       @(SIGWINCH),
#endif
#ifdef SIGINFO
                       @(SIGINFO),
#endif
                       @(SIGUSR1),
                       @(SIGUSR2)];
    for (NSNumber *sign in signs) {
        signal(sign.intValue, SignalHandler);
    }
}

- (void)unregisterCatch {
    NSSetUncaughtExceptionHandler(_originExceptionHandler);

    NSArray *signs = @[@(SIGHUP), @(SIGINT), @(SIGQUIT), @(SIGILL), @(SIGTRAP), @(SIGABRT),
#ifdef SIGPOLL
                       @(SIGPOLL),
#endif
#ifdef SIGEMT
                       @(SIGEMT),
#endif
                       @(SIGFPE),
                       @(SIGKILL),
                       @(SIGBUS),
                       @(SIGSEGV),
                       @(SIGSYS),
                       @(SIGPIPE),
                       @(SIGALRM),
                       @(SIGTERM),
                       @(SIGURG),
                       @(SIGSTOP),
                       @(SIGTSTP),
                       @(SIGCONT),
                       @(SIGCHLD),
                       @(SIGTTIN),
                       @(SIGTTOU),
#ifdef SIGIO
                       @(SIGIO),
#endif
                       @(SIGXCPU),
                       @(SIGXFSZ),
                       @(SIGVTALRM),
                       @(SIGPROF),
#ifdef SIGWINCH
                       @(SIGWINCH),
#endif
#ifdef SIGINFO
                       @(SIGINFO),
#endif
                       @(SIGUSR1),
                       @(SIGUSR2)];
    for (NSNumber *sign in signs) {
        signal(sign.intValue, SIG_DFL);
    }
}

void HandleException(NSException *exception) {
    [LLDT_CC_Crash saveException:exception];
    if (_originExceptionHandler) {
        _originExceptionHandler(exception);
    } else {
        [exception raise];
    }
}

void SignalHandler(int sig) {
    // See https://stackoverflow.com/questions/40631334/how-to-intercept-exc-bad-instruction-when-unwrapping-nil.
    NSDictionary *json = @{ @(SIGHUP): @"SIGHUP",
                            @(SIGINT): @"SIGINT",
                            @(SIGQUIT): @"SIGQUIT",
                            @(SIGILL): @"SIGILL",
                            @(SIGTRAP): @"SIGTRAP",
                            @(SIGABRT): @"SIGABRT",
#ifdef SIGPOLL
                            @(SIGPOLL): @"SIGPOLL",
#endif
                            @(SIGEMT): @"SIGEMT",
                            @(SIGFPE): @"SIGFPE",
                            @(SIGKILL): @"SIGKILL",
                            @(SIGBUS): @"SIGBUS",
                            @(SIGSEGV): @"SIGSEGV",
                            @(SIGSYS): @"SIGSYS",
                            @(SIGPIPE): @"SIGPIPE",
                            @(SIGALRM): @"SIGALRM",
                            @(SIGTERM): @"SIGTERM",
                            @(SIGURG): @"SIGURG",
                            @(SIGSTOP): @"SIGSTOP",
                            @(SIGTSTP): @"SIGTSTP",
                            @(SIGCONT): @"SIGCONT",
                            @(SIGCHLD): @"SIGCHLD",
                            @(SIGTTIN): @"SIGTTIN",
                            @(SIGTTOU): @"SIGTTOU",
#ifdef SIGIO
                            @(SIGIO): @"SIGIO",
#endif
                            @(SIGXCPU): @"SIGXCPU",
                            @(SIGXFSZ): @"SIGXFSZ",
                            @(SIGVTALRM): @"SIGVTALRM",
                            @(SIGPROF): @"SIGPROF",
#ifdef SIGWINCH
                            @(SIGWINCH): @"SIGWINCH",
#endif
#ifdef SIGINFO
                            @(SIGINFO): @"SIGINFO",
#endif
                            @(SIGUSR1): @"SIGUSR1",
                            @(SIGUSR2): @"SIGUSR2"
    };

    NSString *name = json[@(sig)];
    if (!name) {
        name = @"Unknown signal";
    }

    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSString *date = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle1];
    LLCrashModel *model = [[LLCrashModel alloc] initWithName:name reason:[NSString stringWithFormat:@"%@ Signal", name] userInfo:nil stackSymbols:callStackSymbols date:date thread:[NSThread currentThread].description userIdentity:[LLDebugConfig shared].userIdentity appInfoDescription:[LLDT_CC_AppInfo appInfoDescription] launchDate:[NSObject LL_launchDate]];
    [[LLStorageManager shared] saveModel:model
                                complete:^(BOOL result) {
                                    [LLTool log:@"Save signal model success"];
                                }
                             synchronous:YES];

    kill(getpid(), SIGKILL);
}

@end
