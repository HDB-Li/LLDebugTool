//
//  LLWindowManagerTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/9.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLWindowManagerTests : LLCoreTestCase

@end

@implementation LLWindowManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWindow {
    LLComponentWindow *window = [[LLComponentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LLWindowManager *manager = [[LLWindowManager alloc] init];
    XCTAssertNil([manager visibleWindow]);
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:NSStringFromSelector(_cmd)];
    [manager showWindow:window animated:NO completion:^{
        [expectation fulfill];
    }];
    XCTAssertTrue([manager visibleWindow] == window);
    XCTestExpectation *expectation2 = [[XCTestExpectation alloc] initWithDescription:NSStringFromSelector(_cmd)];
    [manager hideWindow:window animated:NO completion:^{
        [expectation2 fulfill];
    }];
    [manager showWindow:window animated:NO];
    XCTAssertNotNil([manager visibleWindow]);
    [manager removeAllVisibleWindows];
    XCTAssertNil([manager visibleWindow]);
}

@end
