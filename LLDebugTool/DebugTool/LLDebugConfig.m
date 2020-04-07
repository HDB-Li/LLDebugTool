//
//  LLDebugConfig.m
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

#import "LLDebugConfig.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLDebugTool.h"
#import "LLFactory.h"
#import "LLInternalMacros.h"
#import "LLRouter.h"
#import "LLThemeColor.h"
#import "LLThemeManager.h"
#import "LLTool.h"

#import "LLRouter+Location.h"
#import "LLRouter+ShortCut.h"

static LLDebugConfig *_instance = nil;

NSNotificationName const LLDebugToolUpdateWindowStyleNotification = @"LLDebugToolUpdateWindowStyleNotification";

@implementation LLDebugConfig

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLDebugConfig alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)configPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _colorStyle = LLDebugConfigColorStyleCustom;
    [LLThemeManager shared].themeColor = [LLThemeColor colorWithPrimaryColor:primaryColor backgroundColor:backgroundColor statusBarStyle:statusBarStyle];
}

- (void)addMockRouteFile:(NSString *)filePath {
    [LLRouter addMockRouteFile:filePath];
}

- (void)addMockRouteDirectory:(NSString *)fileDirectory {
    [LLRouter addMockRouteDirectory:fileDirectory];
}

- (void)registerShortCutWithName:(NSString *)name action:(NSString * (^)(void))action {
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
    [self setUpBundle];

    // Set date formatter string.
    _dateFormatter = @"yyyy-MM-dd HH:mm:ss";

    // Set default color style.
    _colorStyle = LLDebugConfigColorStyleHack;

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
    _entryWindowStyle = LLDebugConfigEntryWindowStyleBall;

    // Start next time.
    _startWorkingNextTime = YES;
}

- (void)setUpBundle {
    // Find in main bundle.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LLDebugTool" ofType:@"bundle"];
    if (path) {
        _imageBundle = [NSBundle bundleWithPath:path];
        return;
    }

    // Find in dynamic framework.
    if ([NSBundle bundleForClass:self.class] != [NSBundle mainBundle]) {
        path = [[NSBundle bundleForClass:self.class] pathForResource:@"LLDebugTool" ofType:@"bundle"];
        if (path) {
            _imageBundle = [NSBundle bundleWithPath:path];
            return;
        }
    }

    // Find in embed frameworks.
    path = [[NSBundle mainBundle] pathForResource:@"Frameworks/LLDebugTool.framework/LLDebugTool" ofType:@"bundle"];
    if (path) {
        _imageBundle = [NSBundle bundleWithPath:path];
        return;
    }

    if (!_imageBundle) {
        [LLTool log:@"Failed to load the image bundle"];
    }
}

#pragma mark - Getters and setters
- (void)setColorStyle:(LLDebugConfigColorStyle)colorStyle {
    if (_colorStyle != colorStyle) {
        _colorStyle = colorStyle;
        [[LLThemeManager shared] updateWithColorStyle:colorStyle];
    }
}

- (void)setEntryWindowStyle:(LLDebugConfigEntryWindowStyle)entryStyle {
    LLDebugConfigEntryWindowStyle style = entryStyle;
    if (@available(iOS 13.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (entryStyle == LLDebugConfigEntryWindowStyleNetBar) {
            style = LLDebugConfigEntryWindowStyleLeading;
        } else if (entryStyle == LLDebugConfigEntryWindowStylePowerBar) {
            style = LLDebugConfigEntryWindowStyleTrailing;
        }
#pragma clang diagnostic pop
    }
    if (_entryWindowStyle != style) {
        _entryWindowStyle = style;
        [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolUpdateWindowStyleNotification object:nil userInfo:nil];
    }
}

- (void)setEntryWindowBallWidth:(CGFloat)entryWindowBallWidth {
    CGFloat max = LL_MAX(entryWindowBallWidth, kLLEntryWindowMinBallWidth);
    _entryWindowBallWidth = LL_MIN(max, kLLEntryWindowMaxBallWidth);
}

- (void)setEntryWindowDisplayPercent:(CGFloat)entryWindowDisplayPercent {
    CGFloat max = LL_MAX(entryWindowDisplayPercent, kLLEntryWindowMinDisplayPercent);
    _entryWindowDisplayPercent = LL_MIN(max, kLLEntryWindowMaxDisplayPercent);
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
