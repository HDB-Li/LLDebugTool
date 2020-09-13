//
//  LLSettingHelper.m
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

#import "LLSettingHelper.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLRouter.h"

#import "NSUserDefaults+LL_Utils.h"

@implementation LLSettingHelper

#pragma mark - Over write
- (void)start {
    [super start];
    [self prepareConfig];
}

#pragma mark - LLSettingHelperDelegate
- (void)setDoubleClickAction:(NSNumber *)doubleClickAction {
    [NSUserDefaults LL_setNumber:doubleClickAction forKey:@"doubleClickAction"];
}

- (NSNumber *)doubleClickAction {
    return [NSUserDefaults LL_numberForKey:@"doubleClickAction"];
}

- (void)setColorStyle:(NSNumber *)colorStyle {
    [NSUserDefaults LL_setNumber:colorStyle forKey:@"colorStyle"];
}

- (NSNumber *)colorStyle {
    return [NSUserDefaults LL_numberForKey:@"colorStyle"];
}

- (void)setEntryWindowStyle:(NSNumber *)entryWindowStyle {
    [NSUserDefaults LL_setNumber:entryWindowStyle forKey:@"entryWindowStyle"];
}

- (NSNumber *)entryWindowStyle {
    return [NSUserDefaults LL_numberForKey:@"entryWindowStyle"];
}

- (void)setLogStyle:(NSNumber *)logStyle {
    [NSUserDefaults LL_setNumber:logStyle forKey:@"logStyle"];
}

- (NSNumber *)logStyle {
    return [NSUserDefaults LL_numberForKey:@"logStyle"];
}

- (void)setShrinkToEdgeWhenInactive:(NSNumber *)shrinkToEdgeWhenInactive {
    [NSUserDefaults LL_setNumber:shrinkToEdgeWhenInactive forKey:@"shrinkToEdgeWhenInactive"];
}

- (NSNumber *)shrinkToEdgeWhenInactive {
    return [NSUserDefaults LL_numberForKey:@"shrinkToEdgeWhenInactive"];
}

- (void)setShakeToHide:(NSNumber *)shakeToHide {
    [NSUserDefaults LL_setNumber:shakeToHide forKey:@"shakeToHide"];
}

- (NSNumber *)shakeToHide {
    return [NSUserDefaults LL_numberForKey:@"shakeToHide"];
}

- (void)setMagnifierZoomLevel:(NSNumber *)magnifierZoomLevel {
    [NSUserDefaults LL_setNumber:magnifierZoomLevel forKey:@"magnifierZoomLevel"];
}

- (NSNumber *)magnifierZoomLevel {
    return [NSUserDefaults LL_numberForKey:@"magnifierZoomLevel"];
}

- (void)setMagnifierSize:(NSNumber *)magnifierSize {
    [NSUserDefaults LL_setNumber:magnifierSize forKey:@"magnifierSize"];
}

- (NSNumber *)magnifierSize {
    return [NSUserDefaults LL_numberForKey:@"magnifierSize"];
}

- (void)setShowWidgetBorder:(NSNumber *)showWidgetBorder {
    [NSUserDefaults LL_setNumber:showWidgetBorder forKey:@"showWidgetBorder"];
}

- (NSNumber *)showWidgetBorder {
    return [NSUserDefaults LL_numberForKey:@"showWidgetBorder"];
}

- (void)setHierarchyIgnorePrivateClass:(NSNumber *)hierarchyIgnorePrivateClass {
    [NSUserDefaults LL_setNumber:hierarchyIgnorePrivateClass forKey:@"hierarchyIgnorePrivateClass"];
}

- (NSNumber *)hierarchyIgnorePrivateClass {
    return [NSUserDefaults LL_numberForKey:@"hierarchyIgnorePrivateClass"];
}

- (void)setWebViewClass:(NSString *)webViewClass {
    [NSUserDefaults LL_setString:webViewClass forKey:@"webViewClass"];
}

- (NSString *)webViewClass {
    return [NSUserDefaults LL_stringForKey:@"webViewClass"];
}

- (void)setDefaultHtmlUrl:(NSString *)defaultHtmlUrl {
    [NSUserDefaults LL_setString:defaultHtmlUrl forKey:@"defaultHtmlUrl"];
}

- (NSString *)defaultHtmlUrl {
    return [NSUserDefaults LL_stringForKey:@"defaultHtmlUrl"];
}

- (void)setMockLocation:(NSNumber *)mockLocation {
    [NSUserDefaults LL_setNumber:mockLocation forKey:@"mockLocation"];
}

- (NSNumber *)mockLocation {
    return [NSUserDefaults LL_numberForKey:@"mockLocation"];
}

- (void)setMockLocationLatitude:(NSNumber *)mockLocationLatitude {
    [NSUserDefaults LL_setNumber:mockLocationLatitude forKey:@"mockLocationLatitude"];
}

- (NSNumber *)mockLocationLatitude {
    return [NSUserDefaults LL_numberForKey:@"mockLocationLatitude"];
}

- (void)setMockLocationLongitude:(NSNumber *)mockLocationLongitude {
    [NSUserDefaults LL_setNumber:mockLocationLongitude forKey:@"mockLocationLongitude"];
}

- (NSNumber *)mockLocationLongitude {
    return [NSUserDefaults LL_numberForKey:@"mockLocationLongitude"];
}

#pragma mark - Primary
- (void)prepareConfig {
    [self prepareDoubleClickAction];
    [self prepareColorStyle];
    [self prepareEntryWindowStyle];
    [self prepareLogStyle];
    [self prepareShrinkToEdgeWhenInactive];
    [self prepareShakeToHide];
    [self prepareMagnifier];
    [self prepareHtml];
    [self prepareShowWidgetBorder];
    [self prepareHierarchyIgnorePrivateClass];
    [self prepareLocation];
}

- (void)prepareDoubleClickAction {
    NSNumber *doubleClickAction = self.doubleClickAction;
    if (doubleClickAction != nil) {
        [LLDebugConfig shared].doubleClickAction = [doubleClickAction integerValue];
    }
}

- (void)prepareColorStyle {
    NSNumber *colorStyle = self.colorStyle;
    if (colorStyle != nil) {
        [LLDebugConfig shared].colorStyle = colorStyle.integerValue;
    }
}

- (void)prepareEntryWindowStyle {
    NSNumber *entryWindowStyle = self.entryWindowStyle;
    if (entryWindowStyle != nil) {
        [LLDebugConfig shared].entryWindowStyle = entryWindowStyle.integerValue;
    }
}

- (void)prepareLogStyle {
    NSNumber *logStyle = self.logStyle;
    if (logStyle != nil) {
        [LLDebugConfig shared].logStyle = logStyle.integerValue;
    }
}

- (void)prepareShrinkToEdgeWhenInactive {
    NSNumber *shrinkToEdgeWhenInactive = self.shrinkToEdgeWhenInactive;
    if (shrinkToEdgeWhenInactive != nil) {
        [LLDebugConfig shared].shrinkToEdgeWhenInactive = [shrinkToEdgeWhenInactive boolValue];
    }
}

- (void)prepareShakeToHide {
    NSNumber *shakeToHide = self.shakeToHide;
    if (shakeToHide != nil) {
        [LLDebugConfig shared].shakeToHide = [shakeToHide boolValue];
    }
}

- (void)prepareMagnifier {
    NSNumber *magnifierZoomLevel = self.magnifierZoomLevel;
    if (magnifierZoomLevel != nil) {
        [LLDebugConfig shared].magnifierZoomLevel = [magnifierZoomLevel integerValue];
    }
    NSNumber *magnifierSize = self.magnifierSize;
    if (magnifierSize != nil) {
        [LLDebugConfig shared].magnifierSize = [magnifierSize integerValue];
    }
}

- (void)prepareHtml {
    NSString *defaultHtmlUrl = self.defaultHtmlUrl;
    if (defaultHtmlUrl != nil) {
        [LLDebugConfig shared].defaultHtmlUrl = defaultHtmlUrl;
    }

    NSString *webViewClass = self.webViewClass;
    if (webViewClass != nil) {
        [LLDebugConfig shared].webViewClass = webViewClass;
    }
}

- (void)prepareShowWidgetBorder {
    NSNumber *showWidgetBorder = self.showWidgetBorder;
    if (showWidgetBorder != nil) {
        [LLDebugConfig shared].showWidgetBorder = [showWidgetBorder boolValue];
    }
}

- (void)prepareHierarchyIgnorePrivateClass {
    NSNumber *hierarchyIgnorePrivateClass = self.hierarchyIgnorePrivateClass;
    if (hierarchyIgnorePrivateClass != nil) {
        [LLDebugConfig shared].hierarchyIgnorePrivateClass = [hierarchyIgnorePrivateClass boolValue];
    }
}

- (void)prepareLocation {
    NSNumber *mockLocation = self.mockLocation;
    if (mockLocation != nil) {
        [LLDebugConfig shared].mockLocation = [mockLocation boolValue];
    }
    NSNumber *mockLocationLatitude = self.mockLocationLatitude;
    NSNumber *mockLocationLogitude = self.mockLocationLongitude;
    if (mockLocationLatitude && mockLocationLogitude) {
        [LLDebugConfig shared].mockLocationLatitude = [mockLocationLatitude doubleValue];
        [LLDebugConfig shared].mockLocationLongitude = [mockLocationLogitude doubleValue];
    }
}

@end
