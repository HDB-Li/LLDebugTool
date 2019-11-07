//
//  LLHSB.m
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

#import "LLHSB.h"

#import "LLRGB.h"

@implementation LLHSB

- (instancetype)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha {
    if (self = [super init]) {
        _hue = hue;
        _saturation = saturation;
        _brightness = brightness;
        _alpha = alpha;
    }
    return self;
}

- (LLRGB *)toRGB {
    CGFloat r = 0, g = 0, b = 0;
    NSInteger i = (NSInteger)(self.hue * 6);
    CGFloat f = self.hue * 6 - i;
    CGFloat p = self.brightness * (1 - self.saturation);
    CGFloat q = self.brightness * (1 - f * self.saturation);
    CGFloat t = self.brightness * (1 - (1 - f) * self.saturation);
    switch (i % 6) {
        case 0:{
            r = self.brightness;
            g = t;
            b = p;
        }
            break;
        case 1: {
            r = q;
            g = self.brightness;
            b = p;
        }
            break;
        case 2: {
            r = p;
            g = self.brightness;
            b = t;
        }
            break;
        case 3: {
            r = p;
            g = q;
            b = self.brightness;
        }
            break;
        case 4: {
            r = t;
            g = p;
            b = self.brightness;
        }
            break;
        case 5: {
            r = self.brightness;
            g = p;
            b = q;
        }
            break;
    }
    return [[LLRGB alloc] initWithRed:r green:g blue:b alpha:self.alpha];
}

@end
