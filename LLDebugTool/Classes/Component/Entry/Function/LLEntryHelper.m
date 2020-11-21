//
//  LLEntryHelper.m
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

#import "LLEntryHelper.h"

#import "LLComponentHandle.h"
#import "LLDebugConfig.h"

#import "LLWindowManager+Entry.h"
#import "UIResponder+LL_Utils.h"

@implementation LLEntryHelper

#pragma mark - Over write
- (void)start {
    [super start];
    [self registerNotification];
}

- (void)stop {
    [super stop];
    [self unregisterNotification];
}

#pragma mark - DebugToolShakeNotification
- (void)didReceiveDebugToolShakeNotification:(NSNotification *)notification {
    if (!self.isEnabled) {
        return;
    }

    if ([LLComponentHandle currentAction] != LLDebugToolActionEntry) {
        return;
    }

    if ([LLDebugConfig shared].isShakeToHide) {
        if ([LLWindowManager shared].entryWindow.isHidden) {
            [[LLWindowManager shared] showWindow:[LLWindowManager shared].entryWindow animated:YES];
        } else {
            [[LLWindowManager shared] removeAllVisibleWindows];
        }
    }
}

#pragma mark - Primary
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolShakeNotification:) name:LLDebugToolShakeNotification object:nil];
}

- (void)unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
