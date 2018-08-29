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
#import "LLCrashContentCell.h"
#import "LLMacros.h"
#import "LLStorageManager.h"
#import "LLNetworkVC.h"
#import "LLLogVC.h"
#import "LLConfig.h"
#import "LLTool.h"

static NSString *const kCrashContentCellID = @"CrashContentCellID";

@interface LLCrashContentVC ()

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCrashContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashContentCellID forIndexPath:indexPath];
    [cell confirmContent:self.contentArray[indexPath.section]];
    if ([self.titleArray[indexPath.section] isEqualToString:@"Logs"] || [self.titleArray[indexPath.section] isEqualToString:@"Network Requests"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.userInteractionEnabled = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.userInteractionEnabled = YES;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = self.titleArray[section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 30)];
    view.backgroundColor = [LLCONFIG_TEXT_COLOR colorWithAlphaComponent:0.2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, view.frame.size.width - 16 * 2, view.frame.size.height)];
    label.textColor = LLCONFIG_TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:13];
    label.text = title;
    [view addSubview:label];
    
    if ([self.canCopyArray containsObject:title]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(LL_SCREEN_WIDTH - 80 - 10, 0, 80, 30);
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:@"Copy" forState:UIControlStateNormal];
        button.tag = section;
        button.tintColor = LLCONFIG_TEXT_COLOR;
        [button addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.titleArray[indexPath.section] isEqualToString:@"Logs"]) {
        LLLogVC *vc = [[LLLogVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.launchDate = self.model.launchDate;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleArray[indexPath.section] isEqualToString:@"Network Requests"]) {
        LLNetworkVC *vc = [[LLNetworkVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.launchDate = self.model.launchDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Primary
- (void)initial {
    self.navigationItem.title = self.model.name;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLCrashContentCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kCrashContentCellID];
    
    self.titleArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Loading"];
    [[LLStorageManager sharedManager] getModels:[LLLogModel class] launchDate:_model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
        // Get log models.
        __block NSArray *logs = result;
        [[LLStorageManager sharedManager] getModels:[LLNetworkModel class] launchDate:weakSelf.model.launchDate complete:^(NSArray<LLStorageModel *> *result) {
            [LLTool hideLoadingMessage];
            // Get nework requests.
            NSArray *networkRequests = result;
            [weakSelf updateDataWithLogs:logs networkRequests:networkRequests];
        }];
    }];
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

- (void)copyButtonClick:(UIButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.contentArray[sender.tag]];
    [self toastMessage:@"Copy Success"];
}

- (NSArray *)canCopyArray {
    if (!_canCopyArray) {
        _canCopyArray = @[@"Name",@"Reason",@"Stack Symbols"];
    }
    return _canCopyArray;
}

@end
