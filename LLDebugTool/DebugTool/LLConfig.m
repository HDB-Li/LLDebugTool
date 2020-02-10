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

#import "LLThemeManager.h"
#import "LLThemeColor.h"
#import "LLDebugTool.h"
#import "LLFactory.h"
#import "LLRouter.h"
#import "LLConfig.h"
#import "LLConst.h"
#import "LLTool.h"

#import "LLRouter+Location.h"
#import "LLRouter+ShortCut.h"

static LLConfig *_instance = nil;

NSNotificationName const LLConfigDidUpdateWindowStyleNotificationName = @"LLConfigDidUpdateWindowStyleNotificationName";

@implementation LLConfig

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLConfig alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)configPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _colorStyle = LLConfigColorStyleCustom;
    [LLThemeManager shared].themeColor = [LLThemeColor colorWithPrimaryColor:primaryColor backgroundColor:backgroundColor statusBarStyle:statusBarStyle];
}

- (void)addMockRouteFile:(NSString *)filePath {
    [LLRouter addMockRouteFile:filePath];
}

- (void)addMockRouteDirectory:(NSString *)fileDirectory {
    [LLRouter addMockRouteDirectory:fileDirectory];
}

- (void)registerShortCutWithName:(NSString *)name action:(NSString *_Nullable(^)(void))action {
    [LLRouter registerShortCutWithName:name action:action];
}

#pragma mark - Primary
/**
 Initialize something.
 */
- (void)initial {
    // Set internal
    _showDebugToolLog = YES;
    
    // Set default values
    // Set folder Path
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _folderPath = [doc stringByAppendingPathComponent:@"LLDebugTool"];
    
    // Set XIB resources.
    NSString *imageBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"LLDebugTool" ofType:@"bundle"];
    _imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    if (!_imageBundle) {
        [LLTool log:@"Failed to load the image bundle"];
    }
    
    // Set date formatter string.
    _dateFormatter = @"yyyy-MM-dd HH:mm:ss";
    
    // Set default color style.
    _colorStyle = LLConfigColorStyleHack;
    
    // Set default suspension ball attributes.
    _entryWindowBallWidth = kLLEntryWindowBallWidth;
    _entryWindowDisplayPercent = kLLEntryWindowDisplayPercent;
    _entryWindowFirstDisplayPosition = CGPointMake(kLLEntryWindowFirstDisplayPositionX, kLLEntryWindowFirstDisplayPositionY);
    _inactiveAlpha = kLLInactiveAlpha;
    _activeAlpha = kLLActiveAlpha;
    _shrinkToEdgeWhenInactive = YES;
    _shakeToHide = YES;
    
    // Set default magnifier properties.
    _magnifierZoomLevel = kLLMagnifierWindowZoomLevel;
    _magnifierSize = kLLMagnifierWindowSize;

    // Set hierarchy
    _hierarchyIgnorePrivateClass = YES;
    // Show LLDebugTool's log.
    _autoCheckDebugToolVersion = YES;
    
    // Set location
    _mockRouteTimeInterval = kLLDefaultMockRouteTimeInterval;

    // Click action
    _clickAction = LLDebugToolActionFunction;
    _doubleClickAction = LLDebugToolActionHierarchy;
    
    // Set default window's style.
    _entryWindowStyle = LLConfigEntryWindowStyleBall;
}

#pragma mark - Getters and setters
- (void)setColorStyle:(LLConfigColorStyle)colorStyle {
    if (_colorStyle != colorStyle) {
        _colorStyle = colorStyle;
        switch (colorStyle) {
            case LLConfigColorStyleHack: {
                [LLThemeManager shared].themeColor = [LLThemeColor hackThemeColor];
            }
                break;
            case LLConfigColorStyleSimple: {
                [LLThemeManager shared].themeColor = [LLThemeColor simpleThemeColor];
            }
                break;
            case LLConfigColorStyleSystem: {
                [LLThemeManager shared].themeColor = [LLThemeColor systemThemeColor];
            }
                break;
            case LLConfigColorStyleGrass: {
                [LLThemeManager shared].themeColor = [LLThemeColor grassThemeColor];
            }
                break;
            case LLConfigColorStyleHomebrew: {
                [LLThemeManager shared].themeColor = [LLThemeColor homebrewThemeColor];
            }
                break;
            case LLConfigColorStyleManPage: {
                [LLThemeManager shared].themeColor = [LLThemeColor manPageThemeColor];
            }
                break;
            case LLConfigColorStyleNovel: {
                [LLThemeManager shared].themeColor = [LLThemeColor novelThemeColor];
            }
                break;
            case LLConfigColorStyleOcean: {
                [LLThemeManager shared].themeColor = [LLThemeColor oceanThemeColor];
            }
                break;
            case LLConfigColorStylePro: {
                [LLThemeManager shared].themeColor = [LLThemeColor proThemeColor];
            }
                break;
            case LLConfigColorStyleRedSands: {
                [LLThemeManager shared].themeColor = [LLThemeColor redSandsThemeColor];
            }
                break;
            case LLConfigColorStyleSilverAerogel: {
                [LLThemeManager shared].themeColor = [LLThemeColor silverAerogelThemeColor];
            }
                break;
            case LLConfigColorStyleSolidColors: {
                [LLThemeManager shared].themeColor = [LLThemeColor solidColorsThemeColor];
            }
                break;
            case LLConfigColorStyleCustom: {
                [LLTool log:@"Can't manual set custom color style, if you want to use custom color style, used themeColor property"];
                [LLThemeManager shared].themeColor = [LLThemeColor hackThemeColor];
            }
                break;
        }
    }
}

- (void)setEntryWindowStyle:(LLConfigEntryWindowStyle)entryStyle {
    if (@available(iOS 13.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (entryStyle == LLConfigEntryWindowStyleNetBar) {
            entryStyle = LLConfigEntryWindowStyleLeading;
        } else if (entryStyle == LLConfigEntryWindowStylePowerBar) {
            entryStyle = LLConfigEntryWindowStyleTrailing;
        }
#pragma clang diagnostic pop
    }
    if (_entryWindowStyle != entryStyle) {
        _entryWindowStyle = entryStyle;
        [[NSNotificationCenter defaultCenter] postNotificationName:LLConfigDidUpdateWindowStyleNotificationName object:nil userInfo:nil];
    }
}

- (void)setEntryWindowBallWidth:(CGFloat)entryWindowBallWidth {
    _entryWindowBallWidth = MIN(MAX(entryWindowBallWidth, kLLEntryWindowMinBallWidth), kLLEntryWindowMaxBallWidth);
}

- (void)setEntryWindowDisplayPercent:(CGFloat)entryWindowDisplayPercent {
    _entryWindowDisplayPercent = MIN(MAX(entryWindowDisplayPercent, kLLEntryWindowMinDisplayPercent), kLLEntryWindowMaxDisplayPercent);
}

- (void)setMagnifierSize:(NSInteger)magnifierSize {
    if (_magnifierSize != magnifierSize) {
        if (magnifierSize % 2 == 0) {
            _magnifierSize = magnifierSize + 1;
        } else {
            _magnifierSize = magnifierSize;
        }
    }
}

@end
