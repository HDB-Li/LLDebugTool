//
//  LLThemeColor.m
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

#import "LLThemeColor.h"

#import "LLThemeManager.h"

#import "UIColor+LL_Utils.h"

@implementation LLThemeColor

+ (LLThemeColor *)hackThemeColor {
    static LLThemeColor *_hackThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hackThemeColor = [self colorWithPrimaryColor:[UIColor greenColor] backgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _hackThemeColor;
}

+ (LLThemeColor *)simpleThemeColor {
    static LLThemeColor *_simpleThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _simpleThemeColor = [self colorWithPrimaryColor:[UIColor darkTextColor] backgroundColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _simpleThemeColor;
}

+ (LLThemeColor *)systemThemeColor {
    static LLThemeColor *_systemThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemThemeColor = [self colorWithPrimaryColor:[LLThemeManager systemTintColor] backgroundColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _systemThemeColor;
}

- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (self = [super init]) {
        _primaryColor = primaryColor;
        _backgroundColor = backgroundColor;
        _statusBarStyle = statusBarStyle;
        [self calculateColorIfNeeded];
    }
    return self;
}

- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor {
    return [self initWithPrimaryColor:primaryColor backgroundColor:backgroundColor statusBarStyle:UIStatusBarStyleDefault];
}

+ (instancetype)colorWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    return [[self alloc] initWithPrimaryColor:primaryColor backgroundColor:backgroundColor statusBarStyle:statusBarStyle];
}

+ (instancetype)colorWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor {
    return [self colorWithPrimaryColor:primaryColor backgroundColor:backgroundColor statusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Primary
- (void)calculateColorIfNeeded {
    if (_primaryColor == nil || _backgroundColor == nil) {
        _containerColor = nil;
        _placeHolderColor = nil;
        return;
    }
    
    _containerColor = [_backgroundColor LL_mixtureWithColor:_primaryColor radio:0.1];
    _placeHolderColor = [_primaryColor LL_mixtureWithColor:_backgroundColor radio:0.5];
}

@end
