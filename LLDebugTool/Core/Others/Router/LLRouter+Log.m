//
//  LLRouter+Log.m
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

#import "LLRouter+Log.h"

#ifdef LLDEBUGTOOL_LOG
#import "LLLog.h"
#endif

@implementation LLRouter (Log)

+ (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
#ifdef LLDEBUGTOOL_LOG
    [[LLLogHelper shared] logInFile:file function:function lineNo:lineNo level:LLConfigLogLevelDefault onEvent:onEvent message:message];
#else
    NSLog(@"%@", message);
#endif
}

+ (void)alertLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
#ifdef LLDEBUGTOOL_LOG
    [[LLLogHelper shared] logInFile:file function:function lineNo:lineNo level:LLConfigLogLevelAlert onEvent:onEvent message:message];
#else
    NSLog(@"%@", message);
#endif
}

+ (void)warningLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
#ifdef LLDEBUGTOOL_LOG
    [[LLLogHelper shared] logInFile:file function:function lineNo:lineNo level:LLConfigLogLevelWarning onEvent:onEvent message:message];
#else
    NSLog(@"%@", message);
#endif
}

+ (void)errorLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
#ifdef LLDEBUGTOOL_LOG
    [[LLLogHelper shared] logInFile:file function:function lineNo:lineNo level:LLConfigLogLevelError onEvent:onEvent message:message];
#else
    NSLog(@"%@", message);
#endif
}

+ (UIViewController *_Nullable)logViewControllerWithLaunchDate:(NSString *_Nullable)launchDate {
    Class cls = [self logViewControllerClass];
    if (!cls) {
        return nil;
    }
    UIViewController *vc = [[cls alloc] init];
    [vc setValue:launchDate forKey:@"launchDate"];
    return vc;
}

+ (Class _Nullable)logModelClass {
    return NSClassFromString(@"LLLogModel");
}

+ (Class _Nullable)logViewControllerClass {
    return NSClassFromString(@"LLLogViewController");
}

@end
