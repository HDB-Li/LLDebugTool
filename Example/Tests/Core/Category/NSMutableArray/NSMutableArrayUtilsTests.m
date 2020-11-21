//
//  NSMutableArrayUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/2.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSMutableArrayUtilsTests : LLCoreTestCase

@end

@implementation NSMutableArrayUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAddObject {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    XCTAssertTrue(array.count == 0);
    [array LL_addObject:@"1"];
    XCTAssertTrue(array.count == 1);
    NSString *str = nil;
    [array LL_addObject:str];
    XCTAssertTrue(array.count == 1);
}

- (void)testInsertObject {
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"1", @"2", nil];
    XCTAssertTrue(array.count == 2);
    [array LL_insertObject:@"3" atIndex:3];
    XCTAssertTrue(array.count == 2);
    [array LL_insertObject:@"3" atIndex:2];
    XCTAssertTrue(array.count == 3);
    XCTAssertTrue([array[2] isEqualToString:@"3"]);
}

@end
