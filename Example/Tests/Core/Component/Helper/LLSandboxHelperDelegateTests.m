//
//  LLSandboxHelperDelegateTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLSandboxHelperDelegateTests : LLCoreTestCase

@end

@implementation LLSandboxHelperDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocol {
    NSSet *set = [NSSet setWithObjects:NSStringFromSelector(@selector(archiveFolderPath)),
                  NSStringFromSelector(@selector(getCurrentSandboxStructure)),
                  NSStringFromSelector(@selector(enableZipArchive)),
                  NSStringFromSelector(@selector(createZipFileAtPath:withFilesAtPaths:)), nil];
    [self doTestProtocol:@protocol(LLSandboxHelperDelegate) set:set];
}

@end
