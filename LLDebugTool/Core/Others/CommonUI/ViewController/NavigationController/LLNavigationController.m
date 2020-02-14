//
//  LLNavigationController.m
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

#import "LLNavigationController.h"

#import "LLBaseViewController.h"
#import "LLThemeManager.h"

@interface LLNavigationController ()

@end

@implementation LLNavigationController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
    self.navigationBar.translucent = YES;
    [self updateNavigationBarTheme];
    [self addObservers];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Over write
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [LLThemeManager shared].statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.visibleViewController isKindOfClass:[LLBaseViewController class]]) {
        return [self.visibleViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.visibleViewController isKindOfClass:[LLBaseViewController class]]) {
        return [self.visibleViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}

#pragma mark - LLDebugToolUpdateThemeNotificationName
- (void)didReceiveDebugToolUpdateThemeNotification:(NSNotification *)notification {
    [self themeColorChanged];
}

#pragma mark - Primary
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolUpdateThemeNotification:) name:LLDebugToolUpdateThemeNotificationName object:nil];
}

- (void)themeColorChanged {
    [self updateNavigationBarTheme];
    [self updateStatusBarTheme];
}

- (void)updateNavigationBarTheme {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].primaryColor}];
    self.navigationBar.tintColor = [LLThemeManager shared].primaryColor;
    self.navigationBar.barTintColor = [LLThemeManager shared].backgroundColor;
}

- (void)updateStatusBarTheme {
    [self setNeedsStatusBarAppearanceUpdate];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:[LLThemeManager shared].statusBarStyle animated:NO];
#pragma clang diagnostic pop
}

@end
