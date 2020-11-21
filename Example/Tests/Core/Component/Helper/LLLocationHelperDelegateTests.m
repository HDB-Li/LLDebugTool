//
//  LLLocationHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLLocationHelperDelegateTests : LLCoreTestCase

@end

@implementation LLLocationHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(isMockRoute)),
                  NSStringFromSelector(@selector(availableRoutes)),
                  NSStringFromSelector(@selector(routeModel)),
                  NSStringFromSelector(@selector(userAgreeAuthorization)),
                  NSStringFromSelector(@selector(removeRoute:)),
                  NSStringFromSelector(@selector(startMockRoute:)),
                  NSStringFromSelector(@selector(stopMockRoute)),
                  NSStringFromSelector(@selector(startRecordRoute)),
                  NSStringFromSelector(@selector(stopRecordRoute)),
                  NSStringFromSelector(@selector(isLLDebugToolLocationRouteFile:)),
                  NSStringFromSelector(@selector(addLLDebugToolExtendDataWithPath:)),
                  NSStringFromSelector(@selector(addMockRouteFile:)),
                  NSStringFromSelector(@selector(addMockRouteDirectory:)), nil];
    [self doTestProtocol:@protocol(LLLocationHelperDelegate) set:set];
}

@end
