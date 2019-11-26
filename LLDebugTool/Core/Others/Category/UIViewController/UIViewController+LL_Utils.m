//
//  UIViewController+LL_Utils.m
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

#import "UIViewController+LL_Utils.h"

#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

#import "UIImage+LL_Utils.h"

@implementation UIViewController (LL_Utils)

- (UIViewController *)LL_currentShowingViewController {
    
    UIViewController *vc = self;
    if ([self presentedViewController]) {
        vc = [[self presentedViewController] LL_currentShowingViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBar = (UITabBarController *)vc;
        vc = [tabBar.selectedViewController LL_currentShowingViewController];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        vc = [[nav visibleViewController] LL_currentShowingViewController];
    }
    return vc;
}

- (UIButton *)LL_navigationButtonWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(id _Nullable)target action:(SEL _Nullable)action {
    UIButton *btn = [LLFactory getButton:nil frame:CGRectMake(0, 0, 30, 40) target:target action:action];
    btn.showsTouchWhenHighlighted = NO;
    btn.tintColor = [LLThemeManager shared].primaryColor;
    if ([title length]) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
    }
    if (imageName) {
        UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
        [btn setImage:[[UIImage LL_imageNamed:imageName] imageWithRenderingMode:mode] forState:UIControlStateNormal];
    }
    return btn;
}

- (void)LL_showConfirmAlertControllerWithMessage:(NSString *)message handler:(void (^)(void))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LLLocalizedString(@"note") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:LLLocalizedString(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        if (handler) {
            handler();
        }
    }];
    [alert addAction:confirm];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)LL_showAlertControllerWithMessage:(NSString *)message handler:(void (^)(NSInteger action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LLLocalizedString(@"note") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LLLocalizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if (handler) {
            handler(0);
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:LLLocalizedString(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        if (handler) {
            handler(1);
        }
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)LL_showActionSheetWithTitle:(NSString *)title actions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < actions.count; i++) {
        NSString *actionTitle = actions[i];
        __block NSInteger index = i;
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(index);
            }
        }];
        if (currentAction && [actionTitle isEqualToString:currentAction]) {
            action.enabled = NO;
            [action setValue:[UIImage LL_imageNamed:kSelectImageName] forKey:@"image"];
        }
        [alert addAction:action];
    }
    [alert addAction:[UIAlertAction actionWithTitle:LLLocalizedString(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)LL_showTextFieldAlertControllerWithMessage:(NSString *)message text:(nullable NSString *)text handler:(nullable void (^)(NSString * _Nullable))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:LLLocalizedString(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:LLLocalizedString(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(alert.textFields.firstObject.text);
        }
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
