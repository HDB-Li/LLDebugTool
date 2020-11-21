//
//  LLFilterDatePickerViewTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLFilterDatePickerViewTests : LLCoreTestCase

@end

@implementation LLFilterDatePickerViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:10000];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:20000];
    LLFilterDatePickerView *view = [[LLFilterDatePickerView alloc] initWithFrame:CGRectZero fromDate:date endDate:date2];
    XCTAssertNotNil(view);
}

@end
