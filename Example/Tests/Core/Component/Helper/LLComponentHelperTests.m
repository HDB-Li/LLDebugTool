//
//  LLComponentHelperTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentHelperTestsHelper : LLComponentHelper

@property (nonatomic, assign) BOOL isCalledStart;
@property (nonatomic, assign) BOOL isCalledStop;

@end

@implementation LLComponentHelperTestsHelper

- (void)start {
    [super start];
    self.isCalledStart = YES;
}

- (void)stop {
    [super stop];
    self.isCalledStop = YES;
}

@end

@interface LLComponentHelperTests : LLCoreTestCase

@end

@implementation LLComponentHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testHelper {
    LLComponentHelperTestsHelper *helper = [[LLComponentHelperTestsHelper alloc] init];
    helper.enabled = YES;
    XCTAssertTrue(helper.isCalledStart);
    helper.enabled = NO;
    XCTAssertTrue(helper.isCalledStop);
}

@end
