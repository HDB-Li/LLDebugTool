//
//  UIViewControllerUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/4.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIViewControllerUtilsTests : LLCoreTestCase

@end

@implementation UIViewControllerUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCurrentShowingViewController {
    UIViewController *vc = [[UIViewController alloc] init];
    XCTAssertTrue(vc.LL_currentShowingViewController == vc);
}

- (void)testCurrentShowingViewControllerInPresent {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:NSStringFromSelector(_cmd)];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    UIViewController *vc2 = [[UIViewController alloc] init];
    [vc presentViewController:vc2 animated:NO completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        XCTAssertTrue(vc.LL_currentShowingViewController == vc2);
        [window removeFromSuperview];
    });
    [self waitForExpectations:@[expectation] timeout:2];
}

- (void)testCurrentShowingViewControllerInTabBar {
    UIViewController *vc = [[UIViewController alloc] init];
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[[UIViewController new], vc];
    tab.selectedIndex = 1;
    XCTAssertTrue(tab.LL_currentShowingViewController == vc);
}

- (void)testCurrentShowingViewControllerInNavigation {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    XCTAssertTrue(nav.LL_currentShowingViewController == vc);
    UIViewController *vc2 = [[UIViewController alloc] init];
    [nav pushViewController:vc2 animated:NO];
    XCTAssertTrue(nav.LL_currentShowingViewController == vc2);
}

- (void)testNavigationButton {
    UIButton *button = [[UIViewController new] LL_navigationButtonWithTitle:@"title" imageName:kSelectorBlueImageName target:self action:@selector(testNavigationButton)];
    XCTAssertNotNil(button);
    XCTAssertTrue([button.currentTitle isEqualToString:@"title"]);
    XCTAssertNotNil(button.currentImage);
}

- (void)testAlertController {
    UIViewController *vc = [[UIViewController alloc] init];
    [vc LL_showConfirmAlertControllerWithMessage:@"message" handler:nil];
    [vc LL_showAlertControllerWithMessage:@"message" handler:nil];
    [vc LL_showAlertControllerWithTitle:@"title" message:@"message" handler:nil];
    [vc LL_showActionSheetWithTitle:@"title" actions:@[@"1", @"2"] currentAction:@"1" completion:nil];
    [vc LL_showTextFieldAlertControllerWithMessage:@"message" text:nil handler:nil];
}

@end
