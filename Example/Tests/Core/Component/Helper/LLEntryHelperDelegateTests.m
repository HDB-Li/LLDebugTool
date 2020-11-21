//
//  LLEntryHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLEntryHelperDelegateTests : LLCoreTestCase

@end

@implementation LLEntryHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    [self doTestProtocol:@protocol(LLEntryHelperDelegate) set:nil];
}

@end
