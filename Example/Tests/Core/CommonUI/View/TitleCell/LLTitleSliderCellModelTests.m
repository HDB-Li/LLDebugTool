//
//  LLTitleSliderCellModelTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLTitleSliderCellModelTests : LLCoreTestCase

@end

@implementation LLTitleSliderCellModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModel {
    LLTitleSliderCellModel *model = [LLTitleSliderCellModel modelWithTitle:@"title" value:2 minValue:1 maxValue:3];
    XCTAssertNotNil(model);
    XCTAssertTrue([model.title isEqualToString:@"title"]);
    XCTAssertTrue(model.value == 2);
    XCTAssertTrue(model.minValue == 1);
    XCTAssertTrue(model.maxValue == 3);
}

@end
