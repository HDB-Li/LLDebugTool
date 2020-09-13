//
//  UINavigationBar+LL_Resolution.m
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

#import "UINavigationBar+LL_Resolution.h"

#import "LLDebugToolMacros.h"
#import "LLResolutionHelper.h"
#import "LLResolutionStatusBarView.h"

#import "NSObject+LL_Runtime.h"

@implementation UINavigationBar (LL_Resolution)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([LLDT_CC_Resolution isMockResolution]) {
            [self LL_swizzleInstanceSelector:@selector(setFrame:) anotherSelector:@selector(LL_setFrame:)];
        }
    });
}

- (void)LL_setFrame:(CGRect)frame {
    CGRect newRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    if ([LLDT_CC_Resolution addResolutionStatusBarView]) {
        CGFloat height = [LLDT_CC_Resolution resolutionStatusBarViewHeight];
        newRect.size.height = height;
        if (!self.LL_resolutionStatusBarView.superview) {
            [self addSubview:self.LL_resolutionStatusBarView];
        }
        self.LL_resolutionStatusBarView.frame = CGRectMake(0, -height, frame.size.width, height);
    }
    [self LL_setFrame:newRect];
}

#pragma mark - Getters and setters
- (LLResolutionStatusBarView *)LL_resolutionStatusBarView {
    LLResolutionStatusBarView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[LLResolutionStatusBarView alloc] initWithFrame:CGRectZero];
        [self setLL_ResolutionStatusBarView:view];
    }
    return view;
}

- (void)setLL_ResolutionStatusBarView:(LLResolutionStatusBarView *)resolutionStatusBarView {
    objc_setAssociatedObject(self, @selector(LL_resolutionStatusBarView), resolutionStatusBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
