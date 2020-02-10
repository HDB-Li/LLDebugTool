//
//  LLConfigHelper.m
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

#import "LLConfigHelper.h"

#import "LLFunctionItemModel.h"
#import "LLThemeManager.h"
#import "LLConfig.h"

#import "UIColor+LL_Utils.h"

@implementation LLConfigHelper

#pragma mark - Description
+ (NSString *)colorStyleDetailDescription {
    return [self colorStyleDetailDescription:[LLConfig shared].colorStyle];
}

+ (NSString *)colorStyleDetailDescription:(LLConfigColorStyle)colorStyle {
    switch (colorStyle) {
        case LLConfigColorStyleHack:
            return @"Hack";
        case LLConfigColorStyleSimple:
            return @"Simple";
        case LLConfigColorStyleSystem:
            return @"System";
        case LLConfigColorStyleGrass:
            return @"Grass";
        case LLConfigColorStyleHomebrew:
            return @"Homebrew";
        case LLConfigColorStyleManPage:
            return @"Man Page";
        case LLConfigColorStyleNovel:
            return @"Novel";
        case LLConfigColorStyleOcean:
            return @"Ocean";
        case LLConfigColorStylePro:
            return @"Pro";
        case LLConfigColorStyleRedSands:
            return @"Red Sands";
        case LLConfigColorStyleSilverAerogel:
            return @"Silver Aerogel";
        case LLConfigColorStyleSolidColors:
            return @"Solid Colors";
        case LLConfigColorStyleCustom:
            return [NSString stringWithFormat:@"%@\n%@",[[LLThemeManager shared].primaryColor LL_description],[[LLThemeManager shared].backgroundColor LL_description]];
    }
}

+ (NSString *)colorStyleDescription {
    return [self colorStyleDescription:[LLConfig shared].colorStyle];
}

+ (NSString *)colorStyleDescription:(LLConfigColorStyle)colorStyle {
    switch (colorStyle) {
        case LLConfigColorStyleHack:
            return @"Hack";
        case LLConfigColorStyleSimple:
            return @"Simple";
        case LLConfigColorStyleSystem:
            return @"System";
        case LLConfigColorStyleGrass:
            return @"Grass";
        case LLConfigColorStyleHomebrew:
            return @"Homebrew";
        case LLConfigColorStyleManPage:
            return @"Man Page";
        case LLConfigColorStyleNovel:
            return @"Novel";
        case LLConfigColorStyleOcean:
            return @"Ocean";
        case LLConfigColorStylePro:
            return @"Pro";
        case LLConfigColorStyleRedSands:
            return @"Red Sands";
        case LLConfigColorStyleSilverAerogel:
            return @"Silver Aerogel";
        case LLConfigColorStyleSolidColors:
            return @"Solid Colors";
        case LLConfigColorStyleCustom:
            return @"Custom";
    }
}

+ (NSString *)entryWindowStyleDescription {
    return [self entryWindowStyleDescription:[LLConfig shared].entryWindowStyle];
}

+ (NSString *)entryWindowStyleDescription:(LLConfigEntryWindowStyle)windowStyle {
    switch (windowStyle) {
        case LLConfigEntryWindowStyleBall:
            return @"Ball";
        case LLConfigEntryWindowStyleTitle:
            return @"Title";
        case LLConfigEntryWindowStyleLeading:
            return @"Leading";
        case LLConfigEntryWindowStyleTrailing:
            return @"Trailing";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLConfigEntryWindowStyleNetBar:
            return @"Net Bar";
        case LLConfigEntryWindowStylePowerBar:
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
    return [self logStyleDescription:[LLConfig shared].logStyle];
}

+ (NSString *)logStyleDescription:(LLConfigLogStyle)style {
    switch (style) {
        case LLConfigLogDetail:
            return @"Detail";
        case LLConfigLogFileFuncDesc:
            return @"File Func Desc";
        case LLConfigLogFileDesc:
            return @"File Desc";
        case LLConfigLogNormal:
            return @"Normal";
        case LLConfigLogNone:
            return @"None";
    }
}

+ (NSString *)doubleClickComponentDescription {
    return [self componentDescription:[LLConfig shared].doubleClickAction];
}

+ (NSString *)componentDescription:(LLDebugToolAction)action {
    return [[LLFunctionItemModel alloc] initWithAction:action].title;
}

@end
