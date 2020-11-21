//
//  LLScreenshotHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLScreenshotHelperDelegateTests : LLCoreTestCase

@end

@implementation LLScreenshotHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(simulateTakeScreenshot)),
                  NSStringFromSelector(@selector(imageFromScreen)),
                  NSStringFromSelector(@selector(imageFromScreen:)),
                  NSStringFromSelector(@selector(saveScreenshot:name:complete:)),
                  NSStringFromSelector(@selector(canRequestPhotoLibraryAuthorization)), nil];
    [self doTestProtocol:@protocol(LLScreenshotHelperDelegate) set:set];
}

@end
