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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (@available(iOS 13.0, *)) {
        return LLDebugConfigEntryWindowStyleNetBar;
    }
    return LLDebugConfigEntryWindowStylePowerBar + 1;
#pragma clang diagnostic pop
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    LLDebugConfigEntryWindowStyle windowStyle = (LLDebugConfigEntryWindowStyle)indexPath.row;
    BOOL isSelected = [LLDebugConfig shared].entryWindowStyle == windowStyle;
    switch (windowStyle) {
        case LLDebugConfigEntryWindowStyleBall: {
            cell.textLabel.text = @"Use \"Ball\"";
        } break;
        case LLDebugConfigEntryWindowStyleTitle: {
            cell.textLabel.text = @"Use \"Title\"";
        } break;
        case LLDebugConfigEntryWindowStyleAppInfo: {
            cell.textLabel.text = @"Use \"AppInfo\"";
        } break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case LLDebugConfigEntryWindowStyleNetBar: {
            cell.textLabel.text = @"Use \"NetBar\"";
        } break;
        case LLDebugConfigEntryWindowStylePowerBar: {
            cell.textLabel.text = @"Use \"PowerBar\"";
        } break;
#pragma clang diagnostic pop
        default:
            break;
    }
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLDebugConfigEntryWindowStyle windowStyle = (LLDebugConfigEntryWindowStyle)indexPath.row;
    [LLDebugConfig shared].entryWindowStyle = windowStyle;
    [tableView reloadData];
}

@end
