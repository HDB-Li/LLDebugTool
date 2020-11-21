//
//  LLComponentWindowTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentWindowTests : LLCoreTestCase

@end

@implementation LLComponentWindowTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWindow {
    LLComponentWindow *window = [[LLComponentWindow alloc] init];
    XCTAssertNotNil(window);
    window.action = LLDebugToolActionSetting;
    XCTAssertTrue(window.action == LLDebugToolActionSetting);
}

@end
