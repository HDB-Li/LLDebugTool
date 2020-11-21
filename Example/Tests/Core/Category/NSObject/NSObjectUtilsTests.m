//
//  NSObjectUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/2.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSObjectUtilsTests : LLCoreTestCase

@end

@implementation NSObjectUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLaunchDate {
    XCTAssertTrue([NSObject LL_launchDate].length > 0);
}


- (void)testStartLoadTime {
    XCTAssertTrue([NSObject LL_startLoadTime] > 0);
}

- (void)testHashColor {
    XCTAssertNotNil([NSObject new].LL_hashColor);
}

@end
