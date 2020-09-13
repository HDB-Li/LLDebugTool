//
//  UIView+LL_Resolution.m
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

#import "UIView+LL_Resolution.h"

#import "LLDebugToolMacros.h"

#import "NSObject+LL_Runtime.h"

@implementation UIView (LL_Resolution)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([LLDT_CC_Resolution isMockResolution]) {
            [self LL_swizzleInstanceSelector:@selector(safeAreaInsets) anotherSelector:@selector(LL_safeAreaInsets)];
            [self LL_swizzleInstanceSelector:NSSelectorFromString(@"setSafeAreaInsets:") anotherSelector:@selector(LL_setSafeAreaInsets:)];
        }
    });
}

- (UIEdgeInsets)LL_safeAreaInsets {
    UIEdgeInsets insets = [self LL_safeAreaInsets];
    //    if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
    //        NSString *str = NSStringFromUIEdgeInsets(insets);
    //        NSLog(@"%@, %@", str, NSStringFromClass(self.class));
    //        return UIEdgeInsetsMake(insets.top - (44 - 20), insets.left, insets.bottom, insets.right);
    //    }
    return insets;
}

- (void)LL_setSafeAreaInsets:(UIEdgeInsets)insets {
    UIEdgeInsets newInsets = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right);
    //    if (!UIEdgeInsetsEqualToEdgeInsets(newInsets, UIEdgeInsetsZero)) {
    //        if (insets.bottom == 34) {
    //            newInsets.bottom = 0;
    //        }
    //        if (insets.top == 88) {
    //            newInsets.top = 64;
    //        } else if (insets.top == 44) {
    //            newInsets.top = 20;
    //        } else if (insets.top == 20) {
    //
    //        } else {
    //            NSLog(@"");
    //        }
    //    }
    [self LL_setSafeAreaInsets:newInsets];
}

@end
