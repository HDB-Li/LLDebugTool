//
//  UIViewUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIViewUtilsTests : LLCoreTestCase

@end

@implementation UIViewUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProperties {
    CGRect frame = CGRectMake(10, 20, 30, 40);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    XCTAssertTrue(view.LL_horizontalPadding == 0);
    XCTAssertTrue(view.LL_verticalPadding == 0);
    view.LL_horizontalPadding = 4;
    view.LL_verticalPadding = 5;
    XCTAssertTrue(view.LL_horizontalPadding == 4);
    XCTAssertTrue(view.LL_verticalPadding == 5);
    XCTAssertTrue(view.LL_x == 10);
    XCTAssertTrue(view.LL_y == 20);
    XCTAssertTrue(view.LL_centerX == 25);
    XCTAssertTrue(view.LL_centerY == 40);
    XCTAssertTrue(view.LL_width == 30);
    XCTAssertTrue(view.LL_height == 40);
    XCTAssertTrue(CGSizeEqualToSize(view.LL_size, CGSizeMake(view.LL_width, view.LL_height)));
    XCTAssertTrue(view.LL_top == 20);
    XCTAssertTrue(view.LL_bottom == 60);
    XCTAssertTrue(view.LL_left == 10);
    XCTAssertTrue(view.LL_right == 40);
}

- (void)testCornerRadius {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view LL_setCornerRadius:4];
    XCTAssertTrue(view.layer.masksToBounds);
    XCTAssertTrue(view.layer.cornerRadius == 4);
}

- (void)testBorderColorAndWidth {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view LL_setBorderColor:[UIColor redColor] borderWidth:2];
    XCTAssertTrue(view.layer.borderColor == [[UIColor redColor] CGColor]);
    XCTAssertTrue(view.layer.borderWidth == 2);
}

- (void)testRemoveAllSubviews {
    UIView *view = [[UIView alloc] init];
    [view addSubview:[UIView new]];
    [view addSubview:[UIView new]];
    XCTAssertTrue(view.subviews.count == 2);
    [view LL_removeAllSubviews];
    XCTAssertTrue(view.subviews.count ==  0);
    
    UIView *subview = [[UIView alloc] init];
    [view addSubview:subview];
    [view LL_removeAllSubviewsIgnoreIn:@[subview]];
    XCTAssertTrue(view.subviews.count == 1);
}

- (void)testBottomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 10, 10)];
    [view addSubview:view1];
    [view addSubview:view2];
    XCTAssertTrue([view LL_bottomView] == view2);
}

- (void)testAddClickListener {
    UIView *view = [[UIView alloc] init];
    [view LL_addClickListener:self action:@selector(testAddClickListener)];
    XCTAssertTrue(view.gestureRecognizers.count == 1);
}

- (void)testConvertViewToImage {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIImage *image = [view LL_convertViewToImage];
    XCTAssertNotNil(image);
    XCTAssertTrue(CGSizeEqualToSize(image.size, CGSizeMake(10, 10)));
}

- (void)testSizeToFit {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [view sizeToFit];
    XCTAssertTrue(CGRectEqualToRect(view.frame, CGRectMake(0, 0, 10, 10)));
    view.LL_horizontalPadding = 2;
    view.LL_verticalPadding = 3;
    [view sizeToFit];
    XCTAssertTrue(CGRectEqualToRect(view.frame, CGRectMake(0, 0, 14, 16)));
}

@end
