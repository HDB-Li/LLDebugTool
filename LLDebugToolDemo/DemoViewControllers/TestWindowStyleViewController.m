//
//  TestWindowStyleViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2018/8/29.
//  Copyright © 2018年 li. All rights reserved.
//

#import "TestWindowStyleViewController.h"
#import "LLDebugTool.h"

@interface TestWindowStyleViewController ()

@end

@implementation TestWindowStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.window.style", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (@available(iOS 13.0, *)) {
        return 4;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Use \"Ball\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleBall ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Use \"Title\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleTitle ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Use \"Leading\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleLeading ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Use \"Trailing\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleTrailing ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Use \"NetBar\"";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleNetBar ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
#pragma clang diagnostic pop
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Use \"PowerBar\"";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStylePowerBar ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
#pragma clang diagnostic pop
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testBallWindowStyle];
    } else if (indexPath.row == 1) {
        [self testTitleWindowStyle];
    } else if (indexPath.row == 2) {
        [self testLeadingWindowStyle];
    } else if (indexPath.row == 3) {
        [self testTrailingWindowStyle];
    } else if (indexPath.row == 4) {
        [self testNetBarWindowStyle];
    } else if (indexPath.row == 5) {
        [self testPowerBarWindowStyle];
    }
    [tableView reloadData];
}

#pragma mark - Actions
- (void)testBallWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleBall;
}

- (void)testTitleWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleTitle;
}

- (void)testLeadingWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleLeading;
}

- (void)testTrailingWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleTrailing;
}

- (void)testNetBarWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleNetBar;
}

- (void)testPowerBarWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStylePowerBar;
}

@end
