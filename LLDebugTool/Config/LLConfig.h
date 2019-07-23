//
//  LLConfig.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef LLCONFIG_CUSTOM_COLOR
#define LLCONFIG_CUSTOM_COLOR (YES)
#endif

#define LLCONFIG_TEXT_COLOR [LLConfig sharedConfig].textColor
#define LLCONFIG_BACKGROUND_COLOR [LLConfig sharedConfig].backgroundColor

/**
 Color style enum
 
 - LLConfigColorStyleHack: Green backgroundColor and white textColor.
 - LLConfigColorStyleSimple: White backgroundColor and darkTextColor textColor.
 - LLConfigColorStyleSystem: White backgroundColor and system tint textColor.
 - LLConfigColorStyleCustom: Use custom backgroundColor and textColor.
 */
typedef NS_ENUM(NSUInteger, LLConfigColorStyle) {
    LLConfigColorStyleHack,
    LLConfigColorStyleSimple,
    LLConfigColorStyleSystem,
    LLConfigColorStyleCustom,
};

/**
 Log Level. It can be used for filter.
 
 - LLConfigLogLevelDefault: Use to save message or note.
 - LLConfigLogLevelAlert: Use to save alert message.
 - LLConfigLogLevelWarning: Use to save warning message.
 - LLConfigLogLevelError: Use to save error message.
 */
typedef NS_ENUM(NSUInteger, LLConfigLogLevel) {
    LLConfigLogLevelDefault,
    LLConfigLogLevelAlert,
    LLConfigLogLevelWarning,
    LLConfigLogLevelError,
};

/**
 Window style. Decide how the Window displays.
 
 - LLConfigWindowSuspensionBall: Show as a suspension ball. Moveable and clickable.
 - LLConfigWindowPowerBar: Show at power bar. Unmoveable but clickable.
 - LLConfigWindowNetBar: Show at network bar. Unmoveable but clickable.
 */
typedef NS_ENUM(NSUInteger, LLConfigWindowStyle) {
    LLConfigWindowSuspensionBall,
    LLConfigWindowPowerBar,
    LLConfigWindowNetBar,
};

/**
 Log style for [LLDebugTool logInFile...]. Customize the log you want.
 
 - LLConfigLogDetail: Show all detail info. Contain event, file, line, func, date and desc.
 - LLConfigLogFileFuncDesc : Show with event, file, func and desc.
 - LLConfigLogFileDesc : Show with event, file and desc.
 - LLConfigLogNormal: Show as system NSLog
 - LLConfigLogNone: Don't show anything.
 */
typedef NS_ENUM(NSUInteger, LLConfigLogStyle) {
    LLConfigLogDetail,
    LLConfigLogFileFuncDesc,
    LLConfigLogFileDesc,
    LLConfigLogNormal,
    LLConfigLogNone,
};

/**
 Customize available Features.
 
 - LLConfigAvailableNetwork: Network functions available.
 - LLConfigAvailableLog: Log functions avalable.
 - LLConfigAvailableCrash: Crash functions available.
 - LLConfigAvailableAppInfo: AppInfo functions available.
 - LLConfigAvailableSandbox: Sandbox functions available.
 - LLConfigAvailableScreenshot: Screenshot functions available.
 - LLConfigAvailableAll: All available.
 */
typedef NS_OPTIONS(NSUInteger, LLConfigAvailableFeature) {
    LLConfigAvailableNetwork    = 1 << 0,
    LLConfigAvailableLog        = 1 << 1,
    LLConfigAvailableCrash      = 1 << 2,
    LLConfigAvailableAppInfo    = 1 << 3,
    LLConfigAvailableSandbox    = 1 << 4,
    LLConfigAvailableScreenshot = 1 << 5,
    LLConfigAvailableHierarchy  = 1 << 6,
    LLConfigAvailableAll        = 0xFF,
    
    // Quick options
    LLConfigAvailableNoneNetwork    = 0xFF - (1 << 0),
    LLConfigAvailableNoneLog        = 0xFF - (1 << 1),
    LLConfigAvailableNoneCrash      = 0xFF - (1 << 2),
    LLConfigAvailableNoneAppInfo    = 0xFF - (1 << 3),
    LLConfigAvailableNoneSandbox    = 0xFF - (1 << 4),
    LLConfigAvailableNoneScreenshot = 0xFF - (1 << 5),
    LLConfigAvailableNoneHierarchy  = 0xFF - (1 << 6),
};

FOUNDATION_EXPORT NSNotificationName _Nonnull const LLConfigDidUpdateColorStyleNotificationName;
FOUNDATION_EXPORT NSNotificationName _Nonnull const LLConfigDidUpdateWindowStyleNotificationName;

NS_ASSUME_NONNULL_BEGIN
/**
 Config file. Must config properties before [LLDebugTool enable].
 */
@interface LLConfig : NSObject

/**
 Singleton to get/save config.
 
 @return Singleton
 */
+ (instancetype)sharedConfig;

#pragma mark - StautsBarSytle
/**
 Window's statusBarStyle when show.
 */
@property (nonatomic, assign, readonly) UIStatusBarStyle statusBarStyle;

#pragma mark - Color
/**
 Use preset the color configuration. For details, please see LLConfigColorStyle.
 */
@property (nonatomic, assign) LLConfigColorStyle colorStyle;

/**
 UIControl's background color. Default is [UIColor blackColor]..
 */
@property (nonatomic, strong, readonly) UIColor *backgroundColor;

/**
 UIControl's text color. Default is [UIColor greenColor].
 */
@property (nonatomic, strong, readonly) UIColor *textColor;

/**
 System tint color.
 */
@property (nonatomic, strong, readonly) UIColor *systemTintColor;

/**
 Customizing the custom color configuration, will auto set colorStyle to LLConfigColorStyleCustom.
 */
- (void)configBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor statusBarStyle:(UIStatusBarStyle)statusBarStyle;

#pragma mark - Date Formatter
/**
 Date Format Style. Use to recording time when create model. Default is "yyyy-MM-dd HH:mm:ss".
 If this value is modified, the old data is not compatible.
 */
@property (nonatomic, copy) NSString *dateFormatter;

#pragma mark - Window
/**
 Suspension ball width, must greater than 70.
 */
@property (nonatomic, assign) CGFloat suspensionBallWidth;

/**
 Suspension Ball alpha(not active), default is 0.9.
 */
@property (nonatomic, assign) CGFloat normalAlpha;

/**
 Suspension Ball alpha(active), default is 1.0.
 */
@property (nonatomic, assign) CGFloat activeAlpha;

/**
 Whether the suspension ball can be moved, default is YES.
 */
@property (nonatomic, assign) BOOL suspensionBallMoveable;

#pragma mark - User Identity
/**
 Tag user name is used to create the crash/network/log model.
 */
@property (nonatomic, copy, nullable) NSString *userIdentity;

#pragma mark - Network
/**
 Observer network in hosts, ignore others.
 */
@property (nonatomic, strong, nullable) NSArray <NSString *>*hosts;

#pragma mark - Settings
/**
 Whether to print LLDebugTool's log event. Default is YES.
 */
@property (nonatomic, assign) BOOL showDebugToolLog;

/**
 Whether check LLDebugTool has new version.
 */
@property (nonatomic, assign) BOOL autoCheckDebugToolVersion;

/**
 Customize the log style. Default is LLConfigLogDetail.
 */
@property (nonatomic, assign) LLConfigLogStyle logStyle;

/**
 Window style. Decide how the Window displays. Default is LLConfigWindowSuspensionBall.
 */
@property (nonatomic, assign) LLConfigWindowStyle windowStyle;

/**
 Available features. Default is LLConfigAvailableAll.
 It can affect tabbar's display and features on or off. If this value is modified at run time, will automatic called [LLDebugTool stopWorking] and [LLDebugTool startWorking] again to start or close the features, also the tabbar will be updated automatically the next time it appears.
 */
@property (nonatomic, assign) LLConfigAvailableFeature availables;

#pragma mark - Folder Path
/**
 The folder path for LLDebugTool. The database is created and read in this directory.
 Default path is ../Documents/LLDebugTool/.
 */
@property (nonatomic, copy) NSString *folderPath;

#pragma mark - Extension
/**
 Image resource bundle.
 */
@property (nonatomic, strong, readonly, nullable) NSBundle *imageBundle;

/**
 XIB resource bundle.
 */
@property (nonatomic, strong, readonly, nullable) NSBundle *XIBBundle;

#pragma mark - DEPRECATED
/**
 Use system color or not. If YES, window will draw by system tint color. If NO, window will draw by [backgroundColor] and [textColor].
 Default is NO.
 */
@property (nonatomic, assign) BOOL useSystemColor DEPRECATED_MSG_ATTRIBUTE("Unsupported, Use colorStyle LLConfigColorStyleSimple replace.");;

@end

NS_ASSUME_NONNULL_END
