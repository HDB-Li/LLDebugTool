//
//  UIView+LLWidgetBorder.m
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

#import "UIView+LLWidgetBorder.h"

#import "LLThemeManager.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "NSObject+LL_Runtime.h"

static const char kLLBorderLayerKey;

@implementation UIView (LLWidgetBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UIView class] LL_swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews) swizzledSel:@selector(LL_layoutSubviews)];
    });
}

- (void)LL_layoutSubviews {
    [self LL_layoutSubviews];
    [self LL_updateBorderLayer:[LLConfig shared].isShowWidgetBorder];
}

- (void)LL_updateBorderLayer:(BOOL)enable {
    
    for (UIView *subview in self.subviews) {
        [subview LL_updateBorderLayer:enable];
    }
    
    if (enable) {
        [self.layer addSublayer:self.LL_borderLayer];
        self.LL_borderLayer.frame = self.bounds;
        self.LL_borderLayer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    } else {
        [self.LL_borderLayer removeFromSuperlayer];
    }
}

#pragma mark - Getters and setters
- (void)setLL_borderLayer:(CALayer *)LL_borderLayer {
    objc_setAssociatedObject(self, &kLLBorderLayerKey, LL_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)LL_borderLayer {
    CALayer *layer = objc_getAssociatedObject(self, &kLLBorderLayerKey);
    if (!layer) {
        layer = [CALayer layer];
        layer.borderWidth = kLLWidgetBorderWidth;
        layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
        [self setLL_borderLayer:layer];
    }
    return layer;
}

@end
