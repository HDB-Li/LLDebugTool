//
//  LLAppInfoHelperTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/11/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLAppInfoTestCase.h"

@interface LLAppInfoHelperTests : LLAppInfoTestCase

@end

@implementation LLAppInfoHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testHelper {
    XCTAssertTrue([LLAppInfoHelper conformsToProtocol:@protocol(LLAppInfoHelperDelegate)]);
    LLAppInfoHelper *helper = [[LLAppInfoHelper alloc] init];
    helper.enabled = YES;
    XCTAssertNotNil(helper.cpuUsage);
    XCTAssertNotNil(helper.maxInterval);
    XCTAssertNotNil(helper.freeMemory);
    XCTAssertNotNil(helper.usedMemory);
    XCTAssertNotNil(helper.totalMemory);
    XCTAssertNotNil(helper.memoryUsage);
    XCTAssertNotNil(helper.fps);
    XCTAssertNotNil(helper.totalDataTraffic);
    XCTAssertNotNil(helper.requestDataTraffic);
    XCTAssertNotNil(helper.responseDataTraffic);
    XCTAssertNotNil(helper.dataTraffic);
    XCTAssertNotNil(helper.appName);
    XCTAssertNotNil(helper.bundleIdentifier);
    XCTAssertNotNil(helper.appVersion);
    XCTAssertNotNil(helper.appStartTimeConsuming);
    XCTAssertNotNil(helper.deviceModel);
    XCTAssertNotNil(helper.deviceName);
    XCTAssertNotNil(helper.systemVersion);
    XCTAssertNotNil(helper.screenResolution);
    XCTAssertNotNil(helper.languageCode);
    XCTAssertNotNil(helper.batteryLevel);
    XCTAssertNotNil(helper.cpuType);
    XCTAssertNotNil(helper.disk);
    XCTAssertNotNil(helper.networkState);
    XCTAssertNotNil(helper.ssid);
    XCTAssertNotNil(helper.appInfoDescription);
}

@end
