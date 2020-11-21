//
//  LLComponentCoreTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentCoreTests : LLCoreTestCase

@end

@implementation LLComponentCoreTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCore {
    LLComponentCore *core = [[LLComponentCore alloc] init];
    XCTAssertNotNil(core.entryHelper);
    XCTAssertNotNil(core.featureHelper);
    XCTAssertNotNil(core.settingHelper);
    XCTAssertNotNil(core.networkHelper);
    XCTAssertNotNil(core.logHelper);
    XCTAssertNotNil(core.crashHelper);
    XCTAssertNotNil(core.appInfoHelper);
    XCTAssertNotNil(core.sandboxHelper);
    XCTAssertNotNil(core.screenshotHelper);
    XCTAssertNotNil(core.hierarchyHelper);
    XCTAssertNotNil(core.magnifierHelper);
    XCTAssertNotNil(core.rulerHelper);
    XCTAssertNotNil(core.widgetBorderHelper);
    XCTAssertNotNil(core.htmlHelper);
    XCTAssertNotNil(core.locationHelper);
    XCTAssertNotNil(core.shortCutHelper);
}

@end
