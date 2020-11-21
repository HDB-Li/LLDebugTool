//
//  NSUserDefaultsUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSUserDefaultsUtilsTests : LLCoreTestCase

@end

@implementation NSUserDefaultsUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testString {
    NSString *key = @"test";
    [NSUserDefaults LL_setString:nil forKey:key];
    XCTAssertNil([NSUserDefaults LL_stringForKey:key]);
    [NSUserDefaults LL_setString:key forKey:key];
    XCTAssertTrue([[NSUserDefaults LL_stringForKey:key] isEqualToString:key]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] stringForKey:key]);
    XCTAssertTrue([[[NSUserDefaults standardUserDefaults] stringForKey:@"LLDebugTool-test"] isEqualToString:key]);
    [NSUserDefaults LL_setString:nil forKey:key];
    XCTAssertNil([NSUserDefaults LL_stringForKey:key]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] stringForKey:@"LLDebugTool-test"]);
}

- (void)testInteger {
    NSString *key = @"test";
    [NSUserDefaults LL_setInteger:0 forKey:key];
    XCTAssertTrue([NSUserDefaults LL_integerForKey:key] == 0);
    [NSUserDefaults LL_setInteger:1 forKey:key];
    XCTAssertTrue([NSUserDefaults LL_integerForKey:key] == 1);
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] integerForKey:key] == 0);
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] integerForKey:@"LLDebugTool-test"] == 1);
    [NSUserDefaults LL_setInteger:0 forKey:key];
    XCTAssertTrue([NSUserDefaults LL_integerForKey:key] == 0);
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] integerForKey:@"LLDebugTool-test"] == 0);
}

- (void)testNumber {
    NSString *key = @"test";
    [NSUserDefaults LL_setNumber:nil forKey:key];
    XCTAssertNil([NSUserDefaults LL_numberForKey:key]);
    [NSUserDefaults LL_setNumber:@(1) forKey:key];
    XCTAssertTrue([[NSUserDefaults LL_numberForKey:key] isEqualToNumber:@(1)]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:key]);
    XCTAssertTrue([[[NSUserDefaults standardUserDefaults] objectForKey:@"LLDebugTool-test"] isEqualToNumber:@(1)]);
    [NSUserDefaults LL_setNumber:nil forKey:key];
    XCTAssertNil([NSUserDefaults LL_numberForKey:key]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"LLDebugTool-test"]);
}

- (void)testBool {
    NSString *key = @"test";
    [NSUserDefaults LL_setBool:NO forKey:key];
    XCTAssertFalse([NSUserDefaults LL_boolForKey:key]);
    [NSUserDefaults LL_setBool:YES forKey:key];
    XCTAssertTrue([NSUserDefaults LL_boolForKey:key]);
    XCTAssertFalse([[NSUserDefaults standardUserDefaults] boolForKey:key]);
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] boolForKey:@"LLDebugTool-test"]);
    [NSUserDefaults LL_setBool:NO forKey:key];
    XCTAssertFalse([NSUserDefaults LL_boolForKey:key]);
    XCTAssertFalse([[NSUserDefaults standardUserDefaults] boolForKey:@"LLDebugTool-test"]);
}

@end
