//
//  NSStringUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/2.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSStringUtilsTests : LLCoreTestCase

@end

@implementation NSStringUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testJsonDictionary {
    NSString *string = @"{\"key\":\"value\"}";
    NSDictionary *dic = @{@"key":@"value"};
    XCTAssertTrue([[string LL_jsonDictionary] isEqualToDictionary:dic]);
    XCTAssertNil([@"" LL_jsonDictionary]);
}

- (void)testJsonArray {
    NSString *string = @"[1,2]";
    NSArray *array = @[@(1), @(2)];
    XCTAssertTrue([[string LL_jsonArray] isEqualToArray:array]);
    XCTAssertNil([@"" LL_jsonArray]);
}

- (void)testByteLength {
    NSString *str = @"test";
    XCTAssertTrue(str.LL_byteLength == 2);
    str = @"test1";
    XCTAssertTrue(str.LL_byteLength == 3);
    str = @"test12";
    XCTAssertTrue(str.LL_byteLength == 3);
    str = @"测试";
    XCTAssertTrue(str.LL_byteLength == 2);
}

- (void)testHeight {
    XCTAssertTrue([@"" LL_heightWithAttributes:nil maxWidth:100 minHeight:10] == 0);
    NSString *str = @"test";
    CGFloat height = [str LL_heightWithAttributes:nil maxWidth:100 minHeight:10];
    CGFloat height2 = floor([str boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.height + 4);
    XCTAssertTrue(height == height2);
    
}

@end
