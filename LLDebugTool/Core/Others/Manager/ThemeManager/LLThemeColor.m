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
        _hackThemeColor = [self colorWithPrimaryColor:[UIColor greenColor] backgroundColor:[UIColor LL_colorWithHex:@"#333333"] statusBarStyle:UIStatusBarStyleLightContent];
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

+ (LLThemeColor *)grassThemeColor {
    static LLThemeColor *_grassThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _grassThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#FFF0A5"] backgroundColor:[UIColor LL_colorWithHex:@"#13773D"] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _grassThemeColor;
}

+ (LLThemeColor *)homebrewThemeColor {
    static LLThemeColor *_homebrewThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _homebrewThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#28FE14"] backgroundColor:[UIColor LL_colorWithHex:@"#000000"] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _homebrewThemeColor;
}

+ (LLThemeColor *)manPageThemeColor {
    static LLThemeColor *_manPageThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manPageThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#000000"] backgroundColor:[UIColor LL_colorWithHex:@"#FEF49C"] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _manPageThemeColor;
}

+ (LLThemeColor *)novelThemeColor {
    static LLThemeColor *_novelThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _novelThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#3B2322"] backgroundColor:[UIColor LL_colorWithHex:@"#DFDBC3"] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _novelThemeColor;
}

+ (LLThemeColor *)oceanThemeColor {
    static LLThemeColor *_oceanThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _oceanThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#FFFFFF"] backgroundColor:[UIColor LL_colorWithHex:@"#224FBC"] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _oceanThemeColor;
}

+ (LLThemeColor *)proThemeColor {
    static LLThemeColor *_proThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _proThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#F2F2F2"] backgroundColor:[UIColor LL_colorWithHex:@"#000000"] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _proThemeColor;
}

+ (LLThemeColor *)redSandsThemeColor {
    static LLThemeColor *_redSandsThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _redSandsThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#D7C9A7"] backgroundColor:[UIColor LL_colorWithHex:@"#7A251E"] statusBarStyle:UIStatusBarStyleLightContent];
    });
    return _redSandsThemeColor;
}

+ (LLThemeColor *)silverAerogelThemeColor {
    static LLThemeColor *_silverAerogelThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _silverAerogelThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#000000"] backgroundColor:[UIColor LL_colorWithHex:@"#929292"] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _silverAerogelThemeColor;
}

+ (LLThemeColor *)solidColorsThemeColor {
    static LLThemeColor *_solidColorsThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _solidColorsThemeColor = [self colorWithPrimaryColor:[UIColor LL_colorWithHex:@"#000000"] backgroundColor:[UIColor LL_colorWithHex:@"#FFFFFF"] statusBarStyle:UIStatusBarStyleDefault];
    });
    return _solidColorsThemeColor;
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
        return;
    }
    
    _containerColor = [_backgroundColor LL_mixtureWithColor:_primaryColor radio:0.1];
    _placeHolderColor = [_primaryColor LL_mixtureWithColor:_backgroundColor radio:0.5];
}

@end
