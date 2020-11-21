//
//  LLScreenshotToolTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLScreenshotToolTests : LLCoreTestCase

@end

@implementation LLScreenshotToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTool {
    UIImage *image = [LLScreenshotTool screenshotWithScale:2];
    XCTAssertNotNil(image);
    XCTAssertTrue(CGSizeEqualToSize(image.size, CGSizeMake(LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT)));
    XCTAssertTrue(image.scale == 2);
}
@end
