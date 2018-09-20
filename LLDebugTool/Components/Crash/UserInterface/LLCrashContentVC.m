//
//  LLCrashContentVC.m
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

#import "LLCrashContentVC.h"
#import "LLSubTitleTableViewCell.h"
#import "LLMacros.h"
#import "LLStorageManager.h"
#import "LLConfig.h"
#import "LLTool.h"
#import "LLCrashSignalContentVC.h"
#import "LLRoute.h"

static NSString *const kCrashContentCellID = @"CrashContentCellID";

@interface LLCrashContentVC () <LLSubTitleTableViewCellDelegate>

@property (nonatomic , strong) NSMutableArray *titleArray;

@property (nonatomic , strong) NSMutableArray *contentArray;

@property (nonatomic , strong) NSArray *canCopyArray;

@end

@implementation LLCrashContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Table view data source
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
        UIViewController *vc = [LLRoute viewControllerWithName:@"LLLogVC" params:@{@"launchDate" : self.model.launchDate}];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([title isEqualToString:@"Network Requests"]) {
        UIViewController *vc = [LLRoute viewControllerWithName:@"LLNetworkVC" params:@{@"launchDate" : self.model.launchDate}];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([title hasPrefix:@"Signal"]) {
        NSInteger index = 0;
        for (NSString *str in self.titleArray) {
            if ([str isEqualToString:title]) {
                break;
            } else if ([str hasPrefix:@"Signal"]) {
                index++;
            }
        }
        LLCrashSignalContentVC *vc = [[LLCrashSignalContentVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.model = self.model.signals[index];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.canCopyArray containsObject:title]) {
        [[UIPasteboard generalPasteboard] setString:self.contentArray[indexPath.row]];
        [self toastMessage:[NSString stringWithFormat:@"Copy \"%@\" Success",title]];
    }
}

- (void)LLSubTitleTableViewCell:(LLSubTitleTableViewCell *)cell didSelectedContentView:(UITextView *)contentTextView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Primary
- (void)initial {
    self.navigationItem.title = self.model.name;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLSubTitleTableViewCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kCrashContentCellID];
    
    self.titleArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)loadData {
    Class logModelClass = NSClassFromString(kLLLogModelName);
    Class networkModelClass = NSClassFromString(kLLNetworkModelName);
    if (logModelClass != nil && networkModelClass != nil) {
        __weak typeof(self) weakSelf = self;
        [LLTool loadingMessage:@"Loading"];
        [[LLStorageManager sharedManager] getModels:logModelClass launchDate:_model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
            // Get log models.
            __block NSArray *logs = result;
            [[LLStorageManager sharedManager] getModels:networkModelClass launchDate:weakSelf.model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
                [LLTool hideLoadingMessage];
                // Get nework requests.
                NSArray *networkRequests = result;
                [weakSelf updateDataWithLogs:logs networkRequests:networkRequests];
            }];
        }];
    } else if (logModelClass != nil) {
        __weak typeof(self) weakSelf = self;
        [LLTool loadingMessage:@"Loading"];
        [[LLStorageManager sharedManager] getModels:logModelClass launchDate:_model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
            [LLTool hideLoadingMessage];
            // Get log models.
            __block NSArray *logs = result;
            [weakSelf updateDataWithLogs:logs networkRequests:nil];
        }];
    } else if (networkModelClass != nil) {
        __weak typeof(self) weakSelf = self;
        [LLTool loadingMessage:@"Loading"];
        [[LLStorageManager sharedManager] getModels:networkModelClass launchDate:weakSelf.model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
            [LLTool hideLoadingMessage];
            // Get nework requests.
            NSArray *networkRequests = result;
            [weakSelf updateDataWithLogs:nil networkRequests:networkRequests];
        }];
    } else {
        [self updateDataWithLogs:nil networkRequests:nil];
    }
}

- (void)updateDataWithLogs:(NSArray *)logs networkRequests:(NSArray *)networkRequests {
    [self.titleArray removeAllObjects];
    [self.contentArray removeAllObjects];
    
    if (_model.name) {
        [self.titleArray addObject:@"Name"];
        [self.contentArray addObject:_model.name];
    }
    if (_model.reason) {
        [self.titleArray addObject:@"Reason"];
        [self.contentArray addObject:_model.reason];
    }
    if (_model.date) {
        [self.titleArray addObject:@"Date"];
        [self.contentArray addObject:_model.date];
    }
    
    if (logs.count) {
        [self.titleArray addObject:@"Logs"];
        [self.contentArray addObject:[NSString stringWithFormat:@"%ld logs",(unsigned long)logs.count]];
    }
    
    if (networkRequests.count) {
        [self.titleArray addObject:@"Network Requests"];
        [self.contentArray addObject:[NSString stringWithFormat:@"%ld network requests",(unsigned long)networkRequests.count]];
    }
    
    for (LLCrashSignalModel *signal in _model.signals) {
        [self.titleArray addObject:[NSString stringWithFormat:@"Signal (%@)",signal.name]];
        [self.contentArray addObject:_model.date];
    }
    
    if (_model.userIdentity) {
        [self.titleArray addObject:@"User Identity"];
        [self.contentArray addObject:_model.userIdentity];
    }
    if (_model.stackSymbols.count) {
        [self.titleArray addObject:@"Stack Symbols"];
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        for (NSString *symbol in _model.stackSymbols) {
            [mutStr appendFormat:@"%@\n\n",symbol];
        }
        [self.contentArray addObject:mutStr];
    }
    if (_model.userInfo.allKeys.count) {
        [self.titleArray addObject:@"UserInfo"];
        NSMutableString *content = [[NSMutableString alloc] init];
        for (NSString *key in _model.userInfo.allKeys) {
            [content appendFormat:@"%@ : %@\n",key,_model.userInfo[key]];
        }
        [self.contentArray addObject:content];
    }
    if (_model.appInfos.count) {
        [self.titleArray addObject:@"App Infos"];
        NSMutableString *str = [[NSMutableString alloc] init];
        for (NSArray *array in _model.appInfos) {
            for (NSDictionary *dic in array) {
                for (NSString *key in dic) {
                    [str appendFormat:@"%@ : %@\n",key,dic[key]];
                }
            }
            [str appendString:@"\n"];
        }
        [self.contentArray addObject:str];
    }
    [self.tableView reloadData];
}

- (NSArray *)canCopyArray {
    if (!_canCopyArray) {
        _canCopyArray = @[@"Name",@"Reason",@"Stack Symbols"];
    }
    return _canCopyArray;
}

@end
