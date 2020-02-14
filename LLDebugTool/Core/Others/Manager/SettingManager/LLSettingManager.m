//
//  LLSettingManager.m
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

#import "LLSettingManager.h"

#import "LLFunctionComponent.h"
#import "LLConfig.h"
#import "LLRouter.h"
#import "LLConst.h"

#import "NSUserDefaults+LL_Utils.h"

static LLSettingManager *_instance = nil;

@implementation LLSettingManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLSettingManager alloc] init];
    });
    return _instance;
}

- (void)prepareForConfig {
    NSNumber *doubleClickAction = self.doubleClickAction;
    if (doubleClickAction != nil) {
        [LLConfig shared].doubleClickAction = [doubleClickAction integerValue];
    }
    NSNumber *colorStyle = self.colorStyle;
    if (colorStyle != nil) {
        [LLConfig shared].colorStyle = colorStyle.integerValue;
    }
    NSNumber *entryWindowStyle = self.entryWindowStyle;
    if (entryWindowStyle != nil) {
        [LLConfig shared].entryWindowStyle = entryWindowStyle.integerValue;
    }
    NSNumber *logStyle = self.logStyle;
    if (logStyle != nil) {
        [LLConfig shared].logStyle = logStyle.integerValue;
    }
    NSNumber *shrinkToEdgeWhenInactive = self.shrinkToEdgeWhenInactive;
    if (shrinkToEdgeWhenInactive != nil) {
        [LLConfig shared].shrinkToEdgeWhenInactive = [shrinkToEdgeWhenInactive boolValue];
    }
    NSNumber *shakeToHide = self.shakeToHide;
    if (shakeToHide != nil) {
        [LLConfig shared].shakeToHide = [shakeToHide boolValue];
    }
    NSNumber *magnifierZoomLevel = self.magnifierZoomLevel;
    if (magnifierZoomLevel != nil) {
        [LLConfig shared].magnifierZoomLevel = [magnifierZoomLevel integerValue];
    }
    NSNumber *magnifierSize = self.magnifierSize;
    if (magnifierSize != nil) {
        [LLConfig shared].magnifierSize = [magnifierSize integerValue];
    }
    NSNumber *showWidgetBorder = self.showWidgetBorder;
    if (showWidgetBorder != nil) {
        [LLConfig shared].showWidgetBorder = [showWidgetBorder boolValue];
    }
    NSNumber *hierarchyIgnorePrivateClass = self.hierarchyIgnorePrivateClass;
    if (hierarchyIgnorePrivateClass != nil) {
        [LLConfig shared].hierarchyIgnorePrivateClass = [hierarchyIgnorePrivateClass boolValue];
    }
    NSNumber *mockLocationEnable = self.mockLocationEnable;
    if (mockLocationEnable != nil) {
        [LLRouter setLocationHelperEnable:[mockLocationEnable boolValue]];
    }
    NSNumber *mockLocationLatitude = self.mockLocationLatitude;
    NSNumber *mockLocationLogitude = self.mockLocationLongitude;
    if (mockLocationLatitude && mockLocationLogitude) {
        [LLConfig shared].mockLocationLatitude = [mockLocationLatitude doubleValue];
        [LLConfig shared].mockLocationLongitude = [mockLocationLogitude doubleValue];
    }
}

#pragma mark - Getters and Setters
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

- (void)setLastWebViewUrl:(NSString *)lastWebViewUrl {
    [NSUserDefaults LL_setString:lastWebViewUrl forKey:@"lastWebViewUrl"];
}

- (NSString *)lastWebViewUrl {
    return [NSUserDefaults LL_stringForKey:@"lastWebViewUrl"];
}

- (void)setMockLocationEnable:(NSNumber *)mockLocationEnable {
    [NSUserDefaults LL_setNumber:mockLocationEnable forKey:@"mockLocationEnable"];
}

- (NSNumber *)mockLocationEnable {
    return [NSUserDefaults LL_numberForKey:@"mockLocationEnable"];
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

- (void)setMockRouteFilePath:(NSString *)mockRouteFilePath {
    [NSUserDefaults LL_setString:mockRouteFilePath forKey:@"mockRouteFilePath"];
}

- (NSString *)mockRouteFilePath {
    return [NSUserDefaults LL_stringForKey:@"mockRouteFilePath"];
}

- (void)setMockRouteFileName:(NSString *)mockRouteFileName {
    [NSUserDefaults LL_setString:mockRouteFileName forKey:@"mockRouteFileName"];
}

- (NSString *)mockRouteFileName {
    return [NSUserDefaults LL_stringForKey:@"mockRouteFileName"];
}

@end
