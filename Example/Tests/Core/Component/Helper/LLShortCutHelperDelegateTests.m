//
//  LLShortCutHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLShortCutHelperDelegateTests : LLCoreTestCase

@end

@implementation LLShortCutHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(actions)),
                  NSStringFromSelector(@selector(registerAction:)),
                  NSStringFromSelector(@selector(unregisterAction:)),
                  NSStringFromSelector(@selector(registerShortCutWithName:action:)), nil];
    [self doTestProtocol:@protocol(LLShortCutHelperDelegate) set:set];
}

@end
