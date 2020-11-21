//
//  LLBaseTestCase.m
//  LLDebugTool_Example
//
//  Created by HDB-Li on 2020/11/6.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLBaseTestCase.h"

#import <objc/runtime.h>

@implementation LLBaseTestCase

- (void)doTestProtocol:(Protocol *)prot set:(NSSet *)set {
    if (!set) {
        set = [NSSet set];
    }
    NSMutableSet *targetSet = [[NSMutableSet alloc] init];
    [targetSet unionSet:[self getNamesInProtocol:prot isRequiredMethod:YES isInstanceMethod:YES]];
    [targetSet unionSet:[self getNamesInProtocol:prot isRequiredMethod:YES isInstanceMethod:NO]];
    [targetSet unionSet:[self getNamesInProtocol:prot isRequiredMethod:NO isInstanceMethod:YES]];
    [targetSet unionSet:[self getNamesInProtocol:prot isRequiredMethod:NO isInstanceMethod:NO]];
    XCTAssertTrue([targetSet isEqualToSet:set]);
}

- (NSSet *)getNamesInProtocol:(Protocol *)prot isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod {
    unsigned int count = 0;
    NSMutableSet *set = [[NSMutableSet alloc] init];
    struct objc_method_description * list = protocol_copyMethodDescriptionList(prot, isRequiredMethod, isInstanceMethod, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description method = list[i];
        [set addObject:NSStringFromSelector(method.name)];
    }
    free(list);
    return set;
}

@end
