//
//  TestCrashViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2018/8/29.
//  Copyright © 2018年 li. All rights reserved.
//

#import "TestCrashViewController.h"
#import "LLDebugTool.h"

@interface TestCrashViewController ()

@end

@implementation TestCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.crash", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"try.array.crash", nil);
        cell.detailTextLabel.text = NSLocalizedString(@"crash.info", nil);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"try.pointer.crash", nil);
        cell.detailTextLabel.text = NSLocalizedString(@"crash.info", nil);
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"try.signal", nil);
        cell.detailTextLabel.text = NSLocalizedString(@"signal.info", nil);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testArrayOutRangeCrash];
    } else if (indexPath.row == 1) {
        [self testPointErrorCrash];
    } else if (indexPath.row == 2) {
        [self testSignalCrash];
    }
}

#pragma mark - Actions
- (void)testArrayOutRangeCrash {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openCrash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *array = @[@"a",@"b"];
    __unused NSString *str = array[3];
}

- (void)testPointErrorCrash {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openCrash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *a = (NSArray *)@"dssdf";
    __unused NSString *b = [a firstObject];
}

- (void)testSignalCrash {
    kill(0, SIGTRAP);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:2];
    });
}

@end
