//
//  LLConfig+Magnifier.m
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

#import "LLConfig+Magnifier.h"

#import "NSObject+LL_Runtime.h"

@implementation LLConfig (Magnifier)

- (void)setMagnifierZoomLevel:(NSInteger)magnifierZoomLevel {
    objc_setAssociatedObject(self, @selector(magnifierZoomLevel), @(magnifierZoomLevel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)magnifierZoomLevel {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setMagnifierSize:(NSInteger)magnifierSize {
    if (magnifierSize % 2 == 0) {
        magnifierSize = magnifierSize + 1;
    } else {
        magnifierSize = magnifierSize;
    }
    objc_setAssociatedObject(self, @selector(magnifierSize), @(magnifierSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)magnifierSize {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
