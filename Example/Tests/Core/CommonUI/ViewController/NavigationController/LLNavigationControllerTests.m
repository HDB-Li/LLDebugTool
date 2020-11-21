//
//  LLNavigationControllerTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLNavigationControllerTests : LLCoreTestCase

@end

@implementation LLNavigationControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testController {
    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    XCTAssertNotNil(nav);
}

@end
