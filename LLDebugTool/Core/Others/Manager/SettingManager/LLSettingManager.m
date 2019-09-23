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
#import "LLConst.h"
#import "NSUserDefaults+LL_Utils.h"

static LLSettingManager *_instance = nil;

static NSString *doubleClickActionKey = @"doubleClickActionKey";
static NSString *colorStyleKey = @"colorStyleKey";
static NSString *entryWindowStyleKey = @"entryWindowStyleKey";
static NSString *statusBarStyleKey = @"statusBarStyleKey";
static NSString *logStyleKey = @"logStyleKey";
static NSString *shrinkToEdgeWhenInactiveKey = @"shrinkToEdgeWhenInactiveKey";
static NSString *shakeToHideKey = @"shakeToHideKey";
static NSString *magnifierZoomLevelKey = @"magnifierZoomLevelKey";
static NSString *magnifierSizeKey = @"magnifierSizeKey";
static NSString *showWidgetBorderKey = @"showWidgetBorderKey";
static NSString *hierarchyIgnorePrivateClassKey = @"hierarchyIgnorePrivateClassKey";

@implementation LLSettingManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLSettingManager alloc] init];
    });
    return _instance;
}

#pragma mark - Getters and Setters
- (void)setDoubleClickAction:(NSNumber *)doubleClickAction {
    [NSUserDefaults LL_setNumber:doubleClickAction forKey:doubleClickActionKey];
}

- (NSNumber *)doubleClickAction {
    return [NSUserDefaults LL_numberForKey:doubleClickActionKey];
}

- (void)setColorStyle:(NSNumber *)colorStyle {
    [NSUserDefaults LL_setNumber:colorStyle forKey:colorStyleKey];
}

- (NSNumber *)colorStyle {
    return [NSUserDefaults LL_numberForKey:colorStyleKey];
}

- (void)setEntryWindowStyle:(NSNumber *)entryWindowStyle {
    [NSUserDefaults LL_setNumber:entryWindowStyle forKey:entryWindowStyleKey];
}

- (NSNumber *)entryWindowStyle {
    return [NSUserDefaults LL_numberForKey:entryWindowStyleKey];
}

- (void)setStatusBarStyle:(NSNumber *)statusBarStyle {
    [NSUserDefaults LL_setNumber:statusBarStyle forKey:statusBarStyleKey];
}

- (NSNumber *)statusBarStyle {
    return [NSUserDefaults LL_numberForKey:statusBarStyleKey];
}

- (void)setLogStyle:(NSNumber *)logStyle {
    [NSUserDefaults LL_setNumber:logStyle forKey:logStyleKey];
}

- (NSNumber *)logStyle {
    return [NSUserDefaults LL_numberForKey:logStyleKey];
}

- (void)setShrinkToEdgeWhenInactive:(NSNumber *)shrinkToEdgeWhenInactive {
    [NSUserDefaults LL_setNumber:shrinkToEdgeWhenInactive forKey:shrinkToEdgeWhenInactiveKey];
}

- (NSNumber *)shrinkToEdgeWhenInactive {
    return [NSUserDefaults LL_numberForKey:shrinkToEdgeWhenInactiveKey];
}

- (void)setShakeToHide:(NSNumber *)shakeToHide {
    [NSUserDefaults LL_setNumber:shakeToHide forKey:shakeToHideKey];
}

- (NSNumber *)shakeToHide {
    return [NSUserDefaults LL_numberForKey:shakeToHideKey];
}

- (void)setMagnifierZoomLevel:(NSNumber *)magnifierZoomLevel {
    [NSUserDefaults LL_setNumber:magnifierZoomLevel forKey:magnifierZoomLevelKey];
}

- (NSNumber *)magnifierZoomLevel {
    return [NSUserDefaults LL_numberForKey:magnifierZoomLevelKey];
}

- (void)setMagnifierSize:(NSNumber *)magnifierSize {
    [NSUserDefaults LL_setNumber:magnifierSize forKey:magnifierSizeKey];
}

- (NSNumber *)magnifierSize {
    return [NSUserDefaults LL_numberForKey:magnifierSizeKey];
}

- (void)setShowWidgetBorder:(NSNumber *)showWidgetBorder {
    [NSUserDefaults LL_setNumber:showWidgetBorder forKey:showWidgetBorderKey];
}

- (NSNumber *)showWidgetBorder {
    return [NSUserDefaults LL_numberForKey:showWidgetBorderKey];
}

- (void)setHierarchyIgnorePrivateClass:(NSNumber *)hierarchyIgnorePrivateClass {
    [NSUserDefaults LL_setNumber:hierarchyIgnorePrivateClass forKey:hierarchyIgnorePrivateClassKey];
}

- (NSNumber *)hierarchyIgnorePrivateClass {
    return [NSUserDefaults LL_numberForKey:hierarchyIgnorePrivateClassKey];
}

@end
