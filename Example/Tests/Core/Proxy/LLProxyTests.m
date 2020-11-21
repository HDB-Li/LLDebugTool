//
//  LLProxyTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLProxyTestsModel : NSObject

- (NSString *)method1;

@end

@implementation LLProxyTestsModel

- (NSString *)method1 {
    return @"test";
}

@end

@interface LLProxyTests : LLCoreTestCase

@end

@implementation LLProxyTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProxy {
    LLProxyTestsModel *model = [[LLProxyTestsModel alloc] init];
    LLProxy *proxy = [[LLProxy alloc] initWithTarget:model];
    XCTAssertTrue(proxy.target == model);
    XCTAssertTrue([proxy respondsToSelector:@selector(method1)]);
    XCTAssertTrue([[proxy performSelector:@selector(method1)] isEqualToString:@"test"]);
}

@end
