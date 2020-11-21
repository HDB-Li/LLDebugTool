//
//  LLLogViewController.m
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

#import "LLLogViewController.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLLogCell.h"
#import "LLLogDetailViewController.h"
#import "LLLogFilterView.h"
#import "LLLogModel.h"
#import "LLStorageManager.h"
#import "LLToastUtils.h"

#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

static NSString *const kLogCellID = @"LLLogCell";

@interface LLLogViewController ()

@property (nonatomic, strong) LLLogFilterView *filterView;

// Data
@property (nonatomic, strong) NSArray *currentLevels;
@property (nonatomic, strong) NSArray *currentEvents;
@property (nonatomic, copy) NSString *currentFile;
@property (nonatomic, copy) NSString *currentFunc;
@property (nonatomic, strong) NSDate *currentFromDate;
@property (nonatomic, strong) NSDate *currentEndDate;
@property (nonatomic, strong) NSArray *currentUserIdentities;

@end

@implementation LLLogViewController

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
    self.title = LLLocalizedString(@"function.log");

    if (_launchDate == nil) {
        _launchDate = [NSObject LL_launchDate];
    }

    // TableView
    [self.tableView registerClass:[LLLogCell class] forCellReuseIdentifier:kLogCellID];

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
    return [super isSearching] || self.currentLevels.count || self.currentEvents.count || self.currentFile.length || self.currentFunc.length || self.currentFromDate || self.currentEndDate || self.currentUserIdentities.count;
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
                                           [weakSelf updateAfterDelete:models indexPaths:indexPaths];
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

- (void)updateAfterDelete:(NSArray *)models indexPaths:(NSArray *)indexPaths {
    NSMutableSet *set = [NSMutableSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    [set intersectSet:[NSSet setWithArray:indexPaths]];
    if ([set count] > 0) {
        NSMutableArray *noAnimateModels = [[NSMutableArray alloc] initWithArray:models];
        NSMutableArray *animatedModels = [[NSMutableArray alloc] init];

        for (NSIndexPath *indexPath in set.allObjects) {
            LLLogModel *model = self.datas[indexPath.row];
            [noAnimateModels removeObject:model];
            [animatedModels addObject:model];
        }
        [self.oriDataArray removeObjectsInArray:animatedModels];
        [self.searchDataArray removeObjectsInArray:animatedModels];
        [self.tableView deleteRowsAtIndexPaths:set.allObjects withRowAnimation:UITableViewRowAnimationFade];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.oriDataArray removeObjectsInArray:noAnimateModels];
            [self.searchDataArray removeObjectsInArray:noAnimateModels];
            [self.tableView reloadData];
        });
    } else {
        [self.oriDataArray removeObjectsInArray:models];
        [self.searchDataArray removeObjectsInArray:models];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLLogCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (self.tableView.isEditing == NO) {
        LLLogDetailViewController *vc = [[LLLogDetailViewController alloc] init];
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
    [[LLStorageManager shared] getModels:[LLLogModel class]
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
    for (LLLogModel *model in self.oriDataArray) {
        BOOL isRemove = [self needRemove:model];

        if (isRemove) {
            [tempArray addObject:model];
            continue;
        }
    }
    [self.searchDataArray removeObjectsInArray:tempArray];
    [self.tableView reloadData];
}

- (BOOL)needRemove:(LLLogModel *)model {
    BOOL isRemove = NO;

    // Filter "Search"
    isRemove = isRemove || [self ignoreInSearch:model];

    // Filter Level
    isRemove = isRemove || [self ignoreInLevel:model];

    // Filter Event
    isRemove = isRemove || [self ignoreInEvent:model];

    // Filter File
    isRemove = isRemove || [self ignoreInFile:model];

    // Filter Func
    isRemove = isRemove || [self ignoreInFunc:model];

    // Filter Date
    isRemove = isRemove || [self ignoreInDate:model];

    // Filter userIdentities
    isRemove = isRemove || [self ignoreInUserIdentities:model];

    return isRemove;
}

- (BOOL)ignoreInSearch:(LLLogModel *)model {
    return self.searchTextField.text.length && ![model.message.lowercaseString containsString:self.searchTextField.text.lowercaseString];
}

- (BOOL)ignoreInLevel:(LLLogModel *)model {
    return self.currentLevels.count && ![self.currentLevels containsObject:model.levelDescription];
}

- (BOOL)ignoreInEvent:(LLLogModel *)model {
    return self.currentEvents.count && ![self.currentEvents containsObject:model.event];
}

- (BOOL)ignoreInFile:(LLLogModel *)model {
    return self.currentFile.length && ![model.file isEqualToString:self.currentFile];
}

- (BOOL)ignoreInFunc:(LLLogModel *)model {
    return self.currentFunc.length && ![model.function isEqualToString:self.currentFunc];
}

- (BOOL)ignoreInDate:(LLLogModel *)model {
    return (self.currentFromDate && [model.dateDescription compare:self.currentFromDate] == NSOrderedAscending) || (self.currentEndDate && [model.dateDescription compare:self.currentEndDate] == NSOrderedDescending);
}

- (BOOL)ignoreInUserIdentities:(LLLogModel *)model {
    return self.currentUserIdentities.count && ![self.currentUserIdentities containsObject:model.userIdentity];
}

#pragma mark - Getters and setters
- (LLLogFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[LLLogFilterView alloc] initWithFrame:CGRectMake(0, self.searchTextField.LL_bottom + kLLGeneralMargin, LL_SCREEN_WIDTH, 40)];
        __weak typeof(self) weakSelf = self;
        _filterView.changeBlock = ^(NSArray *levels, NSArray *events, NSString *file, NSString *func, NSDate *from, NSDate *end, NSArray *userIdentities) {
            weakSelf.currentLevels = levels;
            weakSelf.currentEvents = events;
            weakSelf.currentFile = file;
            weakSelf.currentFunc = func;
            weakSelf.currentFromDate = from;
            weakSelf.currentEndDate = end;
            weakSelf.currentUserIdentities = userIdentities;
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
