//
//  LLFilterLabelCellTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLFilterLabelCellTests : LLCoreTestCase

@end

@implementation LLFilterLabelCellTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCell {
    LLFilterLabelCell *cell = [[LLFilterLabelCell alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(cell);
}

@end
