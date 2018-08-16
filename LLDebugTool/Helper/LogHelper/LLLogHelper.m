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
#import "LLStorageManager.h"
#import "LLLogModel.h"
#import "LLConfig.h"
#import "LLTool.h"
#import "LLConfig.h"
#import "NSObject+LL_Utils.h"

static LLLogHelper *_instance = nil;

@implementation LLLogHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLLogHelper alloc] init];
    });
    return _instance;
}

+ (NSArray <NSString *>*)levelsDescription {
    return @[@"Default",@"Alert",@"Warning",@"Error"];
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(int)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message, ... {
    NSString *date = [LLTool stringFromDate:[NSDate date]];
    switch ([LLConfig sharedConfig].logStyle) {
        case LLConfigLogDetail:{
            if (onEvent.length) {
                NSLog(@"\n--------Debug Tool--------\
                      \nEvent:<%@>\
                      \nFile:<%@>\
                      \nLine:<%d>\
                      \nFunc:<%@>\
                      \nDate:<%@>\
                      \nDesc:%@\
                      \n--------------------------",onEvent,file,lineNo,function,date,message);
            } else {
                NSLog(@"\n--------Debug Tool--------\
                      \nFile:<%@>\
                      \nLine:<%d>\
                      \nFunc:<%@>\
                      \nDate:<%@>\
                      \nDesc:%@\
                      \n--------------------------",file,lineNo,function,date,message);
            }
        }
            break;
        case LLConfigLogNone: {
        }
            break;
        case LLConfigLogNormal:
        default:{
            NSLog(@"%@",message);
        }
            break;
    }

    if (_enable) {
        LLLogModel *model = [[LLLogModel alloc] initWithFile:file lineNo:lineNo function:function level:level onEvent:onEvent message:message date:date launchDate:[NSObject launchDate] userIdentity:[LLConfig sharedConfig].userIdentity];
        [[LLStorageManager sharedManager] saveModel:model complete:nil];
    }
}

@end
