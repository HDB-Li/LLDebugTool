//
//  LLWindowTabBarController.m
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

#import "LLWindowTabBarController.h"
#import "LLWindowTabBar.h"
#import "LLNetworkViewController.h"
#import "LLLogViewController.h"
#import "LLCrashViewController.h"
#import "LLAppInfoViewController.h"
#import "LLSandboxViewController.h"
#import "LLHierarchyViewController.h"
#import "LLBaseNavigationController.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"

@interface LLWindowTabBarController () <LLWindowTabBarDelegate , LLHierarchyViewControllerDelegate>

@property (nonatomic , strong , nonnull) LLWindowTabBar *windowTabBar;

@end

@implementation LLWindowTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setValue:@(6) forKey:@"_customMaxItems"];
        [self setValue:self.windowTabBar forKey:@"tabBar"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self.windowTabBar calculateSubviewsIfNeeded];
}

#pragma mark - LLWindowTabBarDelegate
- (void)LLWindowTabBar:(LLWindowTabBar *)windowTabBar didSelectPreviousItem:(UIButton *)sender {
    if (self.selectedIndex > 0) {
        self.selectedIndex = self.selectedIndex - 1;
        [self.windowTabBar calculateSubviewsIfNeeded];
    }
}

- (void)LLWindowTabBar:(LLWindowTabBar *)windowTabBar didSelectNextItem:(UIButton *)sender {
    if (self.selectedIndex < self.viewControllers.count - 1) {
        self.selectedIndex = self.selectedIndex + 1;
        [self.windowTabBar calculateSubviewsIfNeeded];
    }
}

#pragma mark - LLHierarchyViewControllerDelegate
- (void)LLHierarchyViewController:(LLHierarchyViewController *)viewController didFinishWithSelectedModel:(LLHierarchyModel *)selectedModel {
    [self.actionDelegate LLWindowTabBarController:self didSelectedHierarchyModel:selectedModel];
}

#pragma mark - Primary
- (void)initial {
    LLConfigAvailableFeature availables = [LLConfig sharedConfig].availables;
    if (availables & LLConfigAvailableNetwork) {
        [self addNetworkViewController];
    }
    if (availables & LLConfigAvailableLog) {
        [self addLogViewController];
    }
    if (availables & LLConfigAvailableCrash) {
        [self addCrashViewController];
    }
    if (availables & LLConfigAvailableAppInfo) {
        [self addAppInfoViewController];
    }
    if (availables & LLConfigAvailableSandbox) {
        [self addSandboxViewController];
    }
    if (availables & LLConfigAvailableHierarchy) {
        [self addHierarchyViewController];
    }
    if (self.viewControllers.count == 0) {
        [LLConfig sharedConfig].availables = LLConfigAvailableAll;
        [self addNetworkViewController];
        [self addLogViewController];
        [self addCrashViewController];
        [self addAppInfoViewController];
        [self addSandboxViewController];
        [self addHierarchyViewController];
    }
}

- (void)addNetworkViewController {
    LLNetworkViewController *vc = [[LLNetworkViewController alloc] init];
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"Network" barImageName:kNetworkImageName];
    [self addChildViewController:nav];
}

- (void)addLogViewController {
    LLLogViewController *vc = [[LLLogViewController alloc] init];
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"Log" barImageName:kLogImageName];
    [self addChildViewController:nav];
}

- (void)addCrashViewController {
    LLCrashViewController *vc = [[LLCrashViewController alloc] init];
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"Crash" barImageName:kCrashImageName];
    [self addChildViewController:nav];
}

- (void)addAppInfoViewController {
    LLAppInfoViewController *vc = [[LLAppInfoViewController alloc] init];
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"App" barImageName:kAppImageName];
    [self addChildViewController:nav];
}

- (void)addSandboxViewController {
    LLSandboxViewController *vc = [[LLSandboxViewController alloc] init];
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"Sandbox" barImageName:kSandboxImageName];
    [self addChildViewController:nav];
}

- (void)addHierarchyViewController {
    LLHierarchyViewController *vc = [[LLHierarchyViewController alloc] init];
    vc.delegate = self;
    LLBaseNavigationController *nav = [self navigationControllerWithRootViewController:vc barTitle:@"Hierarchy" barImageName:kNetworkImageName];
    [self addChildViewController:nav];
}

- (LLBaseNavigationController *)navigationControllerWithRootViewController:(LLBaseTableViewController *)viewController barTitle:(NSString *)barTitle barImageName:(NSString *)barImageName {
    LLBaseNavigationController *navigationController = [[LLBaseNavigationController alloc] initWithRootViewController:viewController];
    navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:barTitle image:[UIImage LL_imageNamed:barImageName] selectedImage:nil];
    return navigationController;
}

#pragma mark - Lazy load
- (LLWindowTabBar *)windowTabBar {
    if (!_windowTabBar) {
        _windowTabBar = [[LLWindowTabBar alloc] init];
        _windowTabBar.actionDelegate = self;
    }
    return _windowTabBar;
}

@end
