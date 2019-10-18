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
#import "LLFactory.h"
#import "LLThemeManager.h"
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

@end
