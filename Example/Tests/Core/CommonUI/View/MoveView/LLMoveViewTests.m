//
//  LLMoveViewTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLMoveViewTests : LLCoreTestCase

@end

@implementation LLMoveViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    LLMoveView *view = [[LLMoveView alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(view);
}

@end
