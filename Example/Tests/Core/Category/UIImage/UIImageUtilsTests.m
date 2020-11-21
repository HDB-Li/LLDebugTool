//
//  UIImageUtilsTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/3.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface UIImageUtilsTests : LLCoreTestCase

@end

@implementation UIImageUtilsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testImageName {
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorBlueImageName]);
}

- (void)testImageNameAndSize {
    UIImage *image = [UIImage LL_imageNamed:kSelectorBlueImageName size:CGSizeMake(2, 2)];
    XCTAssertNotNil(image);
    XCTAssertTrue(CGSizeEqualToSize(image.size, CGSizeMake(2, 2)));
}

- (void)testImageNameAndColor {
    UIImage *image = [UIImage LL_imageNamed:kCloseImageName];
    XCTAssertNotNil(image);
}

- (void)testImageNameAndSizeAndColor {
    UIImage *image = [UIImage LL_imageNamed:kSelectorBlueImageName size:CGSizeMake(40, 40)];
    XCTAssertNotNil(image);
    XCTAssertTrue(CGSizeEqualToSize(image.size, CGSizeMake(40, 40)));
}

- (void)testImageWithGIFData {
    
}

- (void)testImageWithColor {
    UIImage *image = [UIImage LL_imageWithColor:[UIColor redColor]];
    XCTAssertNotNil(image);
    XCTAssertTrue([[image LL_ColorAt:CGPointMake(1, 1)] isEqual:[UIColor redColor]]);
}

- (void)testImageWithResize {
    UIImage *image = [UIImage LL_imageNamed:kSelectorBlueImageName];
    image = [image LL_resizeTo:CGSizeMake(5, 5)];
    XCTAssertNotNil(image);
    XCTAssertTrue(CGSizeEqualToSize(image.size, CGSizeMake(5, 5)));
}

- (void)testHexColors {
    UIImage *image = [UIImage LL_imageNamed:kSelectorBlueImageName];
    XCTAssertNotNil(image);
    NSArray *array = [image LL_hexColors];
    XCTAssertNotNil(array);
    NSInteger height = image.size.height * image.scale;
    NSInteger width = image.size.width * image.scale;
    XCTAssertTrue(array.count == height);
    for (NSArray *arr in array) {
        XCTAssertTrue(arr.count == width);
    }
}

- (void)testHexColorAt {
    UIImage *image = [UIImage LL_imageNamed:kSelectorBlueImageName];
    XCTAssertNotNil(image);
    XCTAssertTrue([[image LL_hexColorAt:CGPointMake(7, 7)] isEqualToString:@"#1296DB"]);
}



@end
