//
//  LLWindow.m
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

#import "LLWindow.h"

@interface LLWindow()

@end

@implementation LLWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)showWindow {
    if (self.isHidden) {
        if ([[NSThread currentThread] isMainThread]) {
            self.hidden = NO;
            [self.windowViewController reloadTabbar];
            [self.windowViewController registerLLAppHelperNotification];
        } else {
            [self performSelectorOnMainThread:@selector(showWindow) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)hideWindow {
    if (self.isHidden == NO) {
        if ([[NSThread currentThread] isMainThread]) {
            self.hidden = YES;
            [self.windowViewController unregisterLLAppHelperNotification];
        } else {
            [self performSelectorOnMainThread:@selector(hideWindow) withObject:nil waitUntilDone:YES];
        }
    }
}

#pragma mark - Primary
- (void)initial {
    // Set color
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    // Set level
    self.windowLevel = UIWindowLevelAlert + 2;
    // Set root
    LLWindowViewController *vc = [[LLWindowViewController alloc] init];
    vc.sBallWidth = [LLConfig sharedConfig].suspensionBallWidth;
    vc.windowStyle = [LLConfig sharedConfig].windowStyle;
    vc.window = self;
    self.rootViewController = vc;
    _windowViewController = vc;
}

@end
