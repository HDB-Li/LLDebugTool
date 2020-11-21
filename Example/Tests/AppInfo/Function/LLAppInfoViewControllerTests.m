//
//  LLAppInfoViewControllerTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/11/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLAppInfoTestCase.h"

@interface LLAppInfoViewControllerTests : LLAppInfoTestCase

@end

@implementation LLAppInfoViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testViewController {
    LLAppInfoViewController *vc = [[LLAppInfoViewController alloc] init];
    XCTAssertNotNil(vc);
}

@end
