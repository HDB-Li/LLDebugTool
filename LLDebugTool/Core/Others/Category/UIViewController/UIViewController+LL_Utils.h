//
//  UIViewController+LL_Utils.h
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

NS_ASSUME_NONNULL_BEGIN

/// UIViewController utils.
@interface UIViewController (LL_Utils)

/// Current visiable view controller.
- (UIViewController *_Nullable)LL_currentShowingViewController;

/// Get navigation button
/// @param title Title
/// @param imageName Image name
/// @param target Target
/// @param action Action
- (UIButton *)LL_navigationButtonWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(id _Nullable)target action:(SEL _Nullable)action;

/// Show alert controller with confirm action.
/// @param message Message
/// @param handler Action handler.
- (void)LL_showConfirmAlertControllerWithMessage:(NSString *)message handler:(nullable void (^)(void))handler;

/// Show alert controller with message
/// @param message Message
/// @param handler Action handler.
- (void)LL_showAlertControllerWithMessage:(NSString *)message handler:(nullable void (^)(NSInteger action))handler;

/// Show action sheet.
/// @param title Title
/// @param actions Actions
/// @param currentAction Current action.
/// @param completion Completion block.
- (void)LL_showActionSheetWithTitle:(NSString *)title actions:(NSArray *)actions currentAction:(nullable NSString *)currentAction completion:(nullable void (^)(NSInteger index))completion;

/// Show text field alert.
/// @param message Message
/// @param text Text field's text
/// @param handler Action handler.
- (void)LL_showTextFieldAlertControllerWithMessage:(NSString *)message text:(nullable NSString *)text handler:(nullable void (^)(NSString * _Nullable newText))handler;

@end

NS_ASSUME_NONNULL_END
