//
//  LLSettingHelperDelegate.h
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

#import "LLComponentHelperDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LLSettingHelperDelegate <LLComponentHelperDelegate>

#pragma mark - Tool
/// Double click.
@property (nonatomic, strong) NSNumber *doubleClickAction;

/// Color style
@property (nonatomic, strong) NSNumber *colorStyle;

/// Log style.
@property (nonatomic, strong) NSNumber *logStyle;

#pragma mark - Entry
/// Entry window style.
@property (nonatomic, strong, nullable) NSNumber *entryWindowStyle;

/// Shrink to edge when inactive.
@property (nonatomic, strong) NSNumber *shrinkToEdgeWhenInactive;

/// Shake to hide.
@property (nonatomic, strong) NSNumber *shakeToHide;

#pragma mark - Hierarchy
/// Hierarchy function ignore private class or not.
@property (nonatomic, strong) NSNumber *hierarchyIgnorePrivateClass;

#pragma mark - Magnifier
/// Magnifier zoom level.
@property (nonatomic, strong) NSNumber *magnifierZoomLevel;

/// Magnifier size.
@property (nonatomic, strong) NSNumber *magnifierSize;

#pragma mark - Widget border
/// Show widget border or not.
@property (nonatomic, strong, nullable) NSNumber *showWidgetBorder;

#pragma mark - Html
/// Last web view url.
@property (nonatomic, copy, nullable) NSString *defaultHtmlUrl;

/// Web view class.
@property (nonatomic, copy, nullable) NSString *webViewClass;

#pragma mark - Location
/// Mock location enable or not.
@property (nonatomic, strong, nullable) NSNumber *mockLocation;

/// Last mock location latitude.
@property (nonatomic, strong, nullable) NSNumber *mockLocationLatitude;

/// Last mock location longitude.
@property (nonatomic, strong, nullable) NSNumber *mockLocationLongitude;

@end

NS_ASSUME_NONNULL_END
