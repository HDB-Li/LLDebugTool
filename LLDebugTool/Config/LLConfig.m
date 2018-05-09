//
//  LLConfig.m
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

#import "LLConfig.h"

static LLConfig *_instance = nil;

@implementation LLConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLConfig alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)setColorStyle:(LLConfigColorStyle)colorStyle {
//    if (_colorStyle != colorStyle) {
        _colorStyle = colorStyle;
        _useSystemColor = NO;
        [self updateColor];
//    }
}

- (void)configBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _useSystemColor = NO;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
    _statusBarStyle = statusBarStyle;
}

#pragma mark - Primary
/**
 Initialize something.
 */
- (void)initial {
    // Set default values
    _bundlePath = @"LLDebugTool.bundle";
    _dateFormatter = @"yyyy-MM-dd HH:mm:ss";
    _systemTintColor = [[UIView alloc] init].tintColor;
    _colorStyle = LLConfigColorStyleHack;
    _suspensionBallWidth = 70;
    _normalAlpha = 0.9;
    _activeAlpha = 1.0;
    _suspensionBallMoveable = YES;
    [self updateColor];
}

- (void)updateColor {
    switch (self.colorStyle) {
        case LLConfigColorStyleSimple:{
            _backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            _textColor = [UIColor darkTextColor];
            _statusBarStyle = UIStatusBarStyleDefault;
        }
            break;
        case LLConfigColorStyleSystem: {
            _backgroundColor = [UIColor whiteColor];
            _textColor = self.systemTintColor;
            _statusBarStyle = UIStatusBarStyleDefault;
        }
            break;
        case LLConfigColorStyleHack:
        default:{
            _backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
            _textColor = [UIColor greenColor];
            _statusBarStyle = UIStatusBarStyleLightContent;
        }
            break;
    }
}

@end
