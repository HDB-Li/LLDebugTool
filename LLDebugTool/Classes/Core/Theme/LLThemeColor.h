//
//  LLThemeColor.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Theme color config.
@interface LLThemeColor : NSObject

/**
 Primary color, use on text and border.
 */
@property (nonatomic, copy, readonly) UIColor *primaryColor;

/**
 Background color, use on background.
 */
@property (nonatomic, copy, readonly) UIColor *backgroundColor;

/**
 Container color, use on containerView, should different with backgroundColor.
 */
@property (nonatomic, copy, readonly) UIColor *containerColor;

/**
 PlaceHolder color, use on textField/textView, should different with backgroundColor.
 */
@property (nonatomic, copy, readonly) UIColor *placeHolderColor;

/**
 Window's statusBarStyle when show.
 */
@property (nonatomic, assign, readonly) UIStatusBarStyle statusBarStyle;

/// Hack theme color. Green backgroundColor and #333333 textColor.
+ (LLThemeColor *)hackThemeColor;

/// Simple theme color. White backgroundColor and darkTextColor textColor.
+ (LLThemeColor *)simpleThemeColor;

/// System theme color. White backgroundColor and system tint textColor.
+ (LLThemeColor *)systemThemeColor;

/// Grass theme color. #13773D backgroundColor and #FFF0A5 textColor.
+ (LLThemeColor *)grassThemeColor;

/// Homebrew theme color. Black backgroundColor and #28FE14 textColor.
+ (LLThemeColor *)homebrewThemeColor;

/// Man page theme color. #FEF49C backgroundColor and black textColor.
+ (LLThemeColor *)manPageThemeColor;

/// Novel theme color. #DFDBC3 backgroundColor and #3B2322 textColor.
+ (LLThemeColor *)novelThemeColor;

/// Ocean theme color.  #224FBC backgroundColor and white textColor.
+ (LLThemeColor *)oceanThemeColor;

/// Pro theme color. Black backgroundColor and #F2F2F2 textColor.
+ (LLThemeColor *)proThemeColor;

/// Red sands theme color. #7A251E backgroundColor and #D7C9A7 textColor.
+ (LLThemeColor *)redSandsThemeColor;

/// Silver aerogel theme color. #929292 backgroundColor and black textColor.
+ (LLThemeColor *)silverAerogelThemeColor;

/// Solid colors theme color. White backgroundColor and black textColor.
+ (LLThemeColor *)solidColorsThemeColor;

/// Initial method.
/// @param primaryColor Primary color.
/// @param backgroundColor Background color.
/// @param statusBarStyle Status bar style to display.
- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle;

/// Initial method.
/// @param primaryColor Primary color.
/// @param backgroundColor Backround color.
- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor;

/// Class initial method.
/// @param primaryColor Primary color.
/// @param backgroundColor Background color.
/// @param statusBarStyle Status bar style to display.
+ (instancetype)colorWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor statusBarStyle:(UIStatusBarStyle)statusBarStyle;

/// Class initial method.
/// @param primaryColor Primary color.
/// @param backgroundColor Background color.
+ (instancetype)colorWithPrimaryColor:(UIColor *)primaryColor backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
