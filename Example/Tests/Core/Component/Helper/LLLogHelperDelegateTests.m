//
//  LLLogHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLLogHelperDelegateTests : LLCoreTestCase

@end

@implementation LLLogHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(logInFile:function:lineNo:onEvent:message:)),
                  NSStringFromSelector(@selector(logInFile:function:lineNo:level:onEvent:message:)),
                  NSStringFromSelector(@selector(alertLogInFile:function:lineNo:onEvent:message:)),
                  NSStringFromSelector(@selector(warningLogInFile:function:lineNo:onEvent:message:)),
                  NSStringFromSelector(@selector(errorLogInFile:function:lineNo:onEvent:message:)),
                  NSStringFromSelector(@selector(levelsDescription)),
                  NSStringFromSelector(@selector(logViewControllerWithLaunchDate:)),
                  NSStringFromSelector(@selector(logModelClass)),
                  NSStringFromSelector(@selector(logViewControllerClass)), nil];
    [self doTestProtocol:@protocol(LLLogHelperDelegate) set:set];
}

@end
