//
//  LLThemeManager.m
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

#import "LLThemeManager.h"
#import "UIColor+LL_Utils.h"
#import "LLConfig.h"

static LLThemeManager *_instance = nil;

@implementation LLThemeManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLThemeManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

#pragma mark - Primary
- (void)initial {
    _primaryColor = LLCONFIG_TEXT_COLOR;
    _backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    _containerColor = [self calculateContainerColor:LLCONFIG_TEXT_COLOR color2:LLCONFIG_BACKGROUND_COLOR];
    _grayBackgroundColor = [UIColor LL_colorWithHex:@"#EBEEF5"];
    _backgroundBColor = [UIColor blackColor];
    _backgroundWColor = [UIColor whiteColor];
}

- (UIColor *)calculateContainerColor:(UIColor *)color1 color2:(UIColor *)color2 {
    NSArray *colors1 = [color1 LL_RGBA];
    NSArray *colors2 = [color2 LL_RGBA];
    
    CGFloat r = ([colors1[0] doubleValue] - [colors2[0] doubleValue]) * 0.1 + [colors2[0] doubleValue];
    CGFloat g = ([colors1[1] doubleValue] - [colors2[1] doubleValue]) * 0.1 + [colors2[1] doubleValue];
    CGFloat b = ([colors1[2] doubleValue] - [colors2[2] doubleValue]) * 0.1 + [colors2[2] doubleValue];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
