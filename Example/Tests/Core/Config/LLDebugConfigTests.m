//
//  LLDebugConfigTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLDebugConfigTests : LLCoreTestCase

@end

@implementation LLDebugConfigTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDefaultSettings {
    LLDebugConfig *config = [[LLDebugConfig alloc] init];
    XCTAssertTrue(config.entryWindowStyle == LLDebugConfigEntryWindowStyleAppInfo);
    XCTAssertTrue(config.entryWindowBallWidth == kLLEntryWindowBallWidth);
    XCTAssertTrue(config.entryWindowDisplayPercent == kLLEntryWindowDisplayPercent);
    XCTAssertTrue(CGPointEqualToPoint(config.entryWindowFirstDisplayPosition, CGPointMake(kLLEntryWindowFirstDisplayPositionX, kLLEntryWindowFirstDisplayPositionY)));
    XCTAssertTrue(config.inactiveAlpha == kLLInactiveAlpha);
    XCTAssertTrue(config.activeAlpha == kLLActiveAlpha);
    XCTAssertTrue(config.isShrinkToEdgeWhenInactive);
    XCTAssertTrue(config.activeDuration == kLLActiveDuration);
    XCTAssertTrue(config.isShakeToHide);
    XCTAssertTrue(config.colorStyle == LLDebugConfigColorStyleHack);
    XCTAssertNil(config.observerdHosts);
    XCTAssertNil(config.ignoredHosts);
    XCTAssertFalse(config.observerWebView);
    XCTAssertTrue(config.logStyle == LLDebugConfigLogDetail);
    XCTAssertTrue(config.isHierarchyIgnorePrivateClass);
    XCTAssertFalse(config.includeParent);
    XCTAssertTrue(config.magnifierZoomLevel == kLLMagnifierWindowZoomLevel);
    XCTAssertTrue(config.magnifierSize == kLLMagnifierWindowSize);
    XCTAssertFalse(config.isShowWidgetBorder);
    XCTAssertNil(config.defaultHtmlUrl);
    XCTAssertNil(config.webViewClass);
    XCTAssertNil(config.htmlViewControllerProvider);
    XCTAssertTrue(config.stuckTime == kLLStuckTime);
    XCTAssertFalse(config.mockLocation);
    XCTAssertTrue(config.mockLocationLatitude == 0);
    XCTAssertTrue(config.mockLocationLongitude == 0);
    XCTAssertTrue(config.mockRouteTimeInterval == kLLDefaultMockRouteTimeInterval);
    XCTAssertTrue([config.dateFormatter isEqualToString:@"yyyy-MM-dd HH:mm:ss"]);
    XCTAssertNil(config.userIdentity);
    XCTAssertTrue(config.isShowDebugToolLog);
    XCTAssertFalse(config.hideWhenInstall);
    XCTAssertTrue(config.startWorkingNextTime);
    XCTAssertTrue(config.clickAction == LLDebugToolActionFeature);
    XCTAssertTrue(config.doubleClickAction == LLDebugToolActionHierarchy);
    XCTAssertTrue([config.folderPath isEqualToString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LLDebugTool"]]);
    XCTAssertNotNil(config.imageBundle);
}

- (void)testGetterAndSetter {
    LLDebugConfig *config = [[LLDebugConfig alloc] init];
    config.colorStyle = LLDebugConfigColorStyleGrass;
    XCTAssertTrue([[LLThemeManager shared].primaryColor isEqual:[LLThemeColor grassThemeColor].primaryColor]);
    
    XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:LLDebugToolUpdateWindowStyleNotification];
    config.entryWindowStyle = LLDebugConfigEntryWindowStyleNetBar;
    if (@available(iOS 13.0, *)) {
        XCTAssertTrue(config.entryWindowStyle == LLDebugConfigEntryWindowStyleTitle);
    } else {
        XCTAssertTrue(config.entryWindowStyle == LLDebugConfigEntryWindowStyleNetBar);
    }
    
    config.entryWindowBallWidth = 10;
    XCTAssertTrue(config.entryWindowBallWidth == kLLEntryWindowMinBallWidth);
    config.entryWindowBallWidth = 100;
    XCTAssertTrue(config.entryWindowBallWidth == kLLEntryWindowMaxBallWidth);
    
    config.entryWindowDisplayPercent = 0;
    XCTAssertTrue(config.entryWindowDisplayPercent == kLLEntryWindowMinDisplayPercent);
    config.entryWindowDisplayPercent = 2;
    XCTAssertTrue(config.entryWindowDisplayPercent == kLLEntryWindowMaxDisplayPercent);
    
    config.activeDuration = 0;
    XCTAssertTrue(config.activeDuration == kLLMinActiveDuration);
    
    config.stuckTime = 0;
    XCTAssertTrue(config.stuckTime == kLLMinStuckTime);
    config.stuckTime = 100000;
    XCTAssertTrue(config.stuckTime == kLLMaxStuckTime);
    
    config.magnifierSize = 4;
    XCTAssertTrue(config.magnifierSize == 5);
    config.magnifierSize = 7;
    XCTAssertTrue(config.magnifierSize == 7);
    
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
