//
//  LLDebugTool.m
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

#import "LLDebugTool.h"
#import "LLStorageManager.h"
#import "LLNetworkHelper.h"
#import "LLCrashHelper.h"
#import "LLAppHelper.h"
#import "LLWindow.h"
#import "LLLogHelper.h"



static LLDebugTool *_instance = nil;

@interface LLDebugTool ()

@property (nonatomic , strong) LLWindow *window;

@end

@implementation LLDebugTool

/**
 * Singleton
 @return Singleton
 */
+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLDebugTool alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)startWorking{
    if (!_isWorking) {
        _isWorking = YES;
        // Open crash helper
        [[LLCrashHelper sharedHelper] setEnable:YES];
        // Open log helper
        [[LLLogHelper sharedHelper] setEnable:YES];
        // Open network monitoring
        [[LLNetworkHelper sharedHelper] setEnable:YES];
        // Open app monitoring
        [[LLAppHelper sharedHelper] startMonitoring];
        // show window
        [self.window showWindow];
    }
}

- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        // Close app monitoring
        [[LLAppHelper sharedHelper] stopMonitoring];
        // Close network monitoring
        [[LLNetworkHelper sharedHelper] setEnable:NO];
        // Close log helper
        [[LLLogHelper sharedHelper] setEnable:NO];
        // Close crash helper
        [[LLCrashHelper sharedHelper] setEnable:NO];
        // hide window
        [self.window hideWindow];
    }
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
    [self.window.windowViewController showDebugViewControllerWithIndex:index];
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(int)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message, ...  {
    [[LLLogHelper sharedHelper] logInFile:file function:function lineNo:lineNo level:level onEvent:onEvent message:message];
}

#pragma mark - Primary
/**
 Initial something.
 */
- (void)initial {
    self.window = [[LLWindow alloc] initWithSuspensionBallWidth:[LLConfig sharedConfig].suspensionBallWidth];
}

@end
