//
//  LLEntryViewController+AppInfo.m
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

#import "LLEntryViewController+AppInfo.h"

#import "LLAppInfoHelper.h"
#import "LLEntryAppInfoView.h"

#import "NSObject+LL_Runtime.h"
#import "UIView+LL_Utils.h"

@implementation LLEntryViewController (AppInfo)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceSelector:@selector(windowDidShow) anotherSelector:@selector(LL_AppInfo_windowDidShow)];
        [self LL_swizzleInstanceSelector:@selector(windowDidHide) anotherSelector:@selector(LL_AppInfo_windowDidHide)];
    });
}

#pragma mark - Runtime
- (void)LL_AppInfo_windowDidShow {
    [self LL_AppInfo_windowDidShow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolUpdateAppInfoNotification:) name:LLDebugToolUpdateAppInfoNotification object:nil];
}

- (void)LL_AppInfo_windowDidHide {
    [self LL_AppInfo_windowDidHide];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLDebugToolUpdateAppInfoNotification object:nil];
}

#pragma mark - LLDebugToolUpdateAppInfoNotification
- (void)didReceiveDebugToolUpdateAppInfoNotification:(NSNotification *)notification {
    if (self.style != LLDebugConfigEntryWindowStyleAppInfo) {
        return;
    }
    NSString *cpu = notification.userInfo[LLAppInfoHelperCPUDescriptionKey];
    NSString *memory = notification.userInfo[LLAppInfoHelperMemoryUsedDescriptionKey];
    NSString *fps = notification.userInfo[LLAppInfoHelperFPSKey];
    NSNumber *stuckCount = notification.userInfo[LLAppInfoHelperStuckCountKey];
    NSString *maxInterval = notification.userInfo[LLAppInfoHelperMaxIntervalDescriptionKey];
    NSString *message = [NSString stringWithFormat:@"CPU\t %@\nMEM\t %@\nFPS\t %@\nSTUCK\t %@\nMAX\t %@", cpu, memory, fps, stuckCount, maxInterval];
    [self.appInfoView setText:message];
    [self.delegate LLEntryViewController:self size:self.appInfoView.LL_size];
}

@end
