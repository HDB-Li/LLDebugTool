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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"add.custom.short.cut", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testCustomShortCut];
    }
}

#pragma mark - Action
- (void)testCustomShortCut {
    [[LLDebugTool sharedTool] registerShortCutWithName:@"Toast date" action:^NSString * _Nullable{
        return [[NSDate date] description];
    }];
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionShortCut];
}

@end
