//
//  LLDetailTitleCellModelTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLDetailTitleCellModelTests : LLCoreTestCase

@end

@implementation LLDetailTitleCellModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModel {
    LLDetailTitleCellModel *model = [LLDetailTitleCellModel modelWithTitle:@"title" detailTitle:@"detailTitle"];
    XCTAssertNotNil(model);
    XCTAssertTrue([model.title isEqualToString:@"title"]);
    XCTAssertTrue([model.detailTitle isEqualToString:@"detailTitle"]);
}

@end
