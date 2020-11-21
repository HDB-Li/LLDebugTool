//
//  LLDebugConfigHelperTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLDebugConfigHelperTests : LLCoreTestCase

@end

@implementation LLDebugConfigHelperTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
    
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testColorStyleDescription {
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription] isEqualToString:[LLDebugConfigHelper colorStyleDescription:[LLDebugConfig shared].colorStyle]]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleHack] isEqualToString:@"Hack"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleSimple] isEqualToString:@"Simple"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleSystem] isEqualToString:@"System"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleGrass] isEqualToString:@"Grass"]);
    XCTAssertTrue([LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleHomebrew]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleManPage] isEqualToString:@"Man Page"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleNovel] isEqualToString:@"Novel"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleOcean] isEqualToString:@"Ocean"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStylePro] isEqualToString:@"Pro"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleRedSands] isEqualToString:@"Red Sands"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleSilverAerogel] isEqualToString:@"Silver Aerogel"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleSolidColors] isEqualToString:@"Solid Colors"]);
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:LLDebugConfigColorStyleCustom] isEqualToString:@"Custom"]);
}

- (void)testColorStyle {
    XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription] isEqualToString:[LLDebugConfigHelper colorStyleDescription:[LLDebugConfig shared].colorStyle]]);
    NSArray *results = @[@"Hack", @"Simple", @"System",
                         @"Grass", @"Homebrew", @"Man Page",
                         @"Novel", @"Ocean", @"Pro",
                         @"Red Sands", @"Silver Aerogel", @"Solid Colors", @"Custom"];
    XCTAssertTrue(LLDebugConfigColorStyleCustom == results.count - 1);
    for (LLDebugConfigColorStyle style = LLDebugConfigColorStyleHack; style < results.count; style++) {
        XCTAssertTrue([[LLDebugConfigHelper colorStyleDescription:style] isEqualToString:results[style]]);
    }
}

- (void)testWindowStyle {
    XCTAssertTrue([[LLDebugConfigHelper entryWindowStyleDescription] isEqualToString:[LLDebugConfigHelper entryWindowStyleDescription:[LLDebugConfig shared].entryWindowStyle]]);
    NSArray *results = @[@"Ball", @"Title", @"App Info",
                         @"Net Bar", @"Power Bar"];
    XCTAssertTrue(LLDebugConfigEntryWindowStylePowerBar == results.count - 1);
    for (LLDebugConfigEntryWindowStyle i = LLDebugConfigEntryWindowStyleBall; i < results.count; i ++) {
        XCTAssertTrue([[LLDebugConfigHelper entryWindowStyleDescription:i] isEqualToString:results[i]]);
    }
}

- (void)testStatusBarStyle {
    XCTAssertTrue([[LLDebugConfigHelper statusBarStyleDescription] isEqualToString:[LLDebugConfigHelper statusBarStyleDescription:[LLThemeManager shared].statusBarStyle]]);
    XCTAssertTrue([[LLDebugConfigHelper statusBarStyleDescription:UIStatusBarStyleDefault] isEqualToString:@"Default"]);
    XCTAssertTrue([[LLDebugConfigHelper statusBarStyleDescription:UIStatusBarStyleLightContent] isEqualToString:@"Light Content"]);
    XCTAssertTrue([[LLDebugConfigHelper statusBarStyleDescription:UIStatusBarStyleBlackOpaque] isEqualToString:@"Black Opaque"]);
    XCTAssertTrue([[LLDebugConfigHelper statusBarStyleDescription:UIStatusBarStyleDarkContent] isEqualToString:@"Dark Content"]);
}

- (void)testLogStyle {
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription] isEqualToString:[LLDebugConfigHelper logStyleDescription:[LLDebugConfig shared].logStyle]]);
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription:LLDebugConfigLogDetail] isEqualToString:@"Detail"]);
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription:LLDebugConfigLogFileFuncDesc] isEqualToString:@"File Func Desc"]);
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription:LLDebugConfigLogFileDesc] isEqualToString:@"File Desc"]);
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription:LLDebugConfigLogNormal] isEqualToString:@"Normal"]);
    XCTAssertTrue([[LLDebugConfigHelper logStyleDescription:LLDebugConfigLogNone] isEqualToString:@"None"]);
}

- (void)testComponent {
    XCTAssertTrue([[LLDebugConfigHelper doubleClickComponentDescription] isEqualToString:[LLDebugConfigHelper componentDescription:[LLDebugConfig shared].doubleClickAction]]);
    XCTAssertTrue([[LLDebugConfigHelper componentDescription:LLDebugToolActionEntry] isEqualToString:[LLComponentHandle titleFromAction:LLDebugToolActionEntry]]);
}

@end
