//
//  LLBaseViewControllerTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/6.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseViewControllerTests : LLCoreTestCase

@end

@implementation LLBaseViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testViewController {
    LLBaseViewController *vc = [[LLBaseViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];;
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    XCTAssertTrue([vc.view.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    XCTAssertTrue(vc.updateBackgroundColor);
    XCTAssertTrue(vc.navigationItem.hidesBackButton);
    XCTAssertTrue(vc.navigationItem.leftBarButtonItems.count == 1);
    XCTAssertTrue([vc pointInside:CGPointMake(-1, -1) withEvent:[UIEvent new]]);
    XCTAssertFalse([vc shouldAutorotate]);
    XCTAssertTrue([vc supportedInterfaceOrientations] == UIInterfaceOrientationMaskPortrait);
    XCTAssertTrue([vc preferredInterfaceOrientationForPresentation] == UIInterfaceOrientationPortrait);
    LLDebugConfig *config = [[LLDebugConfig alloc] init];
    config.colorStyle = LLDebugConfigColorStyleOcean;
    XCTAssertTrue([vc.view.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    vc.updateBackgroundColor = NO;
    config.colorStyle = LLDebugConfigColorStyleGrass;
    XCTAssertFalse([vc.view.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    window.hidden = YES;
}

- (void)testWindowShow {
    LLBaseWindow *window = [[LLBaseWindow alloc] init];
    LLBaseViewController *vc = [[LLBaseViewController alloc] init];
    window.rootViewController = vc;
    [[LLWindowManager shared] showWindow:window animated:NO];
    XCTAssertTrue(vc.isShow);
    [[LLWindowManager shared] hideWindow:window animated:NO];
    XCTAssertFalse(vc.isShow);
}

@end
