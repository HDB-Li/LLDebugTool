//
//  TestHtmlViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2019/10/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "TestHtmlViewController.h"
#import "CustomWebViewController.h"
#import "LLDebug.h"

@interface TestHtmlViewController ()

@end

@implementation TestHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.html", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"show.html", nil);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"show.custom.html", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testHtml];
    } else if (indexPath.row == 1) {
        [self testCustomHtmlViewController];
    }
}

#pragma mark - Action
- (void)testHtml {
    if ([LLConfig shared].htmlViewControllerProvider) {
        [LLConfig shared].htmlViewControllerProvider = nil;
    }
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionHtml];
}

- (void)testCustomHtmlViewController {
    if (![LLConfig shared].htmlViewControllerProvider) {
        [LLConfig shared].htmlViewControllerProvider = ^UIViewController * _Nonnull(NSString * _Nonnull url) {
            CustomWebViewController *vc = [[CustomWebViewController alloc] init];
            vc.url = url;
            return vc;
        };
    }
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionHtml];
}

@end
