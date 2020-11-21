//
//  LLBaseComponentTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

static LLComponentWindow *_baseWindow = nil;
static BOOL _isValid = YES;

@interface LLBaseComponentTestsComponent : LLBaseComponent

@end

@implementation LLBaseComponentTestsComponent

+ (LLComponentWindow *)baseWindow {
    return _baseWindow;
}

+ (BOOL)isValid {
    return _isValid;
}

+ (NSDictionary<LLComponentDelegateKey,id> *)verificationData:(NSDictionary<LLComponentDelegateKey,id> *)data {
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData addEntriesFromDictionary:data];
    newData[@"test"] = @"test";
    return [newData copy];
}

@end

@interface LLBaseComponentTests : LLCoreTestCase

@end

@implementation LLBaseComponentTests

- (void)setUp {
    _baseWindow.hidden = YES;
    _baseWindow = [[LLComponentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _isValid = YES;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testComponent {
    XCTAssertTrue([LLBaseComponentTestsComponent componentDidLoad:nil]);
}

- (void)testIsValid {
    _isValid = NO;
    XCTAssertFalse([LLBaseComponentTestsComponent componentDidLoad:nil]);
}

@end
