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

#import "LLThemeColor.h"

static LLThemeManager *_instance = nil;

NSString *const LLDebugToolUpdateThemeNotificationName = @"LLDebugToolUpdateThemeNotificationName";

@implementation LLThemeManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLThemeManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

+ (UIColor *)systemTintColor {
    static UIColor *_systemTintColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __IPHONE_13_0
        _systemTintColor = [UIColor systemBlueColor];
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        _systemTintColor = [UIColor performSelector:NSSelectorFromString(@"systemBlueColor")];
#pragma clang diagnostic pop
#endif
    });
    return _systemTintColor;
}

#pragma mark - Primary
- (void)initial {
    _themeColor = [LLThemeColor hackThemeColor];
}

#pragma mark - Getters and setters
- (void)setThemeColor:(LLThemeColor *)themeColor {
    if (_themeColor != themeColor) {
        _themeColor = themeColor;
        [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolUpdateThemeNotificationName object:nil];
    }
}

- (UIColor *)primaryColor {
    return _themeColor.primaryColor;
}

- (UIColor *)backgroundColor {
    return _themeColor.backgroundColor;
}

- (UIColor *)containerColor {
    return _themeColor.containerColor;
}

- (UIColor *)placeHolderColor {
    return _themeColor.placeHolderColor;
}

- (UIStatusBarStyle)statusBarStyle {
    return _themeColor.statusBarStyle;
}

@end
