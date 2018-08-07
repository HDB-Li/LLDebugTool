//
//  LLNetworkVC.m
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

#import "LLNetworkVC.h"
#import "LLNetworkCell.h"
#import "LLNetworkModel.h"
#import "LLStorageManager.h"
#import "LLNetworkContentVC.h"
#import "LLImageNameConfig.h"
#import "LLAppHelper.h"
#import "LLConfig.h"
#import "LLNetworkFilterView.h"
#import "LLSearchBar.h"
#import "LLNetworkFilterView.h"
#import "LLMacros.h"

static NSString *const kNetworkCellID = @"NetworkCellID";

@interface LLNetworkVC () <UISearchBarDelegate>

@property (nonatomic , strong) UISearchBar *searchBar;

@property (nonatomic , strong) NSMutableArray *httpDataArray;

@property (nonatomic , strong) NSMutableArray *tempHttpDataArray;

@property (nonatomic , copy) NSString *searchText;

@property (nonatomic , strong) LLNetworkFilterView *filterView;

// Data
@property (nonatomic , strong) NSArray *currentHost;
@property (nonatomic , strong) NSArray *currentTypes;
@property (nonatomic , strong) NSDate *currentFromDate;
@property (nonatomic , strong) NSDate *currentEndDate;

@end

@implementation LLNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Actions
- (void)segmentValueChanged:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (void)rightItemClick {
    NSArray *dataArray = self.tempHttpDataArray;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self showDeleteAlertWithIndexPaths:indexPaths];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tempHttpDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.tempHttpDataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLNetworkContentVC *vc = [[LLNetworkContentVC alloc] init];
    vc.model = self.tempHttpDataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.filterView cancelFiltering];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.filterView cancelFiltering];
    if (self.tableView.isEditing) {
        [self rightItemClick];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = self.searchBar.text;
    [self filterData];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = self.searchText;
}

#pragma mark - Primary
- (void)initial {
    if (_launchDate == nil) {
        _launchDate = [LLAppHelper sharedHelper].launchDate;
    }
    self.httpDataArray = [[NSMutableArray alloc] init];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11) {
        self.searchBar = [[LLSearchBar alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH - 120, 40)];
        self.searchBar.delegate = self;
        UIView *titleView = [[LLSearchBarBackView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH - 120, 40)];
        [titleView addSubview:self.searchBar];
        self.navigationItem.titleView = titleView;
    } else {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        self.searchBar.delegate = self;
        self.navigationItem.titleView = self.searchBar;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LLNetworkCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kNetworkCellID];
    
    [self initFilterView];
    
    [self loadData];
}

- (void)initFilterView {
    if (self.filterView == nil) {
        self.filterView = [[LLNetworkFilterView alloc] initWithFrame:CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, 40)];
        __weak typeof(self) weakSelf = self;
        self.filterView.changeBlock = ^(NSArray *hosts, NSArray *types, NSDate *from, NSDate *end) {
            weakSelf.currentHost = hosts;
            weakSelf.currentTypes = types;
            weakSelf.currentFromDate = from;
            weakSelf.currentEndDate = end;
            [weakSelf filterData];
        }
        [self.filterView configWithData:self.httpDataArray];
        [self.view addSubview:self.filterView];
    }
}

- (void)loadData {
    self.searchBar.text = nil;
    [self.httpDataArray removeAllObjects];
    [self.httpDataArray addObjectsFromArray:[[LLStorageManager sharedManager] getAllNetworkModelsWithLaunchDate:_launchDate]];
    [self.tempHttpDataArray removeAllObjects];
    [self.tempHttpDataArray addObjectsFromArray:self.httpDataArray];
    [self.filterView configWithData:self.httpDataArray];
    [self.tableView reloadData];
}

- (void)filterData {
    @synchronized (self) {
        [self.tempHttpDataArray removeAllObjects];
        [self.tempHttpDataArray addObjectsFromArray:self.httpDataArray];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (LLNetworkModel *model in self.httpDataArray) {
            // Filter "Search"
            if (self.searchText.length) {
                if (![model.message containsString:self.searchText]) {
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
        [self.tempHttpDataArray removeObjectsInArray:tempArray];
        [self.tableView reloadData];
    }
}

- (void)showDeleteAlertWithIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count) {
        [self showAlertControllerWithMessage:@"Sure to remove items ?" handler:^(NSInteger action) {
            if (action == 1) {
                [self deleteFilesWithIndexPaths:indexPaths];
            }
        }];
    }
}

- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:self.tempHttpDataArray[indexPath.row]];
    }
    if ([[LLStorageManager sharedManager] removeNetworkModels:models]) {
        [self.httpDataArray removeObjectsInArray:models];
        [self.tempHttpDataArray removeObjectsInArray:models];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self showAlertControllerWithMessage:@"Remove network model fail" handler:^(NSInteger action) {
            if (action == 1) {
                [self loadData];
            }
        }];
    }
}

@end
