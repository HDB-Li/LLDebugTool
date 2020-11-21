//
//  LLDebugToolTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLDebugToolTests : LLCoreTestCase

@end

@implementation LLDebugToolTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDebugTool {
    LLDebugTool *tool = [[LLDebugTool alloc] init];
    [tool startWorkingWithConfigBlock:^(LLDebugConfig * _Nonnull config) {
        XCTAssertTrue(config == [LLDebugConfig shared]);
    }];
    XCTAssertTrue(tool.isWorking);
    XCTAssertTrue([LLTool startWorkingAfterApplicationDidFinishLaunching]);
    XCTAssertTrue(tool.componentCore.crashHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.logHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.networkHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.appInfoHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.screenshotHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.settingHelper.isEnabled);
    XCTAssertTrue(tool.componentCore.locationHelper.isEnabled == [LLDebugConfig shared].mockLocation);
    XCTAssertTrue(tool.isInstalled);
    [tool stopWorking];
    XCTAssertFalse(tool.isWorking);
    XCTAssertFalse([LLTool startWorkingAfterApplicationDidFinishLaunching]);
    XCTAssertFalse(tool.componentCore.entryHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.locationHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.settingHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.screenshotHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.appInfoHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.networkHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.logHelper.isEnabled);
    XCTAssertFalse(tool.componentCore.crashHelper.isEnabled);
}

- (void)testExecuteAction {
    LLDebugTool *tool = [[LLDebugTool alloc] init];
    [tool executeAction:LLDebugToolActionFeature];
    XCTAssertTrue([LLComponentHandle currentAction] == LLDebugToolActionFeature);
    [tool executeAction:LLDebugToolActionEntry];
    XCTAssertTrue([LLComponentHandle currentAction] == LLDebugToolActionEntry);
}

- (void)testVersion {
    NSString *versionNumber = [LLDebugTool versionNumber];
    if ([LLDebugTool isBetaVersion]) {
        NSString *str = [NSString stringWithFormat:@"%@(BETA)", versionNumber];
        XCTAssertTrue([[LLDebugTool version] isEqualToString:str]);
    } else {
        XCTAssertTrue([[LLDebugTool version] isEqualToString:versionNumber]);
    }
    
    XCTAssertTrue([versionNumber isEqualToString:@"1.3.9"]);
}

- (void)testNotification {
    LLDebugTool *tool = [[LLDebugTool alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolStartWorkingNotification object:nil];
    XCTAssertTrue(tool.isWorking);
}

- (void)testComponent {
    LLDebugTool *tool = [[LLDebugTool alloc] init];
    XCTAssertNotNil(tool.componentCore);
}

@end
