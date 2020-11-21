//
//  UIAlertActionUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIAlertActionUtilsTests : LLCoreTestCase

@end

@implementation UIAlertActionUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAlertAction {
    UIAlertAction *action = [[UIAlertAction alloc] init];
    XCTAssertNil([action valueForKey:@"image"]);
    XCTAssertNil([action valueForKey:@"titleTextColor"]);
    [action LL_setImage:[UIImage LL_imageNamed:kSelectorBlueImageName]];
    [action LL_setTitleTextColor:[UIColor redColor]];
    XCTAssertNotNil([action valueForKey:@"image"]);
    XCTAssertTrue([[action valueForKey:@"titleTextColor"] isEqual:[UIColor redColor]]);
}

@end
