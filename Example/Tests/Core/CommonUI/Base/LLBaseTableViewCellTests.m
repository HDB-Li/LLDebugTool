//
//  LLBaseTableViewCellTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/5.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLBaseTableViewCellTestsCell : LLBaseTableViewCell

@property (nonatomic, assign) BOOL isCalledInitUI;

@property (nonatomic, strong) UILabel *customLabel;

@end

@implementation LLBaseTableViewCellTestsCell

- (void)initUI {
    [super initUI];
    self.isCalledInitUI = YES;
    self.customLabel = [UILabel new];
    [self.contentView addSubview:self.customLabel];
}

@end

@interface LLBaseTableViewCellTests : LLCoreTestCase

@end

@implementation LLBaseTableViewCellTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCell {
    LLBaseTableViewCellTestsCell *cell = [[LLBaseTableViewCellTestsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    XCTAssertTrue([cell.tintColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue([cell.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);
    XCTAssertNotNil(cell.selectedBackgroundView);
    XCTAssertTrue([cell.selectedBackgroundView.backgroundColor isEqual:[[LLThemeManager shared].primaryColor colorWithAlphaComponent:0.2]]);
    XCTAssertTrue([cell.textLabel.textColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue([cell.detailTextLabel.textColor isEqual:[LLThemeManager shared].primaryColor]);
    LLDebugConfig *config = [[LLDebugConfig alloc] init];
    config.colorStyle = LLDebugConfigColorStylePro;
    XCTAssertTrue([cell.tintColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue([cell.backgroundColor isEqual:[LLThemeManager shared].backgroundColor]);    XCTAssertTrue([cell.selectedBackgroundView.backgroundColor isEqual:[[LLThemeManager shared].primaryColor colorWithAlphaComponent:0.2]]);
    XCTAssertTrue([cell.textLabel.textColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue([cell.detailTextLabel.textColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue([cell.customLabel.textColor isEqual:[LLThemeManager shared].primaryColor]);
}

@end
