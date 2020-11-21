//
//  UIColorUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIColorUtilsTests : LLCoreTestCase

@end

@implementation UIColorUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testColorWithHex {
    UIColor *color = [UIColor LL_colorWithHex:@"#FF0000"];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    color = [UIColor LL_colorWithHex:@"0xFF0000"];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    color = [UIColor LL_colorWithHex:@"FF0000"];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    color = [UIColor LL_colorWithHex:@"ff0000"];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
}

- (void)testColorWithHexAndError {
    BOOL error = NO;
    UIColor *color = [UIColor LL_colorWithHex:@"#FF0000" error:&error];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    XCTAssertFalse(error);
    color = [UIColor LL_colorWithHex:@"0xFF0000"];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    XCTAssertFalse(error);
    color = [UIColor LL_colorWithHex:@"FF0000" error:&error];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    XCTAssertFalse(error);
    color = [UIColor LL_colorWithHex:@"ff0000" error:&error];
    XCTAssertTrue([color isEqual:[UIColor redColor]]);
    XCTAssertFalse(error);
    color = [UIColor LL_colorWithHex:@"" error:&error];
    XCTAssertTrue([color isEqual:[UIColor blackColor]]);
    XCTAssertTrue(error);
    color = [UIColor LL_colorWithHex:@"0xxFF0000" error:&error];
    XCTAssertTrue([color isEqual:[UIColor blackColor]]);
    XCTAssertTrue(error);
}

- (void)testRGBA {
    UIColor *color = [[UIColor LL_colorWithHex:@"0xFF00FF"] colorWithAlphaComponent:0.5];
    NSArray *array = [color LL_RGBA];
    XCTAssertTrue(array.count == 4);
    XCTAssertTrue([array[0] floatValue] == 1);
    XCTAssertTrue([array[1] floatValue] == 0);
    XCTAssertTrue([array[2] floatValue] == 1);
    XCTAssertTrue([array[3] floatValue] == 0.5);
}

- (void)testHexString {
    UIColor *color = [UIColor LL_colorWithHex:@"0x3C021C"];
    XCTAssertTrue([[color LL_hexString] isEqualToString:@"#3C021C"]);
}

- (void)testDescription {
    UIColor *color = [UIColor clearColor];
    XCTAssertTrue([[color LL_description] isEqualToString:@"Clear Color"]);
    color = [UIColor redColor];
    XCTAssertTrue([[color LL_description] isEqualToString:@"redColor (#FF0000)"]);
    color = [UIColor LL_colorWithHex:@"F2F2F2"];
    XCTAssertTrue([[color LL_description] isEqualToString:@"#F2F2F2"]);
    color = [[UIColor LL_colorWithHex:@"#F2F2F2"] colorWithAlphaComponent:0.2];
    XCTAssertTrue([@"#F2F2F2, Alpha: 0.2" isEqualToString:[color LL_description]]);
}

- (void)testMixtureWithColor {
    UIColor *color1 = [UIColor redColor];
    UIColor *color2 = [UIColor greenColor];
    UIColor *mixtureColor = [color1 LL_mixtureWithColor:color2 radio:0.2];
    XCTAssertTrue([[mixtureColor LL_hexString] isEqualToString:@"#CC3300"]);
}

@end
