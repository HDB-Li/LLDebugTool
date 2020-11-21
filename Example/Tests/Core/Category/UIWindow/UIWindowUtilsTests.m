//
//  UIWindowUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/4.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIWindowUtilsTestsWindow : UIWindow

@end

@implementation UIWindowUtilsTestsWindow

- (BOOL)LL_canBecomeKeyWindow {
    return NO;
}

@end

@interface UIWindowUtilsTests : LLCoreTestCase

@end

@implementation UIWindowUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCurrentShowingViewController {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XCTAssertNil(window.LL_currentShowingViewController);
    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;
    XCTAssertTrue(window.LL_currentShowingViewController == vc);
}

- (void)testCanBecomeKeyWindow {
    UIWindow *window = [[UIWindow alloc] init];
    XCTAssertTrue([window LL_canBecomeKeyWindow]);
    window = [[UIWindowUtilsTestsWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XCTAssertFalse([window LL_canBecomeKeyWindow]);
}

@end
