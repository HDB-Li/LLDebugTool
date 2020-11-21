//
//  LLCrashModelTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/11/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCrashTestCase.h"

@interface LLCrashModelTests : LLCrashTestCase

@end

@implementation LLCrashModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModel {
    NSString *name = @"name";
    NSString *reason = @"reason";
    NSDictionary *userInfo = @{@"key" : @"value"};
    NSArray *stack = @[@"1"];
    NSString *date = @"date";
    NSString *thread = @"thread";
    NSString *identity = @"identity";
    NSString *appInfo = @"appInfo";
    NSString *launch = @"launch";
    LLCrashModel *model = [[LLCrashModel alloc] initWithName:name reason:reason userInfo:userInfo stackSymbols:stack date:date thread:thread userIdentity:identity appInfoDescription:appInfo launchDate:launch];
    XCTAssertNotNil(model);
    XCTAssertTrue([model.name isEqualToString:name]);
    XCTAssertTrue([model.reason isEqualToString:reason]);
    XCTAssertTrue([model.userInfo isEqualToDictionary:userInfo]);
    XCTAssertTrue([model.stackSymbols isEqualToArray:stack]);
    XCTAssertTrue([model.date isEqualToString:date]);
    XCTAssertTrue([model.thread isEqualToString:thread]);
    XCTAssertTrue([model.identity isEqualToString:identity]);
    XCTAssertTrue([model.appInfoDescription isEqualToString:appInfo]);
    XCTAssertTrue([model.launchDate isEqualToString:launch]);
}

@end
