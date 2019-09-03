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
#ifdef __IPHONE_13_0
    return 4;
#else
    return 6;
#endif
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
#ifndef __IPHONE_13_0
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Use \"NetBar\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStyleNetBar ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Use \"PowerBar\"";
        cell.accessoryType = [LLConfig shared].entryWindowStyle == LLConfigEntryWindowStylePowerBar ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
#endif
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testSuspensionBallWindowStyle];
    } else if (indexPath.row == 1) {
        [self testTitleWindowStyle];
    } else if (indexPath.row == 2) {
        [self testSuspensionLeadingWindowStyle];
    } else if (indexPath.row == 3) {
        [self testSuspensionTrailingWindowStyle];
    } else if (indexPath.row == 4) {
        [self testNetBarWindowStyle];
    } else if (indexPath.row == 5) {
        [self testPowerBarWindowStyle];
    }
    [tableView reloadData];
}

#pragma mark - Actions
- (void)testSuspensionBallWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleBall;
}

- (void)testTitleWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleTitle;
}

- (void)testSuspensionLeadingWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleLeading;
}

- (void)testSuspensionTrailingWindowStyle {
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleTrailing;
}

- (void)testNetBarWindowStyle {
#ifndef __IPHONE_13_0
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleNetBar;
#else
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleLeading;
#endif
}

- (void)testPowerBarWindowStyle {
#ifndef __IPHONE_13_0
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStylePowerBar;
#else
    [LLConfig shared].entryWindowStyle = LLConfigEntryWindowStyleTrailing;
#endif
}

@end
