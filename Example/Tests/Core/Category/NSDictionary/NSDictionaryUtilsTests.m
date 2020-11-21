//
//  NSDictionaryUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/2.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSDictionaryUtilsTestsModel : NSObject

@end

@implementation NSDictionaryUtilsTestsModel

- (NSString *)description {
    return @"<NSDictionaryUtilsTests>";
}

@end

@interface NSDictionaryUtilsTests : LLCoreTestCase

@end

@implementation NSDictionaryUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testStringDictionary {
    NSDictionary *dic = @{
        @"string" : @"String"
    };
    NSString *string = @"{\"string\":\"String\"}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testNumberDictionary {
    NSDictionary *dic = @{
        @"number" : @(1)
    };
    NSString *string = @"{\"number\":1}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testArrayDictionary {
    NSDictionary *dic = @{
        @"array" : @[@"1"]
    };
    NSString *string = @"{\"array\":\"[\\\"1\\\"]\"}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testDictionaryDictionary {
    NSDictionary *dic = @{
        @"dictionary" : @{
                @"key" : @"value"
        }
    };
    NSString *string = @"{\"dictionary\":\"{\\\"key\\\":\\\"value\\\"}\"}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testNullDictionary {
    NSDictionary *dic = @{
        @"null" : [NSNull null]
    };
    NSString *string = @"{\"null\":\"<Null>\"}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testObjectDictionary {
    NSDictionary *dic = @{
        @"object" : [NSDictionaryUtilsTestsModel new]
    };
    NSString *string = @"{\"object\":\"<NSDictionaryUtilsTests>\"}";
    XCTAssertTrue([[dic LL_jsonString] isEqualToString:string]);
}

- (void)testAddEntriesFromDictionary {
    NSDictionary *dic1 = @{
        @"key1" : @"value1"
    };
    NSDictionary *dic2 = @{
        @"key2" : @"value2"
    };
    NSDictionary *newDic = [dic1 LL_addEntriesFromDictionary:dic2];
    NSDictionary *targetDic = @{
        @"key1" : @"value1",
        @"key2" : @"value2"
    };
    XCTAssertTrue([newDic isEqualToDictionary:targetDic]);
}

- (void)testDisplayString {
    NSDictionary * dic = @{
        @"key" : @"value"
    };
    NSString *string = @"key : value\n";
    XCTAssertTrue([[dic LL_displayString] isEqualToString:string]);
}

- (void)testObjectForKey {
    NSDictionary * dic = @{
        @"key" : @"value"
    };
    XCTAssertTrue([[dic LL_objectForKey:@"key" targetClass:NSString.class] isEqualToString:@"value"]);
    XCTAssertNil([dic LL_objectForKey:@"key" targetClass:NSNumber.class]);
}

@end
