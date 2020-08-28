//
//  LLRouter+Setting.m
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

#import "LLRouter+Setting.h"

#ifdef LLDEBUGTOOL_SETTING
#import "LLSettingManager.h"
#endif

@implementation LLRouter (Setting)

+ (void)setShowWidgetBorder:(BOOL)isShow {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].showWidgetBorder = @(isShow);
#endif
}

+ (void)setEntryWindowStyle:(LLDebugConfigEntryWindowStyle)style {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].entryWindowStyle = @(style);
#endif
}

+ (void)setDefaultHtmlUrl:(NSString *)url {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].defaultHtmlUrl = url;
#endif
}

+ (void)setWebViewClass:(NSString *)aClass {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].webViewClass = aClass;
#endif
}

+ (void)setMockLocation:(BOOL)mockLocation {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].mockLocation = @(mockLocation);
#endif
}

+ (void)setMockLocationLatitude:(double)latitude {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].mockLocationLatitude = @(latitude);
#endif
}

+ (void)setMockLocationLongitude:(double)longitude {
#ifdef LLDEBUGTOOL_SETTING
    [LLSettingManager shared].mockLocationLongitude = @(longitude);
#endif
}

@end
