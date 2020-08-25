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

#import <UIKit/UIKit.h>

#import "LLComponentWindow.h"
#import "LLDebugConfig.h"

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
- (void)showWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;

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
- (void)hideWindow:(UIWindow *)window animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;

/**
 Current visible window.
 */
- (LLComponentWindow *_Nullable)visibleWindow;

/**
 Remove all visible windows.
 */
- (void)removeAllVisibleWindows;

@end

#pragma mark - Internal

@interface LLWindowManager (Internal)

+ (LLComponentWindow *)createWindowWithClassName:(NSString *)className action:(LLDebugToolAction)action;

@end

NS_ASSUME_NONNULL_END
