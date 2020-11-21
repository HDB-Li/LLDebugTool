//
//  LLBaseWindowTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/6.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseWindowTestsWindowScene : UIWindowScene

@end

@implementation LLBaseWindowTestsWindowScene

@end

@interface LLBaseWindowTests : LLCoreTestCase

@end

@implementation LLBaseWindowTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWindow {
    LLBaseWindow *window = [[LLBaseWindow alloc] init];
    XCTAssertTrue(window.windowLevel == kLLNormalWindowLevel);
    XCTAssertTrue(window.layer.masksToBounds);
    [[LLWindowManager shared] showWindow:window animated:NO];
    XCTAssertTrue(window.isShow);
    [[LLWindowManager shared] hideWindow:window animated:NO];
    XCTAssertFalse(window.isShow);
    XCTAssertFalse([window pointInside:CGPointMake(-1, -1) withEvent:[UIEvent new]]);
    window.rootViewController = [LLBaseViewController new];
    XCTAssertTrue([window pointInside:CGPointMake(-1, -1) withEvent:[UIEvent new]]);
}

@end
