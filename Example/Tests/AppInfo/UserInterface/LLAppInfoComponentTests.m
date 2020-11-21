//
//  LLAppInfoComponentTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/11/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLAppInfoTestCase.h"

@interface LLAppInfoComponentTests : LLAppInfoTestCase

@end

@implementation LLAppInfoComponentTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testComponent {
    XCTAssertTrue([LLAppInfoComponent baseViewController] == LLAppInfoViewController.class);
    XCTAssertTrue([[LLAppInfoComponent baseWindow] isKindOfClass:[LLAppInfoWindow class]]);
}

@end
