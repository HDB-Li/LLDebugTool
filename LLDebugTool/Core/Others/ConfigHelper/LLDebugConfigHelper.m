//
//  LLDebugConfigHelper.m
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

#import "LLDebugConfigHelper.h"

#import "LLDebugConfig.h"
#import "LLFunctionItemModel.h"
#import "LLThemeManager.h"

#import "UIColor+LL_Utils.h"

@implementation LLDebugConfigHelper

#pragma mark - Description
+ (NSString *)colorStyleDetailDescription {
    return [self colorStyleDetailDescription:[LLDebugConfig shared].colorStyle];
}

+ (NSString *)colorStyleDetailDescription:(LLDebugConfigColorStyle)colorStyle {
    switch (colorStyle) {
        case LLDebugConfigColorStyleHack:
            return @"Hack";
        case LLDebugConfigColorStyleSimple:
            return @"Simple";
        case LLDebugConfigColorStyleSystem:
            return @"System";
        case LLDebugConfigColorStyleGrass:
            return @"Grass";
        case LLDebugConfigColorStyleHomebrew:
            return @"Homebrew";
        case LLDebugConfigColorStyleManPage:
            return @"Man Page";
        case LLDebugConfigColorStyleNovel:
            return @"Novel";
        case LLDebugConfigColorStyleOcean:
            return @"Ocean";
        case LLDebugConfigColorStylePro:
            return @"Pro";
        case LLDebugConfigColorStyleRedSands:
            return @"Red Sands";
        case LLDebugConfigColorStyleSilverAerogel:
            return @"Silver Aerogel";
        case LLDebugConfigColorStyleSolidColors:
            return @"Solid Colors";
        case LLDebugConfigColorStyleCustom:
            return [NSString stringWithFormat:@"%@\n%@", [[LLThemeManager shared].primaryColor LL_description], [[LLThemeManager shared].backgroundColor LL_description]];
    }
}

+ (NSString *)colorStyleDescription {
    return [self colorStyleDescription:[LLDebugConfig shared].colorStyle];
}

+ (NSString *)colorStyleDescription:(LLDebugConfigColorStyle)colorStyle {
    switch (colorStyle) {
        case LLDebugConfigColorStyleHack:
            return @"Hack";
        case LLDebugConfigColorStyleSimple:
            return @"Simple";
        case LLDebugConfigColorStyleSystem:
            return @"System";
        case LLDebugConfigColorStyleGrass:
            return @"Grass";
        case LLDebugConfigColorStyleHomebrew:
            return @"Homebrew";
        case LLDebugConfigColorStyleManPage:
            return @"Man Page";
        case LLDebugConfigColorStyleNovel:
            return @"Novel";
        case LLDebugConfigColorStyleOcean:
            return @"Ocean";
        case LLDebugConfigColorStylePro:
            return @"Pro";
        case LLDebugConfigColorStyleRedSands:
            return @"Red Sands";
        case LLDebugConfigColorStyleSilverAerogel:
            return @"Silver Aerogel";
        case LLDebugConfigColorStyleSolidColors:
            return @"Solid Colors";
        case LLDebugConfigColorStyleCustom:
            return @"Custom";
    }
}

+ (NSString *)entryWindowStyleDescription {
    return [self entryWindowStyleDescription:[LLDebugConfig shared].entryWindowStyle];
}

+ (NSString *)entryWindowStyleDescription:(LLDebugConfigEntryWindowStyle)windowStyle {
    switch (windowStyle) {
        case LLDebugConfigEntryWindowStyleBall:
            return @"Ball";
        case LLDebugConfigEntryWindowStyleTitle:
            return @"Title";
        case LLDebugConfigEntryWindowStyleLeading:
            return @"Leading";
        case LLDebugConfigEntryWindowStyleTrailing:
            return @"Trailing";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLDebugConfigEntryWindowStyleNetBar:
            return @"Net Bar";
        case LLDebugConfigEntryWindowStylePowerBar:
            return @"Power Bar";
#pragma clang diagnostic pop
    }
}

+ (NSString *)statusBarStyleDescription {
    return [self statusBarStyleDescription:[LLThemeManager shared].statusBarStyle];
}

+ (NSString *)statusBarStyleDescription:(UIStatusBarStyle)statusBarStyle {
    switch (statusBarStyle) {
        case UIStatusBarStyleDefault:
            return @"Default";
        case UIStatusBarStyleLightContent:
            return @"Light Content";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case UIStatusBarStyleBlackOpaque:
            return @"Black Opaque";
#pragma pop
#ifdef __IPHONE_13_0
        case UIStatusBarStyleDarkContent:
            return @"Dark Content";
#endif
    }
    return nil;
}

+ (NSString *)logStyleDescription {
    return [self logStyleDescription:[LLDebugConfig shared].logStyle];
}

+ (NSString *)logStyleDescription:(LLDebugConfigLogStyle)style {
    switch (style) {
        case LLDebugConfigLogDetail:
            return @"Detail";
        case LLDebugConfigLogFileFuncDesc:
            return @"File Func Desc";
        case LLDebugConfigLogFileDesc:
            return @"File Desc";
        case LLDebugConfigLogNormal:
            return @"Normal";
        case LLDebugConfigLogNone:
            return @"None";
    }
}

+ (NSString *)doubleClickComponentDescription {
    return [self componentDescription:[LLDebugConfig shared].doubleClickAction];
}

+ (NSString *)componentDescription:(LLDebugToolAction)action {
    return [[LLFunctionItemModel alloc] initWithAction:action].title;
}

@end
