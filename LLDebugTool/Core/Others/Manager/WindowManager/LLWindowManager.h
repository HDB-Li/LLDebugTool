//
//  LLWindowManager.h
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
#import "LLSuspensionWindow.h"
#import "LLFunctionWindow.h"
#import "LLMagnifierWindow.h"
#import "LLNetworkWindow.h"
#import "LLLogWindow.h"
#import "LLAppInfoWindow.h"
#import "LLSandboxWindow.h"
#import "LLCrashWindow.h"
#import "LLHierarchyWindow.h"
#import "LLMagnifierInfoWindow.h"
#import "LLHierarchyPickerWindow.h"
#import "LLHierarchyInfoWindow.h"
#import "LLHierarchyDetailWindow.h"
#import "LLScreenshotWindow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Manager windows.
 */
@interface LLWindowManager : NSObject

/**
 Singleton

 @return LLWindowManager.
 */
+ (instancetype)shared;

@property (nonatomic, strong, readonly) LLSuspensionWindow *suspensionWindow;

@property (nonatomic, strong, readonly) LLFunctionWindow *functionWindow;

@property (nonatomic, strong, readonly) LLMagnifierWindow *magnifierWindow;

@property (nonatomic, strong, readonly) LLMagnifierInfoWindow *magnifierColorWindow;

@property (nonatomic, strong, readonly) LLNetworkWindow *networkWindow;

@property (nonatomic, strong, readonly) LLLogWindow *logWindow;

@property (nonatomic, strong, readonly) LLCrashWindow *crashWindow;

@property (nonatomic, strong, readonly) LLAppInfoWindow *appInfoWindow;

@property (nonatomic, strong, readonly) LLSandboxWindow *sandboxWindow;

@property (nonatomic, strong, readonly) LLHierarchyWindow *hierarchyWindow;

@property (nonatomic, strong, readonly) LLHierarchyPickerWindow *hierarchyPickerWindow;

@property (nonatomic, strong, readonly) LLHierarchyInfoWindow *hierarchyInfoWindow;

@property (nonatomic, strong, readonly) LLHierarchyDetailWindow *hierarchyDetailWindow;

@property (nonatomic, strong, readonly) LLScreenshotWindow *screenshotWindow;

/**
 Show window with alpha animate if needed.

 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)showWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Show window with alpha animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)showWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 Hide window with alpha animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Hide window with alpha animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 Present window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Present window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)presentWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 Dismiss window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Dismiss window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)dismissWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 Push window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Push window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)pushWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;

/**
 Pop window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 */
- (void)popWindow:(UIWindow *)window animated:(BOOL)animated;

/**
 Push window animate if needed.
 
 @param window LLBaseWindow.
 @param animated Animated.
 @param completion Completion block.
 */
- (void)popWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;

/**
 Reload function window.
 */
- (void)reloadFunctionWindow;

/**
 Reload magnifier window.
 */
- (void)reloadMagnifierWindow;

/**
 Reload network window.
 */
- (void)reloadNetworkWindow;

/**
 Reload log window.
 */
- (void)reloadLogWindow;

/**
 Reload crash window.
 */
- (void)reloadCrashWindow;

/**
 Reload appInfo window.
 */
- (void)reloadAppInfoWindow;

/**
 Reload sandbox window.
 */
- (void)reloadSandboxWindow;

/**
 Reload hierarchy window.
 */
- (void)reloadHierarchyWindow;

/**
 Reload magnifier color window.
 */
- (void)reloadMagnifierColorWindow;

/**
 Reload hierarchy picker window.
 */
- (void)reloadHierarchyPickerWindow;

/**
 Reload hierarchy info window.
 */
- (void)reloadHierarchyInfoWindow;

/**
 Reload hierarchy detail window.
 */
- (void)reloadHierarchyDetailWindow;

/**
 Reload screenshot window.
 */
- (void)reloadScreenshotWindow;

@end

NS_ASSUME_NONNULL_END
