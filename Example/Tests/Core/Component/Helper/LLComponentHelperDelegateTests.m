//
//  LLComponentHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentHelperDelegateTests : LLCoreTestCase

@end

@implementation LLComponentHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(setEnabled:)), NSStringFromSelector(@selector(isEnabled)), nil];
    [self doTestProtocol:@protocol(LLComponentHelperDelegate) set:set];
}

@end
