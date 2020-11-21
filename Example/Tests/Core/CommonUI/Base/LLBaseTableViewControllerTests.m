//
//  LLBaseTableViewControllerTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/5.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseTableViewControllerTests : LLCoreTestCase

@end

@implementation LLBaseTableViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testViewController {
    LLBaseTableViewController *vc = [[LLBaseTableViewController alloc] init];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    XCTAssertNotNil(vc);
    XCTAssertNotNil(vc.tableView);
    XCTAssertTrue(vc.tableView.style == UITableViewStyleGrouped);
    XCTAssertTrue([vc.tableView.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    XCTAssertTrue([vc.tableView.separatorColor isEqual:[LLThemeManager shared].primaryColor]);
    LLDebugConfig *config = [[LLDebugConfig alloc] init];
    config.colorStyle = LLDebugConfigColorStyleGrass;
    XCTAssertTrue([vc.tableView.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    XCTAssertTrue([vc.tableView.separatorColor isEqual:[LLThemeManager shared].primaryColor]);
    window.hidden = YES;
}

@end
