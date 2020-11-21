//
//  LLBaseCollectionViewCellTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/5.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseCollectionViewCellTestsCell : LLBaseCollectionViewCell

@property (nonatomic, assign) BOOL isCalledInitUI;

@end

@implementation LLBaseCollectionViewCellTestsCell

- (void)initUI {
    [super initUI];
    self.isCalledInitUI = YES;
}

@end

@interface LLBaseCollectionViewCellTests : LLCoreTestCase

@end

@implementation LLBaseCollectionViewCellTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCell {
    LLBaseCollectionViewCellTestsCell *cell = [[LLBaseCollectionViewCellTestsCell alloc] initWithFrame:CGRectZero];
    XCTAssertTrue(cell.isCalledInitUI);
}

@end
