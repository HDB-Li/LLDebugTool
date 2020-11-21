//
//  LLBaseTestCase.h
//  LLDebugTool_Example
//
//  Created by liuling on 2020/11/6.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseTestCase : XCTestCase

- (void)doTestProtocol:(Protocol *)prot set:(NSSet *)set;

@end

NS_ASSUME_NONNULL_END
