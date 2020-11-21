//
//  LLLogHelper.m
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

#import "LLLogHelper.h"

#import "LLDebugConfig.h"
#import "LLFormatterTool.h"
#import "LLLogModel.h"
#import "LLStorageManager.h"

#import "NSObject+LL_Utils.h"

@implementation LLLogHelper

#pragma mark - LLLogHelperDelegate
- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo level:(LLDebugConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message {
    NSString *date = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle1];

    NSString *header = @"\n--------Debug Tool--------";
    NSString *onEventString = onEvent.length ? [NSString stringWithFormat:@"\nEvent:<%@>", onEvent] : @"";
    NSString *fileString = [NSString stringWithFormat:@"\nFile:<%@>", file];
    NSString *lineNoString = [NSString stringWithFormat:@"\nLine:<%ld>", (long)lineNo];
    NSString *funcString = [NSString stringWithFormat:@"\nFunc:<%@>", function];
    NSString *dateString = [NSString stringWithFormat:@"\nDate:<%@>", date];
    NSString *messageString = [NSString stringWithFormat:@"\nDesc:<%@>", message];
    NSString *footer = @"\n--------------------------";

    LLDebugConfigLogStyle logStyle = [LLDebugConfig shared].logStyle;
    switch (logStyle) {
        case LLDebugConfigLogDetail: {
            NSLog(@"%@%@%@%@%@%@%@%@", header, onEventString, fileString, lineNoString, funcString, dateString, messageString, footer);
        } break;
        case LLDebugConfigLogFileFuncDesc: {
            NSLog(@"%@%@%@%@%@%@", header, onEventString, fileString, funcString, messageString, footer);
        } break;
        case LLDebugConfigLogFileDesc: {
            NSLog(@"%@%@%@%@%@", header, onEventString, fileString, messageString, footer);
        } break;
        case LLDebugConfigLogNone: {
        } break;
        case LLDebugConfigLogNormal:
        default: {
            NSLog(@"%@", message);
        } break;
    }

    if (self.isEnabled) {
        LLLogModel *model = [[LLLogModel alloc] initWithFile:file lineNo:lineNo function:function level:level onEvent:onEvent message:message date:date launchDate:[NSObject LL_launchDate] userIdentity:[LLDebugConfig shared].userIdentity];
        [[LLStorageManager shared] saveModel:model complete:nil];
    }
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [self logInFile:file
           function:function
             lineNo:lineNo
              level:LLDebugConfigLogLevelDefault
            onEvent:onEvent
            message:message];
}

- (void)alertLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [self logInFile:file
           function:function
             lineNo:lineNo
              level:LLDebugConfigLogLevelAlert
            onEvent:onEvent
            message:message];
}

- (void)warningLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [self logInFile:file
           function:function
             lineNo:lineNo
              level:LLDebugConfigLogLevelWarning
            onEvent:onEvent
            message:message];
}

- (void)errorLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [self logInFile:file
           function:function
             lineNo:lineNo
              level:LLDebugConfigLogLevelError
            onEvent:onEvent
            message:message];
}

- (NSArray<NSString *> *)levelsDescription {
    return @[@"Default", @"Alert", @"Warning", @"Error"];
}

- (UIViewController *)logViewControllerWithLaunchDate:(NSString *)launchDate {
    Class cls = [self logViewControllerClass];
    if (!cls) {
        return nil;
    }
    UIViewController *vc = [[cls alloc] init];
    [vc setValue:launchDate forKey:@"launchDate"];
    return vc;
}

- (Class)logModelClass {
    return NSClassFromString(@"LLLogModel");
}

- (Class)logViewControllerClass {
    return NSClassFromString(@"LLLogViewController");
}

@end
