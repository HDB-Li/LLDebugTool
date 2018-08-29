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
    LLConfigAvailableAll        = 0xFF,
    
    // Quick options
    LLConfigAvailableNoneNetwork    = 0xFF - (1 << 0),
    LLConfigAvailableNoneLog        = 0xFF - (1 << 1),
    LLConfigAvailableNoneCrash      = 0xFF - (1 << 2),
    LLConfigAvailableNoneAppInfo    = 0xFF - (1 << 3),
    LLConfigAvailableNoneSandbox    = 0xFF - (1 << 4),
    LLConfigAvailableNoneScreenshot = 0xFF - (1 << 5),
};

UIKIT_EXTERN NSNotificationName _Nonnull const LLConfigDidUpdateColorStyleNotificationName;
UIKIT_EXTERN NSNotificationName _Nonnull const LLConfigDidUpdateWindowStyleNotificationName;

/**
 Config file. Must config properties before [LLDebugTool enable].
 */
@interface LLConfig : NSObject

/**
 Singleton to get/save config.
 
 @return Singleton
 */
+ (instancetype _Nonnull)sharedConfig;

#pragma mark - StautsBarSytle
/**
 Window's statusBarStyle when show.
 */
@property (assign , nonatomic , readonly) UIStatusBarStyle statusBarStyle;

#pragma mark - Color
/**
 Use preset the color configuration. For details, please see LLConfigColorStyle.
 */
@property (assign , nonatomic) LLConfigColorStyle colorStyle;

/**
 UIControl's background color. Default is [UIColor blackColor]..
 */
@property (strong , nonatomic , nonnull , readonly) UIColor *backgroundColor;

/**
 UIControl's text color. Default is [UIColor greenColor].
 */
@property (strong , nonatomic , nonnull , readonly) UIColor *textColor;

/**
 System tint color.
 */
@property (strong , nonatomic , readonly , nonnull) UIColor *systemTintColor;

/**
 Customizing the custom color configuration, will auto set colorStyle to LLConfigColorStyleCustom.
 */
- (void)configBackgroundColor:(UIColor *_Nonnull)backgroundColor textColor:(UIColor *_Nonnull)textColor statusBarStyle:(UIStatusBarStyle)statusBarStyle;

#pragma mark - Date Formatter
/**
 Date Format Style. Use to recording time when create model. Default is "yyyy-MM-dd HH:mm:ss".
 If this value is modified, the old data is not compatible.
 */
@property (copy , nonatomic , nonnull) NSString *dateFormatter;

#pragma mark - Window
/**
 Suspension ball width, must greater than 70.
 */
@property (assign , nonatomic) CGFloat suspensionBallWidth;

/**
 Suspension Ball alpha(not active), default is 0.9.
 */
@property (assign , nonatomic) CGFloat normalAlpha;

/**
 Suspension Ball alpha(active), default is 1.0.
 */
@property (assign , nonatomic) CGFloat activeAlpha;

/**
 Whether the suspension ball can be moved, default is YES.
 */
@property (assign , nonatomic) BOOL suspensionBallMoveable;

#pragma mark - User Identity
/**
 Tag user name is used to create the crash/network/log model.
 */
@property (copy , nonatomic , nullable) NSString *userIdentity;

#pragma mark - Network
/**
 Observer network in hosts, ignore others.
 */
@property (strong , nonatomic , nullable) NSArray <NSString *>*hosts;

#pragma mark - Settings
/**
 Whether to print LLDebugTool's log event. Default is YES.
 */
@property (assign , nonatomic) BOOL showDebugToolLog;

/**
 Customize the log style. Default is LLConfigLogDetail.
 */
@property (assign , nonatomic) LLConfigLogStyle logStyle;

/**
 Window style. Decide how the Window displays. Default is LLConfigWindowSuspensionBall.
 */
@property (assign , nonatomic) LLConfigWindowStyle windowStyle;

/**
 Available features. Default is LLConfigAvailableAll.
 It can affect tabbar's display and features on or off. If this value is modified at run time, will automatic called [LLDebugTool stopWorking] and [LLDebugTool startWorking] again to start or close the features, also the tabbar will be updated automatically the next time it appears.
 */
@property (assign , nonatomic) LLConfigAvailableFeature availables;

#pragma mark - Folder Path
/**
 The folder path for LLDebugTool. The database is created and read in this directory.
 Default path is ../Documents/LLDebugTool/.
 */
@property (copy , nonatomic , nonnull) NSString *folderPath;

#pragma mark - Extension
/**
 Image resource bundle.
 */
@property (strong , nonatomic , readonly , nullable) NSBundle *imageBundle;

/**
 XIB resource bundle.
 */
@property (strong , nonatomic , readonly , nullable) NSBundle *XIBBundle;

#pragma mark - DEPRECATED
/**
 Use system color or not. If YES, window will draw by system tint color. If NO, window will draw by [backgroundColor] and [textColor].
 Default is NO.
 */
@property (assign , nonatomic) BOOL useSystemColor DEPRECATED_MSG_ATTRIBUTE("Unsupported, Use colorStyle LLConfigColorStyleSimple replace.");;

@end
