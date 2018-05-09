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
#define LLCONFIG_CUSTOM_COLOR ([LLConfig sharedConfig].useSystemColor == NO)
#define LLCONFIG_TEXT_COLOR [LLConfig sharedConfig].textColor
#define LLCONFIG_BACKGROUND_COLOR [LLConfig sharedConfig].backgroundColor
#endif


/**
 Color style enum

 - LLConfigColorStyleHack: Green backgroundColor and white textColor.
 - LLConfigColorStyleSimple: White backgroundColor and darkTextColor textColor.
 - LLConfigColorStyleSystem: White backgroundColor and system tint textColor.
 */
typedef NS_ENUM(NSUInteger, LLConfigColorStyle) {
    LLConfigColorStyleHack,
    LLConfigColorStyleSimple,
    LLConfigColorStyleSystem,
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
 UIControl's background color. Default is [UIColor blackColor]. Set this property will also change useSystemColor to NO.
 */
@property (strong , nonatomic , nonnull , readonly) UIColor *backgroundColor;

/**
 UIControl's text color. Default is [UIColor greenColor]. Set this property will also change useSystemColor to NO.
 */
@property (strong , nonatomic , nonnull , readonly) UIColor *textColor;

/**
 Use system color or not. If YES, window will draw by system tint color. If NO, window will draw by [backgroundColor] and [textColor].
 Default is NO.
 */
@property (assign , nonatomic) BOOL useSystemColor;

/**
 System tint color.
 */
@property (strong , nonatomic , readonly , nonnull) UIColor *systemTintColor;

/**
 Customizing the custom color configuration.
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

#pragma mark - Extension
/**
 Image resource bundle name.
 */
@property (copy , nonatomic , readonly , nonnull) NSString *bundlePath;

@end
