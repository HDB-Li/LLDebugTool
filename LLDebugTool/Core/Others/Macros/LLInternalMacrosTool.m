//
//  LLInternalMacrosTool.m
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

#import "LLInternalMacrosTool.h"

static BOOL isCalculateSpecialScreen = NO;
static BOOL isIPhoneX = NO;

@implementation LLInternalMacrosTool

+ (CGFloat)screenWidth {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)screenHeight {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)statusBarHeight {
    return [self isSpecialScreen] ? 44 : 20;
}

+ (CGFloat)navigationHeight {
    return [self statusBarHeight] + 44;
}

+ (CGFloat)bottomDangerHeight {
    return [self isSpecialScreen] ? 34 : 0;
}

+ (CGFloat)isSpecialScreen {
    if (!isCalculateSpecialScreen) {
        isCalculateSpecialScreen = YES;
        if (@available(iOS 11.0, *)) {
            isIPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
        }
    }
    return isIPhoneX;
}

+ (CGFloat)layoutHorizontal:(CGFloat)length {
    return length * [self screenWidth] / 414.0;
}

+ (CGFloat)minWithA:(CGFloat)a b:(CGFloat)b {
    return MIN(a, b);
}

+ (CGFloat)maxWithA:(CGFloat)a b:(CGFloat)b {
    return MAX(a, b);
}

@end
