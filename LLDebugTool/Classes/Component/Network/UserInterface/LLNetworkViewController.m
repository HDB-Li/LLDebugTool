//
//  LLNetworkViewController.m
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

#import "LLNetworkViewController.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLNetworkCell.h"
#import "LLNetworkDetailViewController.h"
#import "LLNetworkFilterView.h"
#import "LLNetworkModel.h"
#import "LLStorageManager.h"
#import "LLToastUtils.h"

#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

static NSString *const kNetworkCellID = @"NetworkCellID";

@interface LLNetworkViewController ()

@property (nonatomic, strong) LLNetworkFilterView *filterView;

// Data
@property (nonatomic, strong) NSArray *currentHost;
@property (nonatomic, strong) NSArray *currentTypes;
@property (nonatomic, strong) NSDate *currentFromDate;
@property (nonatomic, strong) NSDate *currentEndDate;

@end

@implementation LLNetworkViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSearchEnable = YES;
        self.isSelectEnable = YES;
        self.isDeleteEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"function.net");

    if (_launchDate == nil) {
        _launchDate = [NSObject LL_launchDate];
    }

    [self.tableView registerClass:[LLNetworkCell class] forCellReuseIdentifier:kNetworkCellID];

    [self.headerView addSubview:self.filterView];
    self.headerView.frame = CGRectMake(self.headerView.LL_x, self.headerView.LL_y, self.headerView.LL_width, self.filterView.LL_bottom);

    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterView cancelFiltering];
}

- (void)rightItemClick:(UIButton *)sender {
    [super rightItemClick:sender];
    [self.filterView cancelFiltering];
}

- (BOOL)isSearching {
    return [super isSearching] || self.currentHost.count || self.currentTypes.count || self.currentFromDate || self.currentEndDate;
}

- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    [super deleteFilesWithIndexPaths:indexPaths];
    __block NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:self.datas[indexPath.row]];
    }

    __weak typeof(self) weakSelf = self;
    [[LLToastUtils shared] loadingMessage:LLLocalizedString(@"deleting")];
    [[LLStorageManager shared] removeModels:models
                                   complete:^(BOOL result) {
                                       [[LLToastUtils shared] hide];
                                       if (result) {
                                           [weakSelf.oriDataArray removeObjectsInArray:models];
                                           [weakSelf.searchDataArray removeObjectsInArray:models];
                                           [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                                       } else {
                                           [weakSelf LL_showAlertControllerWithMessage:LLLocalizedString(@"remove.fail")
                                                                               handler:^(NSInteger action) {
                                                                                   if (action == 1) {
                                                                                       [weakSelf loadData];
                                                                                   }
                                                                               }];
                                       }
                                   }];
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (self.tableView.isEditing == NO) {
        LLNetworkDetailViewController *vc = [[LLNetworkDetailViewController alloc] init];
        vc.model = self.datas[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.LL_height;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    [self.filterView cancelFiltering];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    [self.filterView cancelFiltering];
}

- (void)textFieldDidChange:(NSString *)text {
    [super textFieldDidChange:text];
    [self.filterView cancelFiltering];
    [self filterData];
}

#pragma mark - Primary
- (void)loadData {
    self.searchTextField.text = nil;
    __weak typeof(self) weakSelf = self;
    [[LLToastUtils shared] loadingMessage:LLLocalizedString(@"loading")];
    [[LLStorageManager shared] getModels:[LLNetworkModel class]
                              launchDate:_launchDate
                                complete:^(NSArray<LLStorageModel *> *result) {
                                    [[LLToastUtils shared] hide];
                                    [weakSelf.oriDataArray removeAllObjects];
                                    [weakSelf.oriDataArray addObjectsFromArray:result];
                                    [weakSelf.searchDataArray removeAllObjects];
                                    [weakSelf.searchDataArray addObjectsFromArray:weakSelf.oriDataArray];
                                    [weakSelf.filterView configWithData:weakSelf.oriDataArray];
                                    [weakSelf.tableView reloadData];
                                }];
}

- (void)filterData {
    [self.searchDataArray removeAllObjects];
    [self.searchDataArray addObjectsFromArray:self.oriDataArray];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (LLNetworkModel *model in self.oriDataArray) {
        if ([self isNeedRemove:model]) {
            [tempArray addObject:model];
            continue;
        }
    }
    [self.searchDataArray removeObjectsInArray:tempArray];
    [self.tableView reloadData];
}

- (BOOL)isNeedRemove:(LLNetworkModel *)model {
    BOOL isRemove = NO;

    // Filter Host
    isRemove = isRemove || [self ignoreInHost:model];

    // Filter "Search"
    isRemove = isRemove || [self ignoreInSearch:model];

    // Filter Date
    isRemove = isRemove || [self ignoreInDate:model];

    return isRemove;
}

- (BOOL)ignoreInHost:(LLNetworkModel *)model {
    return self.currentHost.count && model.url.host && ![self.currentHost containsObject:model.url.host];
}

- (BOOL)ignoreInSearch:(LLNetworkModel *)model {
    if (self.searchTextField.text.length) {
        NSMutableArray *filterArray = [[NSMutableArray alloc] initWithObjects:model.url.absoluteString ?: model.url.host, nil];
        BOOL checkHeader = [self.currentTypes containsObject:@"Header"];
        BOOL checkBody = [self.currentTypes containsObject:@"Body"];
        BOOL checkResponse = [self.currentTypes containsObject:@"Response"];
        BOOL needPop = YES;

        if (checkHeader && model.headerString.length) {
            [filterArray addObject:model.headerString];
        }

        if (checkBody && model.requestBody.length) {
            [filterArray addObject:model.requestBody];
        }

        if (checkResponse && model.responseString.length) {
            [filterArray addObject:model.responseString];
        }

        for (NSString *filter in filterArray) {
            if ([filter.lowercaseString containsString:self.searchTextField.text.lowercaseString]) {
                needPop = NO;
                break;
            }
        }

        return needPop;
    }
    return NO;
}

- (BOOL)ignoreInDate:(LLNetworkModel *)model {
    if (self.currentFromDate) {
        if ([model.dateDescription compare:self.currentFromDate] == NSOrderedAscending) {
            return YES;
        }
    }

    if (self.currentEndDate) {
        if ([model.dateDescription compare:self.currentEndDate] == NSOrderedDescending) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Getters and setters
- (LLNetworkFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[LLNetworkFilterView alloc] initWithFrame:CGRectMake(0, self.searchTextField.LL_bottom + kLLGeneralMargin, LL_SCREEN_WIDTH, 40)];
        __weak typeof(self) weakSelf = self;
        _filterView.changeBlock = ^(NSArray *hosts, NSArray *types, NSDate *from, NSDate *end) {
            weakSelf.currentHost = hosts;
            weakSelf.currentTypes = types;
            weakSelf.currentFromDate = from;
            weakSelf.currentEndDate = end;
            [weakSelf filterData];
        };
        _filterView.filterChangeStateBlock = ^{
            [weakSelf.tableView reloadData];
        };
        [_filterView configWithData:self.oriDataArray];
    }
    return _filterView;
}

@end
