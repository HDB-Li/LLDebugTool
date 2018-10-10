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
#import "LLRoute.h"

static LLConfig *_instance = nil;

NSNotificationName const LLConfigDidUpdateColorStyleNotificationName = @"LLConfigDidUpdateColorStyleNotificationName";
NSNotificationName const LLConfigDidUpdateWindowStyleNotificationName = @"LLConfigDidUpdateWindowStyleNotificationName";

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
    if (colorStyle != LLConfigColorStyleCustom) {
        _colorStyle = colorStyle;
        [self updateColor];
        [[NSNotificationCenter defaultCenter] postNotificationName:LLConfigDidUpdateColorStyleNotificationName object:nil userInfo:nil];
    }
}

- (void)setWindowStyle:(LLConfigWindowStyle)windowStyle {
    if (_windowStyle != windowStyle) {
        _windowStyle = windowStyle;
        [[NSNotificationCenter defaultCenter] postNotificationName:LLConfigDidUpdateWindowStyleNotificationName object:nil userInfo:nil];
    }
}

- (void)setAvailables:(LLConfigAvailableFeature)availables {
    if (_availables != availables) {
        BOOL networkEnable = availables & LLConfigAvailableNetwork;
        BOOL logEnable = availables & LLConfigAvailableLog;
        BOOL crashEnable = availables & LLConfigAvailableCrash;
        BOOL appInfoEnable = availables & LLConfigAvailableAppInfo;
        BOOL sandboxEnable = availables & LLConfigAvailableSandbox;
        BOOL screenshotEnable = availables & LLConfigAvailableScreenshot;
        if (!networkEnable && !logEnable && !crashEnable && !appInfoEnable && !sandboxEnable && !screenshotEnable) {
            // Can't set none availables.
            return;
        }
        BOOL allEnable = networkEnable && logEnable && crashEnable && appInfoEnable && sandboxEnable && screenshotEnable;
        if (allEnable && (availables != LLConfigAvailableAll)) {
            // Check if input wrong.
            _availables = LLConfigAvailableAll;
        } else {
            _availables = availables;
        }
        // Start or close features.
        [LLRoute setNewAvailables:availables];
    }
}

- (void)configBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _colorStyle = LLConfigColorStyleCustom;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
    _statusBarStyle = statusBarStyle;
    [[NSNotificationCenter defaultCenter] postNotificationName:LLConfigDidUpdateColorStyleNotificationName object:nil userInfo:nil];
}

#pragma mark - Primary
/**
 Initialize something.
 */
- (void)initial {
    // Set default values
    // Set folder Path
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _folderPath = [doc stringByAppendingPathComponent:@"LLDebugTool"];
    
    // Set XIB resources.
    _XIBBundle = [NSBundle bundleForClass:self.class];
    NSString *imageBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"LLDebugTool" ofType:@"bundle"];
    _imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    if (!_XIBBundle) {
        NSLog(@"Failed to load the XIB bundle,%@",kLLOpenIssueInGithubPrompt);
    }
    if (!_imageBundle) {
        NSLog(@"Failed to load the XIB bundle,%@",kLLOpenIssueInGithubPrompt);
    }
    
    // Set date formatter string.
    _dateFormatter = @"yyyy-MM-dd HH:mm:ss";
    
    // Get system tint color.
    if ([[NSThread currentThread] isMainThread]) {
        _systemTintColor = [[UIView alloc] init].tintColor;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self->_systemTintColor = [[UIView alloc] init].tintColor;
        });
    }

    
    // Set default color style.
    _colorStyle = LLConfigColorStyleHack;
    
    // Set default suspension ball attributes.
    _suspensionBallWidth = 70;
    _normalAlpha = 0.9;
    _activeAlpha = 1.0;
    _suspensionBallMoveable = YES;
    
    // Show LLDebugTool's log.
    _showDebugToolLog = YES;
    _autoCheckDebugToolVersion = YES;
    
    // Set log style.
    _logStyle = LLConfigLogDetail;
    
    // Set default window's style.
    _windowStyle = LLConfigWindowSuspensionBall;
    
    // Set default availables.
    _availables = LLConfigAvailableAll;
    
    // Update color.
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
        case LLConfigColorStyleCustom:{
            
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

#pragma mark - DEPRECATED
- (void)setUseSystemColor:(BOOL)useSystemColor {
    if (_useSystemColor != useSystemColor) {
        _useSystemColor = useSystemColor;
        if (useSystemColor && (self.colorStyle != LLConfigColorStyleSimple)) {
            self.colorStyle = LLConfigColorStyleSimple;
        }
    }
}

@end
