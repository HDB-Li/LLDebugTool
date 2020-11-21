//
//  LLTitleSwitchCellTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLTitleSwitchCellTests : LLCoreTestCase

@end

@implementation LLTitleSwitchCellTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCell {
    LLTitleSwitchCell *cell = [[LLTitleSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    XCTAssertNotNil(cell);
}

@end
