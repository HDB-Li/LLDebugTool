//
//  LLComponentNavigationControllerTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentNavigationControllerTests : LLCoreTestCase

@end

@implementation LLComponentNavigationControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testController {
    LLComponentNavigationController *vc = [[LLComponentNavigationController alloc] init];
    XCTAssertNotNil(vc);
}

@end
