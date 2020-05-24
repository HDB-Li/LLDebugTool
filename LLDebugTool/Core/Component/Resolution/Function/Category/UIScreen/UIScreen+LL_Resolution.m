//
//  UIScreen+LL_Resolution.m
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

#import "UIScreen+LL_Resolution.h"

#import "LLResolutionHelper.h"

#import "LLRouter+Resolution.h"
#import "NSObject+LL_Runtime.h"

@implementation UIScreen (LL_Resolution)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([LLRouter isMockResolution]) {
            [self LL_swizzleInstanceSelector:@selector(bounds) anotherSelector:@selector(LL_bounds)];
            [self LL_swizzleInstanceSelector:@selector(scale) anotherSelector:@selector(LL_scale)];
        }
    });
}

#pragma mark - Primary
- (CGRect)LL_bounds {
    return [LLResolutionHelper shared].bounds;
}

- (CGFloat)LL_scale {
    return [LLResolutionHelper shared].scale;
}

#pragma mark - Getters and setters
- (CGRect)LL_realBounds {
    if ([LLRouter isMockResolution]) {
        return [self LL_bounds];
    }
    return [self bounds];
}

- (CGFloat)LL_realScale {
    if ([LLRouter isMockResolution]) {
        return [self LL_scale];
    }
    return [self scale];
}

@end
