//
//  TestShortCutViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2019/11/25.
//  Copyright © 2019 li. All rights reserved.
//

#import "TestShortCutViewController.h"
#import "LLDebug.h"

@interface TestShortCutViewController ()

@end

@implementation TestShortCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.short.cut", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"add.custom.short.cut", nil);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"add.custom.none.return.short.cut", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testCustomShortCut];
    } else if (indexPath.row == 1) {
        [self testCustomShortCutWithNoneReturn];
    }
}

#pragma mark - Action
- (void)testCustomShortCut {
    [[LLConfig shared] registerShortCutWithName:@"Toast date" action:^NSString * _Nullable{
        return [[NSDate date] description];
    }];
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionShortCut];
}

- (void)testCustomShortCutWithNoneReturn {
    [[LLConfig shared] registerShortCutWithName:@"Do anything" action:^NSString * _Nullable{
        NSLog(@"You can do anything at here.");
        return nil;
    }];
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionShortCut];
}

@end
