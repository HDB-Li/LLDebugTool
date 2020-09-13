//
//  LLHierarchyHelperDelegate.h
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

FOUNDATION_EXPORT NSNotificationName const LLDebugToolChangeHierarchyNotification;

@protocol LLHierarchyHelperDelegate <LLComponentHelperDelegate>

- (void)setLockViews:(NSMutableArray *_Nonnull)lockViews;

- (NSMutableArray *_Nonnull)lockViews;

/// All window in application.
- (NSArray<UIWindow *> *)allWindows;

/// All window in application without class.
/// @param cls Ignore class.
- (NSArray<UIWindow *> *)allWindowsIgnoreClass:(Class _Nullable)cls;

/// Whether is a private class view.
/// @param view Selected view.
- (BOOL)isPrivateClassView:(UIView *)view;

/// Find parent views.
/// @param view Selected view.
- (NSArray<UIView *> *)findParentViewsByView:(UIView *)view;

/// Find subviews.
/// @param view Selected view.
- (NSArray<UIView *> *)findSubviewsByView:(UIView *)view;

/// Views at points.
/// @param tapPointInWindow Point.
- (NSArray<UIView *> *)viewForSelectionAtPoint:(CGPoint)tapPointInWindow;

#pragma mark - Alert

/// Show action sheet on keyWindow,
/// @param actions Actions
/// @param currentAction Current action.
/// @param completion Completion block.
- (void)showActionSheetWithActions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion;

/// Show text field alert on keyWindow.
/// @param text Current text.
/// @param handler Completion handle.
- (void)showTextFieldAlertWithText:(nullable NSString *)text handler:(nullable void (^)(NSString *originText, NSString *newText))handler;

/// Call listener property change.
- (void)postDebugToolChangeHierarchyNotification;

#pragma mark - Check Property
/// Whether has 'text' property.
/// @param cls Target class.
- (BOOL)hasTextPropertyInClass:(Class)cls;

/// Whether has 'textColor' property.
/// @param cls  Target class.
- (BOOL)hasTextColorPropertyInClass:(Class)cls;

/// Whether has 'font' property.
/// @param cls Target class.
- (BOOL)hasFontPropertyInClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
