//
//  UIWindow+LL_Resolution.m
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

#import "UIWindow+LL_Resolution.h"

#import "LLDebugToolMacros.h"
#import "LLResolutionHelper.h"

#import "NSObject+LL_Runtime.h"

@implementation UIWindow (LL_Resolution)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([LLDT_CC_Resolution isMockResolution]) {
            [self LL_swizzleInstanceSelector:@selector(initWithFrame:) anotherSelector:@selector(LL_initWithFrame:)];
            [self LL_swizzleInstanceSelector:@selector(setFrame:) anotherSelector:@selector(LL_setFrame:)];
        }
    });
}

- (instancetype)LL_initWithFrame:(CGRect)frame {
    UIWindow *window = [self LL_initWithFrame:frame];
    if (CGRectEqualToRect(frame, [UIScreen mainScreen].bounds)) {
        //        window.frame = frame;
        //        [window LL_setFrame:[self recommendFrame]];
    }
    return window;
}

- (void)LL_setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, self.LL_mockFrame)) {
        frame.origin = CGPointMake(LLDT_CC_Resolution.horizontalPadding + frame.origin.x, LLDT_CC_Resolution.verticalPadding + frame.origin.y);
        self.LL_mockFrame = frame;
        [self LL_setFrame:frame];
    }
}

#pragma mark - Primary
- (CGRect)recommendFrame {
    CGFloat simulateHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat simulateWidth = [UIScreen mainScreen].bounds.size.width;

    return CGRectMake(LLDT_CC_Resolution.horizontalPadding, LLDT_CC_Resolution.verticalPadding, simulateWidth, simulateHeight);
    /*
    CGFloat realRatio = realWidth / realHeight;
    CGFloat simulateRatio = simulateWidth / simulateHeight;
    if (simulateRatio == realRatio) {
        return [UIScreen mainScreen].bounds;
    }

    if (simulateRatio < realRatio) {
        return CGRectMake((realWidth - realHeight * simulateRatio) / 2.0, 0, realHeight * simulateRatio, realHeight);
    }
    return CGRectMake(0, (realHeight - realWidth / simulateRatio) / 2.0, realWidth, realWidth / simulateRatio);
     */
}

#pragma mark - Getters and setters
- (void)setLL_mockFrame:(CGRect)LL_mockFrame {
    objc_setAssociatedObject(self, @selector(LL_mockFrame), [NSValue valueWithCGRect:LL_mockFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)LL_mockFrame {
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

@end
