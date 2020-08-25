//
//  LLSettingManager.h
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

NS_ASSUME_NONNULL_BEGIN

/// Setting manager.
@interface LLSettingManager : NSObject

/// Double click.
@property (nonatomic, strong) NSNumber *doubleClickAction;

/// Color style
@property (nonatomic, strong) NSNumber *colorStyle;

/// Entry window style.
@property (nonatomic, strong) NSNumber *entryWindowStyle;

/// Log style.
@property (nonatomic, strong) NSNumber *logStyle;

/// Shrink to edge when inactive.
@property (nonatomic, strong) NSNumber *shrinkToEdgeWhenInactive;

/// Shake to hide.
@property (nonatomic, strong) NSNumber *shakeToHide;

/// Magnifier zoom level.
@property (nonatomic, strong) NSNumber *magnifierZoomLevel;

/// Magnifier size.
@property (nonatomic, strong) NSNumber *magnifierSize;

/// Show widget border or not.
@property (nonatomic, strong) NSNumber *showWidgetBorder;

/// Hierarchy function ignore private class or not.
@property (nonatomic, strong) NSNumber *hierarchyIgnorePrivateClass;

/// Web view class.
@property (nonatomic, copy) NSString *webViewClass;

/// Last web view url.
@property (nonatomic, copy) NSString *lastWebViewUrl;

/// Mock location enable or not.
@property (nonatomic, strong) NSNumber *mockLocationEnable;

/// Last mock location latitude.
@property (nonatomic, strong) NSNumber *mockLocationLatitude;

/// Last mock location longitude.
@property (nonatomic, strong) NSNumber *mockLocationLongitude;

/// Last mock route file path.
@property (nonatomic, copy) NSString *mockRouteFilePath;

/// Last mock route file display name.
@property (nonatomic, copy) NSString *mockRouteFileName;

/// Shared instance.
+ (instancetype)shared;

/// Set up config.
- (void)prepareForConfig;

@end

NS_ASSUME_NONNULL_END
