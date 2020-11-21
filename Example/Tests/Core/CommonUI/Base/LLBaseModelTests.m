//
//  LLBaseModelTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/5.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseModelTestsModel : LLBaseModel

@property (nonatomic, assign) int intValue;

@property (nonatomic, copy) NSString *stringValue;

@property (nonatomic, strong) NSNumber *numberValue;

@property (nonatomic, assign) BOOL boolValue;

@end

@implementation LLBaseModelTestsModel

@end

@interface LLBaseModelTests : LLCoreTestCase

@end

@implementation LLBaseModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModel {
    LLBaseModelTestsModel *model = [[LLBaseModelTestsModel alloc] init];
    model.intValue = 1;
    model.stringValue = @"test";
    model.numberValue = @1;
    model.boolValue = YES;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    XCTAssertNotNil(data);
    LLBaseModelTestsModel *newModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(newModel);
    XCTAssertTrue(model.intValue == newModel.intValue);
    XCTAssertTrue([model.stringValue isEqualToString:newModel.stringValue]);
    XCTAssertTrue([model.numberValue isEqualToNumber:newModel.numberValue]);
    XCTAssertTrue(model.boolValue == newModel.boolValue);
}

@end
