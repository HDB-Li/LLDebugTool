//
//  LLCrashDetailViewControllerTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/11/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCrashTestCase.h"

@interface LLCrashDetailViewControllerTests : LLCrashTestCase

@end

@implementation LLCrashDetailViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testViewController {
    LLCrashDetailViewController *vc = [[LLCrashDetailViewController alloc] init];
    XCTAssertNotNil(vc);
}

@end
