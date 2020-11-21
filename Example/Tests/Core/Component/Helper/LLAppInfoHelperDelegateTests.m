//
//  LLAppInfoHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLAppInfoHelperDelegateTests : LLCoreTestCase

@end

@implementation LLAppInfoHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDelegate {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(cpuUsage)),
                  NSStringFromSelector(@selector(freeMemory)),
                  NSStringFromSelector(@selector(usedMemory)),
                  NSStringFromSelector(@selector(totalMemory)),
                  NSStringFromSelector(@selector(memoryUsage)),
                  NSStringFromSelector(@selector(fps)),
                  NSStringFromSelector(@selector(totalDataTraffic)),
                  NSStringFromSelector(@selector(requestDataTraffic)),
                  NSStringFromSelector(@selector(responseDataTraffic)),
                  NSStringFromSelector(@selector(dataTraffic)),
                  NSStringFromSelector(@selector(appName)),
                  NSStringFromSelector(@selector(bundleIdentifier)),
                  NSStringFromSelector(@selector(appVersion)),
                  NSStringFromSelector(@selector(appStartTimeConsuming)),
                  NSStringFromSelector(@selector(deviceModel)),
                  NSStringFromSelector(@selector(deviceName)),
                  NSStringFromSelector(@selector(systemVersion)),
                  NSStringFromSelector(@selector(screenResolution)),
                  NSStringFromSelector(@selector(languageCode)),
                  NSStringFromSelector(@selector(batteryLevel)),
                  NSStringFromSelector(@selector(cpuType)),
                  NSStringFromSelector(@selector(disk)),
                  NSStringFromSelector(@selector(networkState)),
                  NSStringFromSelector(@selector(ssid)),
                  NSStringFromSelector(@selector(updateRequestDataTraffic:responseDataTraffic:)),
                  NSStringFromSelector(@selector(appInfoDescription)),
                  NSStringFromSelector(@selector(addAppInfoObserver:selector:)),
                  NSStringFromSelector(@selector(removeAppInfoObserver:)),
                  NSStringFromSelector(@selector(analysisAppInfoNotification:)), nil];
    [self doTestProtocol:@protocol(LLAppInfoHelperDelegate) set:set];
}

@end
