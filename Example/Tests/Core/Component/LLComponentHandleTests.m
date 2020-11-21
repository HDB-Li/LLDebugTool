//
//  LLComponentHandleTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/7.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLComponentHandleTests : LLCoreTestCase

@end

@implementation LLComponentHandleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testComponent {
    NSArray *results = @[@"Entry", @"Feature", @"Setting",
    @"Network", @"Log", @"Crash", @"AppInfo", @"Sandbox", @"Screenshot",
    @"ConvenientScreenshot", @"Hierarchy", @"Magnifier", @"Ruler", @"WidgetBorder",
    @"Html", @"Location", @"ShortCut"];
    XCTAssertTrue(results.count == LLDebugToolActionShortCut + 1);
    for (LLDebugToolAction i = LLDebugToolActionEntry; i <= LLDebugToolActionShortCut; i++) {
        NSString *componentTitle = [NSString stringWithFormat:@"LL%@Component", results[i]];
        XCTAssertTrue([[LLComponentHandle componentForAction:i] isEqualToString:componentTitle]);
    }
}

- (void)testTitle {
    NSArray *results = @[@"entry", @"feature", @"setting", @"net", @"log", @"crash", @"app.info", @"sandbox", @"screenshot", @"convenient.screenshot", @"hierarchy", @"magnifier", @"ruler", @"widget.border", @"html", @"location", @"short.cut"];
    XCTAssertTrue(results.count == LLDebugToolActionShortCut + 1);
    for (LLDebugToolAction i = LLDebugToolActionEntry; i <= LLDebugToolActionShortCut; i++) {
        NSString *key = [NSString stringWithFormat:@"function.%@", results[i]];
        NSString *title = LLLocalizedString(key);
        XCTAssertTrue([[LLComponentHandle titleFromAction:i] isEqualToString:title]);
    }
}

- (void)testExecuteAction {
    XCTAssertTrue([LLComponentHandle executeAction:LLDebugToolActionSetting data:nil]);
    XCTAssertTrue([LLComponentHandle currentAction] == LLDebugToolActionSetting);
    XCTAssertFalse([LLComponentHandle executeAction:1000 data:nil]);
}

- (void)testFinishAction {
    XCTAssertTrue([LLComponentHandle finishAction:LLDebugToolActionSetting data:nil]);
    XCTAssertTrue([LLComponentHandle currentAction] == LLDebugToolActionEntry);
    XCTAssertFalse([LLComponentHandle finishAction:1000 data:nil]);
}

@end
