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

#import "LLLogDetailViewController.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLStorageManager.h"
#import "LLLogFilterView.h"
#import "LLToastUtils.h"
#import "LLLogModel.h"
#import "LLLogCell.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"
#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"

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

- (instancetype)init
{
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
    
    self.filterView = [[LLLogFilterView alloc] initWithFrame:CGRectMake(0, self.searchTextField.LL_bottom + kLLGeneralMargin, LL_SCREEN_WIDTH, 40)];
    __weak typeof(self) weakSelf = self;
    self.filterView.changeBlock = ^(NSArray *levels, NSArray *events, NSString *file, NSString *func, NSDate *from, NSDate *end, NSArray *userIdentities) {
        weakSelf.currentLevels = levels;
        weakSelf.currentEvents = events;
        weakSelf.currentFile = file;
        weakSelf.currentFunc = func;
        weakSelf.currentFromDate= from;
        weakSelf.currentEndDate = end;
        weakSelf.currentUserIdentities = userIdentities;
        [weakSelf filterData];
    };
    self.filterView.filterChangeStateBlock = ^{
        [weakSelf.tableView reloadData];
    };
    [self.filterView configWithData:self.oriDataArray];
    
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
    [[LLStorageManager shared] removeModels:models complete:^(BOOL result) {
        [[LLToastUtils shared] hide];
        if (result) {
            [weakSelf updateAfterDelete:models indexPaths:indexPaths];
        } else {
            [weakSelf LL_showAlertControllerWithMessage:LLLocalizedString(@"remove.fail") handler:^(NSInteger action) {
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
    [[LLStorageManager shared] getModels:[LLLogModel class] launchDate:_launchDate complete:^(NSArray<LLStorageModel *> *result) {
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
    @synchronized (self) {
        [self.searchDataArray removeAllObjects];
        [self.searchDataArray addObjectsFromArray:self.oriDataArray];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (LLLogModel *model in self.oriDataArray) {
            // Filter "Search"
            if (self.searchTextField.text.length) {
                if (![model.message.lowercaseString containsString:self.searchTextField.text.lowercaseString]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            // Filter Level
            if (self.currentLevels.count) {
                if (![self.currentLevels containsObject:model.levelDescription]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            // Filter Event
            if (self.currentEvents.count) {
                if (![self.currentEvents containsObject:model.event]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            // Filter File
            if (self.currentFile.length) {
                if (![model.file isEqualToString:self.currentFile]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            // Filter Func
            if (self.currentFunc.length) {
                if (![model.function isEqualToString:self.currentFunc]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            // Filter Date
            if (self.currentFromDate) {
                if ([model.dateDescription compare:self.currentFromDate] == NSOrderedAscending) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            if (self.currentEndDate) {
                if ([model.dateDescription compare:self.currentEndDate] == NSOrderedDescending) {
                    [tempArray addObject:model];
                    continue;
                }
            }
            
            if (self.currentUserIdentities.count) {
                if (![self.currentUserIdentities containsObject:model.userIdentity]) {
                    [tempArray addObject:model];
                    continue;
                }
            }
        }
        [self.searchDataArray removeObjectsInArray:tempArray];
        [self.tableView reloadData];
    }
}

@end
