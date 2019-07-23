//
//  UIView+LL_Utils.m
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

#import "UIView+LL_Utils.h"
#import <objc/runtime.h>

static const char *kLLHorizontalPaddingKey = "kLLHorizontalPaddingKey";
static const char *kLLVerticalPaddingKey = "kLLVerticalPaddingKey";

@implementation UIView (LL_Utils)

+ (void)load {
    Method method5 = class_getInstanceMethod([self class], @selector(sizeToFit));
    Method method6 = class_getInstanceMethod([self class], @selector(LL_sizeToFit));
    if (method5 && method6) {
        method_exchangeImplementations(method5, method6);
    }
}

- (void)LL_sizeToFit {
    [self LL_sizeToFit];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width + 2 * self.LL_horizontalPadding, frame.size.height + 2 * self.LL_verticalPadding);
    self.frame = frame;
}

- (void)setLL_horizontalPadding:(CGFloat)LL_horizontalPadding {
    objc_setAssociatedObject(self, kLLHorizontalPaddingKey, @(LL_horizontalPadding), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)LL_horizontalPadding {
    return [objc_getAssociatedObject(self, kLLHorizontalPaddingKey) floatValue];
}

- (void)setLL_verticalPadding:(CGFloat)LL_verticalPadding {
    objc_setAssociatedObject(self, kLLVerticalPaddingKey, @(LL_verticalPadding), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)LL_verticalPadding {
    return [objc_getAssociatedObject(self, kLLVerticalPaddingKey) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end
