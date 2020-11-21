//
//  LLInternalMacrosTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLInternalMacrosTests : LLCoreTestCase

@end

@implementation LLInternalMacrosTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMacros {
    XCTAssertTrue(LL_SCREEN_WIDTH == [UIScreen mainScreen].bounds.size.width);
    XCTAssertTrue(LL_SCREEN_HEIGHT == [UIScreen mainScreen].bounds.size.height);
    if (LL_IS_SPECIAL_SCREEN) {
        XCTAssertTrue(LL_STATUS_BAR_HEIGHT == 44);
        XCTAssertTrue(LL_NAVIGATION_HEIGHT == 88);
        XCTAssertTrue(LL_BOTTOM_DANGER_HEIGHT == 34);
    } else {
        XCTAssertTrue(LL_STATUS_BAR_HEIGHT == 20);
        XCTAssertTrue(LL_NAVIGATION_HEIGHT == 64);
        XCTAssertTrue(LL_BOTTOM_DANGER_HEIGHT == 0);
    }
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {
            XCTAssertTrue(LL_IS_SPECIAL_SCREEN);
        } else {
            XCTAssertFalse(LL_IS_SPECIAL_SCREEN);
        }
    } else {
        XCTAssertFalse(LL_IS_SPECIAL_SCREEN);
    }
    XCTAssertTrue(LL_LAYOUT_HORIZONTAL(414) == LL_SCREEN_WIDTH);
    XCTAssertTrue(LL_MIN(1, 2) == 1);
    XCTAssertTrue(LL_MAX(1, 2) == 2);
    
}

@end
