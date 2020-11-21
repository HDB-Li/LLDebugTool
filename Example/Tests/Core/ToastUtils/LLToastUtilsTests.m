//
//  LLToastUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/9.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLToastUtilsTests : LLCoreTestCase

@end

@implementation LLToastUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLoading {
    __block UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    
    LLToastUtils *toastUtils = [[LLToastUtils alloc] init];
    NSInteger count = window.subviews.count;
    [toastUtils loadingMessage:@"test"];
    XCTAssertTrue(window.subviews.count == count + 1);
    __block XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:NSStringFromSelector(_cmd)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            XCTAssertTrue(window.subviews.count == count + 1);
             window.hidden = YES;
            [expectation fulfill];
        });
    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        XCTAssertTrue(window.subviews.count == count + 1);
//         window.hidden = YES;
//        [expectation fulfill];
//    });
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testToast {
    __block UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    
    LLToastUtils *toastUtils = [[LLToastUtils alloc] init];
    NSInteger count = window.subviews.count;
    [toastUtils toastMessage:@"test"];
    XCTAssertTrue(window.subviews.count == count + 1);
    __block XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:NSStringFromSelector(_cmd)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue(window.subviews.count == count + 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssertTrue(window.subviews.count == count);
            window.hidden = YES;
            [expectation fulfill];
        });
    });
    [self waitForExpectations:@[expectation] timeout:4];
}

@end
