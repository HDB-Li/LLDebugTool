//
//  LLConstTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLConstTests : LLCoreTestCase

@end

@implementation LLConstTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testConst {
    // Core
    XCTAssertTrue(kLLGeneralMargin == 10);
    XCTAssertTrue(kLLPresentWindowLevel == UIWindowLevelStatusBar - 200);
    XCTAssertTrue(kLLNormalWindowLevel == UIWindowLevelStatusBar - 300);
    XCTAssertTrue(kLLEntryWindowLevel == UIWindowLevelStatusBar + 1);

    // Entry
    XCTAssertTrue(kLLEntryWindowBallWidth == 50);
    XCTAssertTrue(kLLEntryWindowMinBallWidth == 30);
    XCTAssertTrue(kLLEntryWindowMaxBallWidth == 70);
    XCTAssertTrue(kLLEntryWindowDisplayPercent == 1 - 0.618);   // Golden section search.
    XCTAssertTrue(kLLEntryWindowMinDisplayPercent == 0.1);
    XCTAssertTrue(kLLEntryWindowMaxDisplayPercent == 1);
    XCTAssertTrue(kLLEntryWindowFirstDisplayPositionX == 0);
    XCTAssertTrue(kLLEntryWindowFirstDisplayPositionY == 200);
    XCTAssertTrue(kLLInactiveAlpha == 0.75);
    XCTAssertTrue(kLLDisplayInactiveAlpha == 0.90);
    XCTAssertTrue(kLLActiveAlpha == 1.0);
    XCTAssertTrue(kLLActiveDuration == 10);
    XCTAssertTrue(kLLMinActiveDuration == 1);

    // App Info
    XCTAssertTrue(kLLStuckTime == 33);
    XCTAssertTrue(kLLMinStuckTime == 17);
    XCTAssertTrue(kLLMaxStuckTime == 10000);

    // Magnifier
    XCTAssertTrue(kLLMagnifierWindowZoomLevel == 10);
    XCTAssertTrue(kLLMagnifierWindowMinZoomLevel == 6);
    XCTAssertTrue(kLLMagnifierWindowMaxZoomLevel == 14);
    XCTAssertTrue(kLLMagnifierWindowSize == 15);
    XCTAssertTrue(kLLMagnifierWindowMinSize == 9);
    XCTAssertTrue(kLLMagnifierWindowMaxSize == 21);

    // Ruler
    XCTAssertTrue(kLLRulerLineWidth == 1);

    // Widget border
    XCTAssertTrue(kLLWidgetBorderWidth == 1);

    // Location
    XCTAssertTrue(kLLDefaultMockLocationLatitude == 39.908722);
    XCTAssertTrue(kLLDefaultMockLocationLongitude == 116.397499);
    XCTAssertTrue(kLLDefaultMockRouteTimeInterval == 2);

}

@end
