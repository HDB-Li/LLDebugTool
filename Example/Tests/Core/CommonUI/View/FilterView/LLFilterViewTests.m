//
//  LLFilterViewTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLFilterViewTests : LLCoreTestCase

@end

@implementation LLFilterViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    LLFilterView *view = [[LLFilterView alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(view);
}

@end
