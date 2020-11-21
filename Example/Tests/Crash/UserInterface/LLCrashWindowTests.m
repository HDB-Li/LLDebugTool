//
//  LLCrashWindowTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/11/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCrashTestCase.h"

@interface LLCrashWindowTests : LLCrashTestCase

@end

@implementation LLCrashWindowTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWindow {
    LLCrashWindow *window = [[LLCrashWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XCTAssertNotNil(window);
}

@end
