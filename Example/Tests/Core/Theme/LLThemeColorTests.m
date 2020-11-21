//
//  LLThemeColorTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLThemeColorTests : LLCoreTestCase

@end

@implementation LLThemeColorTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testColor {
    UIStatusBarStyle darkStyle = UIStatusBarStyleDefault;
    if (@available(iOS 13.0, *)) {
        darkStyle = UIStatusBarStyleDarkContent;
    }
    LLThemeColor *color = [LLThemeColor hackThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor greenColor]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#333333"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor simpleThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor darkTextColor]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor whiteColor]]);
    XCTAssertTrue(color.statusBarStyle == darkStyle);
    
    color = [LLThemeColor grassThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#FFF0A5"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#13773D"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor homebrewThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#28FE14"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#000000"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor manPageThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#000000"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#FEF49C"]]);
    XCTAssertTrue(color.statusBarStyle == darkStyle);
    
    color = [LLThemeColor novelThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#3B2322"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#DFDBC3"]]);
    XCTAssertTrue(color.statusBarStyle == darkStyle);
    
    color = [LLThemeColor oceanThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#FFFFFF"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#224FBC"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor proThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#F2F2F2"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#000000"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor redSandsThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#D7C9A7"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#7A251E"]]);
    XCTAssertTrue(color.statusBarStyle == UIStatusBarStyleLightContent);
    
    color = [LLThemeColor silverAerogelThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#000000"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#929292"]]);
    XCTAssertTrue(color.statusBarStyle == darkStyle);
    
    color = [LLThemeColor solidColorsThemeColor];
    XCTAssertTrue([color.primaryColor isEqual:[UIColor LL_colorWithHex:@"#000000"]]);
    XCTAssertTrue([color.backgroundColor isEqual:[UIColor LL_colorWithHex:@"#FFFFFF"]]);
    XCTAssertTrue(color.statusBarStyle == darkStyle);
    
    XCTAssertTrue([color.containerColor isEqual:[color.backgroundColor LL_mixtureWithColor:color.primaryColor radio:0.1]]);
    XCTAssertTrue([color.placeHolderColor isEqual:[color.primaryColor LL_mixtureWithColor:color.backgroundColor radio:0.5]]);
}

@end
