//
//  UIButtonUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIButtonUtilsTests : LLCoreTestCase

@end

@implementation UIButtonUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testBackgroundColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    XCTAssertNil(button.currentBackgroundImage);
    [button LL_setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    UIImage *image = button.currentBackgroundImage;
    XCTAssertNotNil(image);
    XCTAssertTrue([[image LL_hexColorAt:CGPointMake(1, 1)] isEqualToString:@"#FF0000"]);
}

@end
