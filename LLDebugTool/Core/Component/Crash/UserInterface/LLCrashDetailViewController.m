//
//  LLCrashDetailViewController.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLCrashDetailViewController.h"

#import "LLCrashModel.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLInternalMacros.h"
#import "LLStorageManager.h"
#import "LLSubTitleTableViewCell.h"
#import "LLToastUtils.h"

#import "NSDictionary+LL_Utils.h"

static NSString *const kCrashContentCellID = @"CrashContentCellID";

@interface LLCrashDetailViewController () <UITableViewDataSource, LLSubTitleTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSArray *canCopyArray;

@end

@implementation LLCrashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LLSubTitleTableViewCell class] forCellReuseIdentifier:kCrashContentCellID];

    self.titleArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];

    [self loadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashContentCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentText = self.contentArray[indexPath.row];
    cell.delegate = self;
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:@"Logs"] || [title isEqualToString:@"Network Requests"] || [title hasPrefix:@"Signal"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:@"Logs"]) {
        UIViewController *vc = nil;
        if ([LLDT_CC_Log respondsToSelector:@selector(logViewControllerWithLaunchDate:)]) {
            vc = [LLDT_CC_Log logViewControllerWithLaunchDate:self.model.launchDate];
        }
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([title isEqualToString:@"Network Requests"]) {
        UIViewController *vc = [LLDT_CC_Network networkViewControllerWithLaunchDate:self.model.launchDate];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([self.canCopyArray containsObject:title]) {
        [[UIPasteboard generalPasteboard] setString:self.contentArray[indexPath.row]];
        [[LLToastUtils shared] toastMessage:[NSString stringWithFormat:LLLocalizedString(@"copy.success"), title]];
    }
}

- (void)LLSubTitleTableViewCell:(LLSubTitleTableViewCell *)cell didSelectedContentView:(UITextView *)contentTextView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Primary
- (void)loadData {
    Class cls = nil;
    if ([LLDT_CC_Log respondsToSelector:@selector(logModelClass)]) {
        cls = [LLDT_CC_Log logModelClass];
    }
    __weak typeof(self) weakSelf = self;
    [[LLToastUtils shared] loadingMessage:LLLocalizedString(@"loading")];
    [[LLStorageManager shared] getModels:cls
                              launchDate:_model.launchDate
                                complete:^(NSArray<LLStorageModel *> *result) {
                                    // Get log models.
                                    __block NSArray *logs = result;
                                    [[LLStorageManager shared] getModels:[LLDT_CC_Network networkModelClass]
                                                              launchDate:weakSelf.model.launchDate
                                                                complete:^(NSArray<LLStorageModel *> *result) {
                                                                    [[LLToastUtils shared] hide];
                                                                    // Get nework requests.
                                                                    NSArray *networkRequests = result;
                                                                    [weakSelf updateDataWithLogs:logs networkRequests:networkRequests];
                                                                }];
                                }];
}

- (void)updateDataWithLogs:(NSArray *)logs networkRequests:(NSArray *)networkRequests {
    [self.titleArray removeAllObjects];
    [self.contentArray removeAllObjects];

    [self loadTitle:@"Name" value:_model.name];
    [self loadTitle:@"Reason" value:_model.reason];
    [self loadTitle:@"Date" value:_model.date];
    [self loadTitle:@"Logs" value:[NSString stringWithFormat:@"%@ logs", @(logs.count)]];
    [self loadTitle:@"Network Requests" value:[NSString stringWithFormat:@"%@ network requests", @(networkRequests.count)]];
    [self loadTitle:@"Thread" value:_model.thread];
    [self loadTitle:@"User Identity" value:_model.userIdentity];
    if (_model.stackSymbols.count) {
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        for (NSString *symbol in _model.stackSymbols) {
            [mutStr appendFormat:@"%@\n\n", symbol];
        }
        [self loadTitle:@"Stack Symbols" value:[mutStr copy]];
    }
    [self loadTitle:@"UserInfo" value:_model.userInfo.LL_displayString];
    [self loadTitle:@"App Infos" value:_model.appInfoDescription];

    [self.tableView reloadData];
}

- (void)loadTitle:(NSString *)title value:(NSString *)value {
    if (title && value) {
        [self.titleArray addObject:title];
        [self.contentArray addObject:value];
    }
}

- (NSArray *)canCopyArray {
    if (!_canCopyArray) {
        _canCopyArray = @[@"Name", @"Reason", @"Stack Symbols"];
    }
    return _canCopyArray;
}

@end
