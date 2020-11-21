//
//  UIResponderUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIResponderUtilsTests : LLCoreTestCase

@end

@implementation UIResponderUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNotification {
    XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:LLDebugToolShakeNotification];
    [[UIResponder new] motionBegan:UIEventSubtypeMotionShake withEvent:nil];
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
