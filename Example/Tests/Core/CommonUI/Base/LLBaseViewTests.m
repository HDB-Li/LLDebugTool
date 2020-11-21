//
//  LLBaseViewTests.m
//  LLDebugTool_Tests
//
//  Created by HDB-Li on 2020/10/6.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseViewTestsView : LLBaseView

@property (nonatomic, assign) BOOL isCalledInitUI;

@property (nonatomic, assign) BOOL isCalledThemeColorChanged;

@end

@implementation LLBaseViewTestsView

- (void)initUI {
    [super initUI];
    self.isCalledInitUI = YES;
}

- (void)themeColorChanged {
    [super themeColorChanged];
    self.isCalledThemeColorChanged = YES;
}

@end

@interface LLBaseViewTests : LLCoreTestCase

@end

@implementation LLBaseViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    LLBaseViewTestsView *view = [[LLBaseViewTestsView alloc] initWithFrame:CGRectZero];
    XCTAssertNotNil(view);
    XCTAssertTrue(view.isCalledInitUI);
    [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolUpdateThemeNotification object:nil];
    XCTAssertTrue(view.isCalledThemeColorChanged);
}

@end
