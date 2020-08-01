//
//  UIView+LL_Hierarchy_Lock.m
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

#import "UIView+LL_Hierarchy_Lock.h"

#import "NSObject+LL_Runtime.h"

@implementation UIView (LL_Hierarchy_Lock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceSelector:@selector(setFrame:) anotherSelector:@selector(LL_Hierarchy_setFrame:)];
        [self LL_swizzleInstanceSelector:@selector(setCenter:) anotherSelector:@selector(LL_Hierarchy_setCenter:)];
        [self LL_swizzleInstanceSelector:@selector(setAlpha:) anotherSelector:@selector(LL_Hierarchy_setAlpha:)];
        [self LL_swizzleInstanceSelector:@selector(setHidden:) anotherSelector:@selector(LL_Hierarchy_setHidden:)];
    });
}

- (void)LL_Hierarchy_setFrame:(CGRect)frame {
    if (self.LL_isLock) {
        self.LL_lockFrame = [NSValue valueWithCGRect:frame];
    } else {
        [self LL_Hierarchy_setFrame:frame];
    }
}

- (void)LL_Hierarchy_setCenter:(CGPoint)center {
    if (self.LL_isLock) {
        self.LL_lockCenter = [NSValue valueWithCGPoint:center];
    } else {
        [self LL_Hierarchy_setCenter:center];
    }
}

- (void)LL_Hierarchy_setAlpha:(CGFloat)alpha {
    if (self.LL_isLock) {
        self.LL_lockAlpha = @(alpha);
    } else {
        [self LL_Hierarchy_setAlpha:alpha];
    }
}

- (void)LL_Hierarchy_setHidden:(BOOL)hidden {
    if (self.LL_isLock) {
        self.LL_lockHidden = @(hidden);
    } else {
        [self LL_Hierarchy_setHidden:hidden];
    }
}

#pragma mark - Getters and setters
- (void)setLL_lock:(BOOL)LL_lock {
    BOOL isLock = self.LL_isLock;
    if (isLock != LL_lock) {
        objc_setAssociatedObject(self, @selector(LL_isLock), @(LL_lock), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!LL_lock) {
            if (self.LL_lockFrame) {
                self.frame = self.LL_lockFrame.CGRectValue;
            }
            if (self.LL_lockCenter) {
                self.center = self.LL_lockCenter.CGPointValue;
            }
            if (self.LL_lockAlpha) {
                self.alpha = self.LL_lockAlpha.floatValue;
            }
            if (self.LL_lockHidden) {
                self.hidden = self.LL_lockHidden.boolValue;
            }

            self.LL_lockFrame = nil;
            self.LL_lockCenter = nil;
            self.LL_lockAlpha = nil;
            self.LL_lockHidden = nil;
        }
    }
}

- (BOOL)LL_isLock {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLL_lockFrame:(NSValue *)LL_lockFrame {
    objc_setAssociatedObject(self, @selector(LL_lockFrame), LL_lockFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.LL_lockCenter = nil;
}

- (NSValue *)LL_lockFrame {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockCenter:(NSValue *)LL_lockCenter {
    objc_setAssociatedObject(self, @selector(LL_lockCenter), LL_lockCenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)LL_lockCenter {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockAlpha:(NSNumber *)LL_lockAlpha {
    objc_setAssociatedObject(self, @selector(LL_lockAlpha), LL_lockAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)LL_lockAlpha {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockHidden:(NSNumber *)LL_lockHidden {
    objc_setAssociatedObject(self, @selector(LL_lockHidden), LL_lockHidden, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)LL_lockHidden {
    return objc_getAssociatedObject(self, _cmd);
}

@end
