//
//  LLInfoViewTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLInfoViewTests : LLCoreTestCase

@end

@implementation LLInfoViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    LLInfoView *view = [[LLInfoView alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(view);
}

@end
