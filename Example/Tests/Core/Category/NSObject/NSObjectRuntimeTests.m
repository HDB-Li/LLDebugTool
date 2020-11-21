//
//  NSObjectRuntimeTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/2.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface NSObjectRuntimeTestsObject : NSObject

+ (int)classMethod1;
+ (int)classMethod2;

- (int)instanceMethod1;
- (int)instanceMethod2;

@property (nonatomic, assign) int intValue;

@end

@implementation NSObjectRuntimeTestsObject

+ (int)classMethod1 {
    return 1;
}

+ (int)classMethod2 {
    return 2;
}

- (int)instanceMethod1 {
    return 1;
}

- (int)instanceMethod2 {
    return 2;
}

@end

@interface NSObjectRuntimeTests : LLCoreTestCase

@end

@implementation NSObjectRuntimeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSwizzleClassSelector {
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod1] == 1);
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod2] == 2);
    [NSObjectRuntimeTestsObject LL_swizzleClassSelector:@selector(classMethod1) anotherSelector:@selector(classMethod2)];
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod1] == 2);
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod2] == 1);
    [NSObjectRuntimeTestsObject LL_swizzleClassSelector:@selector(classMethod1) anotherSelector:@selector(classMethod2)];
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod1] == 1);
    XCTAssertTrue([NSObjectRuntimeTestsObject classMethod2] == 2);
}

- (void)testSwizzleInstanceSelector {
    NSObjectRuntimeTestsObject *object = [NSObjectRuntimeTestsObject new];
    XCTAssertTrue([object instanceMethod1] == 1);
    XCTAssertTrue([object instanceMethod2] == 2);
    [NSObjectRuntimeTestsObject LL_swizzleInstanceSelector:@selector(instanceMethod1) anotherSelector:@selector(instanceMethod2)];
    XCTAssertTrue([object instanceMethod1] == 2);
    XCTAssertTrue([object instanceMethod2] == 1);
    [NSObjectRuntimeTestsObject LL_swizzleInstanceSelector:@selector(instanceMethod1) anotherSelector:@selector(instanceMethod2)];
    XCTAssertTrue([object instanceMethod1] == 1);
    XCTAssertTrue([object instanceMethod2] == 2);
}

- (void)testSwizzleMethodSelector {
    Method method1 = class_getInstanceMethod([NSObjectRuntimeTestsObject class], @selector(instanceMethod1));
    Method method2 = class_getInstanceMethod([NSObjectRuntimeTestsObject class], @selector(instanceMethod2));
    NSObjectRuntimeTestsObject *object = [NSObjectRuntimeTestsObject new];
    XCTAssertTrue([object instanceMethod1] == 1);
    XCTAssertTrue([object instanceMethod2] == 2);
    [NSObjectRuntimeTestsObject LL_swizzleMethod:method1 anotherMethod:method2];
    XCTAssertTrue([object instanceMethod1] == 2);
    XCTAssertTrue([object instanceMethod2] == 1);
    [NSObjectRuntimeTestsObject LL_swizzleMethod:method1 anotherMethod:method2];
    XCTAssertTrue([object instanceMethod1] == 1);
    XCTAssertTrue([object instanceMethod2] == 2);
}

- (void)testPropertyNames {
    NSArray *names = [NSObjectRuntimeTestsObject LL_getPropertyNames];
    XCTAssertTrue([names containsObject:@"intValue"]);
    names = [[NSObjectRuntimeTestsObject new] LL_getPropertyNames];
    XCTAssertTrue([names containsObject:@"intValue"]);
}

- (void)testInstanceMethodNames {
    NSArray *names = [NSObjectRuntimeTestsObject LL_getInstanceMethodNames];
    XCTAssertTrue([names containsObject:@"instanceMethod1"]);
}

- (void)testClassMethodNames {
    NSArray *names = [NSObjectRuntimeTestsObject LL_getClassMethodNames];
    XCTAssertTrue([names containsObject:@"classMethod1"]);
}

@end
