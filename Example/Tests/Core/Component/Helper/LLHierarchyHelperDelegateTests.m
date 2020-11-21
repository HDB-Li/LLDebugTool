//
//  LLHierarchyHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLHierarchyHelperDelegateTests : LLCoreTestCase

@end

@implementation LLHierarchyHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(setLockViews:)),
                  NSStringFromSelector(@selector(lockViews)),
                  NSStringFromSelector(@selector(allWindows)),
                  NSStringFromSelector(@selector(allWindowsIgnoreClass:)),
                  NSStringFromSelector(@selector(isPrivateClassView:)),
                  NSStringFromSelector(@selector(findParentViewsByView:)),
                  NSStringFromSelector(@selector(findSubviewsByView:)),
                  NSStringFromSelector(@selector(viewForSelectionAtPoint:)),
                  NSStringFromSelector(@selector(showActionSheetWithActions:currentAction:completion:)),
                  NSStringFromSelector(@selector(showTextFieldAlertWithText:handler:)),
                  NSStringFromSelector(@selector(postDebugToolChangeHierarchyNotification)),
                  NSStringFromSelector(@selector(hasTextPropertyInClass:)),
                  NSStringFromSelector(@selector(hasTextColorPropertyInClass:)),
                  NSStringFromSelector(@selector(hasFontPropertyInClass:)), nil];
    [self doTestProtocol:@protocol(LLHierarchyHelperDelegate) set:set];
}

@end
