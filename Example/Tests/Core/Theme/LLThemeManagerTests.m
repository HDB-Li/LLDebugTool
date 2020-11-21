//
//  LLThemeManagerTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLThemeManagerTests : LLCoreTestCase

@end

@implementation LLThemeManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testManager {
    XCTAssertNotNil([LLThemeManager systemTintColor]);
    XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:LLDebugToolUpdateThemeNotification];
    LLThemeManager *manager = [[LLThemeManager alloc] init];
    [manager updateWithColorStyle:LLDebugConfigColorStylePro];
    XCTAssertTrue([manager.themeColor isEqual:[LLThemeColor proThemeColor]]);
    XCTAssertTrue([manager.primaryColor isEqual:[LLThemeColor proThemeColor].primaryColor]);
    XCTAssertTrue([manager.backgroundColor isEqual:[LLThemeColor proThemeColor].backgroundColor]);
    XCTAssertTrue([manager.containerColor isEqual:[LLThemeColor proThemeColor].containerColor]);
    XCTAssertTrue([manager.placeHolderColor isEqual:[LLThemeColor proThemeColor].placeHolderColor]);
    XCTAssertTrue(manager.statusBarStyle == [LLThemeColor proThemeColor].statusBarStyle);
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
