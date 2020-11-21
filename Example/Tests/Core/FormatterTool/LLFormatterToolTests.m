
//
//  LLFormatterToolTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLFormatterToolTests : LLCoreTestCase

@end

@implementation LLFormatterToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFormatterDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:57600];
    XCTAssertTrue([[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle1] isEqualToString:@"1970-01-02 00:00:00"]);
    XCTAssertTrue([[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle2] isEqualToString:@"1970-01-02"]);
    XCTAssertTrue([[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3] isEqualToString:@"1970-01-02 00:00:00"]);
    
    XCTAssertTrue([[LLFormatterTool dateFromString:@"1970-01-02 00:00:00" style:FormatterToolDateStyle1] isEqualToDate:date]);
    XCTAssertTrue([[LLFormatterTool dateFromString:@"1970-01-02" style:FormatterToolDateStyle2] isEqualToDate:date]);
    XCTAssertTrue([[LLFormatterTool dateFromString:@"1970-01-02 00:00:00" style:FormatterToolDateStyle3] isEqualToDate:date]);
}

- (void)testNumber {
    XCTAssertTrue([[LLFormatterTool formatNumber:@(1.234)] isEqualToString:@"1.23"]);
    XCTAssertTrue([[LLFormatterTool formatNumber:@(1.23)] isEqualToString:@"1.23"]);
    XCTAssertTrue([[LLFormatterTool formatNumber:@(1.20)] isEqualToString:@"1.2"]);
    XCTAssertTrue([[LLFormatterTool formatNumber:@(1.00)] isEqualToString:@"1"]);
}

- (void)formatLocation {
    XCTAssertTrue([[LLFormatterTool formatLocation:@(1.2345678)] isEqualToString:@"1.234567"]);
    XCTAssertTrue([[LLFormatterTool formatLocation:@(1.2300000)] isEqualToString:@"1.23"]);
    XCTAssertTrue([[LLFormatterTool formatLocation:@(1.0)] isEqualToString:@"1"]);
}

@end
