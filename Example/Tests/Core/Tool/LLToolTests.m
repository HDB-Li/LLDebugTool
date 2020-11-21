//
//  LLToolTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/9.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLToolTests : LLCoreTestCase

@end

@implementation LLToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testIdentity {
    NSInteger identity = [[LLTool absolutelyIdentity] intValue];
    XCTAssertTrue(identity == [[LLTool absolutelyIdentity] intValue] - 1);
}

- (void)testCreateDirectory {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path]);
    XCTAssertTrue([LLTool createDirectoryAtPath:path]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
    [LLTool removePath:path];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

- (void)testRectWithPoint {
    CGPoint point = CGPointMake(0, 1);
    CGPoint point2 = CGPointMake(1, 0);
    XCTAssertTrue(CGRectEqualToRect(CGRectMake(0, 0, 1, 1), [LLTool rectWithPoint:point otherPoint:point2]));
    point2 = CGPointMake(1, 1);
    XCTAssertTrue(CGRectEqualToRect(CGRectMake(0, 1, 1, 0.5), [LLTool rectWithPoint:point otherPoint:point2]));
    point = CGPointMake(1, 2);
    XCTAssertTrue(CGRectEqualToRect(CGRectMake(1, 1, 0.5, 1), [LLTool rectWithPoint:point otherPoint:point2]));
}

- (void)testStringFromFrame {
    CGRect rect = CGRectMake(0.123, 0.123, 0.123, 0.123);
    XCTAssertTrue([[LLTool stringFromFrame:rect] isEqualToString:@"{{0.12, 0.12}, {0.12, 0.12}}"]);
}

- (void)testTopWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = 100000;
    [window makeKeyAndVisible];
    XCTAssertTrue([LLTool topWindow] == window);
    window.hidden = NO;
}

- (void)testKeyWindow {
    XCTAssertTrue([LLTool keyWindow] == [UIApplication sharedApplication].keyWindow);
}

- (void)testDelegateWindow {
    XCTAssertTrue([LLTool delegateWindow] == [UIApplication sharedApplication].delegate.window);
}

- (void)testStatusBarClickable {
    if (@available(iOS 13.0, *)) {
        XCTAssertFalse([LLTool statusBarClickable]);
    } else {
        XCTAssertTrue([LLTool statusBarClickable]);
    }
}

- (void)testGetUIStatusBarModern {
    XCTAssertNotNil([LLTool getUIStatusBarModern]);
}

- (void)testStartWorking {
    [[LLDebugTool sharedTool] stopWorking];
    [LLTool startWorking];
    XCTAssertTrue([LLDebugTool sharedTool].isWorking);
}

@end
