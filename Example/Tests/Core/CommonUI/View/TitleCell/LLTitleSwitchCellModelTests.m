//
//  LLTitleSwitchCellModelTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLTitleSwitchCellModelTests : LLCoreTestCase

@end

@implementation LLTitleSwitchCellModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModel {
    LLTitleSwitchCellModel *model = [LLTitleSwitchCellModel modelWithTitle:@"title" isOn:YES];
    XCTAssertNotNil(model);
    XCTAssertTrue([model.title isEqualToString:@"title"]);
    XCTAssertTrue(model.isOn);
}

@end
