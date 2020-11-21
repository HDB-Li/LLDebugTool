//
//  LLCrashHelperTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/11/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCrashTestCase.h"

@interface LLCrashHelperTests : LLCrashTestCase

@end

@implementation LLCrashHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testHelper {
    LLCrashHelper *helper = [[LLCrashHelper alloc] init];
    XCTAssertNotNil(helper);
}

@end
