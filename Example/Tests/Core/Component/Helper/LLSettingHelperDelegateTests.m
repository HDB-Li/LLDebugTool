//
//  LLSettingHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLSettingHelperDelegateTests : LLCoreTestCase

@end

@implementation LLSettingHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(doubleClickAction)),
                  NSStringFromSelector(@selector(setDoubleClickAction:)),
                  NSStringFromSelector(@selector(colorStyle)),
                  NSStringFromSelector(@selector(setColorStyle:)),
                  NSStringFromSelector(@selector(logStyle)),
                  NSStringFromSelector(@selector(setLogStyle:)),
                  NSStringFromSelector(@selector(entryWindowStyle)),
                  NSStringFromSelector(@selector(setEntryWindowStyle:)),
                  NSStringFromSelector(@selector(shrinkToEdgeWhenInactive)),
                  NSStringFromSelector(@selector(setShrinkToEdgeWhenInactive:)),
                  NSStringFromSelector(@selector(shakeToHide)),
                  NSStringFromSelector(@selector(setShakeToHide:)),
                  NSStringFromSelector(@selector(hierarchyIgnorePrivateClass)),
                  NSStringFromSelector(@selector(setHierarchyIgnorePrivateClass:)),
                  NSStringFromSelector(@selector(magnifierZoomLevel)),
                  NSStringFromSelector(@selector(setMagnifierZoomLevel:)),
                  NSStringFromSelector(@selector(magnifierSize)),
                  NSStringFromSelector(@selector(setMagnifierSize:)),
                  NSStringFromSelector(@selector(showWidgetBorder)),
                  NSStringFromSelector(@selector(setShowWidgetBorder:)),
                  NSStringFromSelector(@selector(defaultHtmlUrl)),
                  NSStringFromSelector(@selector(setDefaultHtmlUrl:)),
                  NSStringFromSelector(@selector(webViewClass)),
                  NSStringFromSelector(@selector(setWebViewClass:)),
                  NSStringFromSelector(@selector(mockLocation)),
                  NSStringFromSelector(@selector(setMockLocation:)),
                  NSStringFromSelector(@selector(mockLocationLatitude)),
                  NSStringFromSelector(@selector(setMockLocationLatitude:)),
                  NSStringFromSelector(@selector(mockLocationLongitude)),
                  NSStringFromSelector(@selector(setMockLocationLongitude:)), nil];
    [self doTestProtocol:@protocol(LLSettingHelperDelegate) set:set];
}

@end
