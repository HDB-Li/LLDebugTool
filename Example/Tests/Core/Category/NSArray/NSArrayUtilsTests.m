//
//  NSArrayUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/1.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSArrayUtilsTestsModel : NSObject

@end

@implementation NSArrayUtilsTestsModel

- (NSString *)description {
    return @"<NSArrayUtilsTestsModel>";
}

@end

@interface NSArrayUtilsTests : LLCoreTestCase

@end

@implementation NSArrayUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testStringJsonString {
    NSArray *array = @[@"1", @"2"];
    NSString *string = @"[\"1\",\"2\"]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testNumberJsonString {
    NSArray *array = @[@(1), @(2)];
    NSString *string = @"[1,2]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testArrayJsonSString {
    NSArray *array = @[@[@(1)], @[@(2)]];
    NSString *string = @"[\"[1]\",\"[2]\"]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testDictionaryJsonString {
    NSArray *array = @[@{@"key":@"value"}];
    NSString *string = @"[\"{\\\"key\\\":\\\"value\\\"}\"]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testNullJsonString {
    NSArray *array = @[[NSNull null]];
    NSString *string = @"[\"<Null>\"]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testModelJsonString {
    NSArray *array = @[[NSArrayUtilsTestsModel new]];
    NSString *string = @"[\"<NSArrayUtilsTestsModel>\"]";
    XCTAssertTrue([[array LL_jsonString] isEqualToString:string]);
}

- (void)testObjectAtIndex {
    NSArray *array = @[@"1"];
    XCTAssertTrue([[array LL_objectAtIndex:0] isEqualToString:@"1"]);
    XCTAssertNil([array LL_objectAtIndex:1]);
}

@end
