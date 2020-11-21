//
//  LLAppInfoWindowTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/11/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLAppInfoTestCase.h"

@class LLNavigationController;

@interface LLAppInfoWindowTests : LLAppInfoTestCase

@end

@implementation LLAppInfoWindowTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWindow {
    LLAppInfoWindow *window = [[LLAppInfoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XCTAssertNotNil(window);
    UINavigationController *vc = window.rootViewController;
    XCTAssertTrue([NSStringFromClass(vc.class) isEqualToString:@"LLNavigationController"]);
    XCTAssertTrue([vc.viewControllers.firstObject isKindOfClass:[LLAppInfoViewController class]]);
    XCTAssertTrue(window.showAnimateStyle == LLBaseWindowShowAnimateStylePresent);
    XCTAssertTrue(window.hideAnimateStyle == LLBaseWindowHideAnimateStyleDismiss);
}

@end
