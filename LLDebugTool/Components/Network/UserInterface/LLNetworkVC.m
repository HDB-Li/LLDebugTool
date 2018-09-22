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
#import "LLConfig.h"
#import "LLNetworkFilterView.h"
#import "LLSearchBar.h"
#import "LLNetworkFilterView.h"
#import "LLMacros.h"
#import "LLTool.h"
#import "NSObject+LL_Utils.h"

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterView cancelFiltering];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
    [self.filterView cancelFiltering];
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
        _launchDate = [NSObject LL_launchDate];
    }
    self.httpDataArray = [[NSMutableArray alloc] init];
    self.tempHttpDataArray = [[NSMutableArray alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[[UIImage LL_imageNamed:kClearImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.tintColor = LLCONFIG_TEXT_COLOR;
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
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
    self.searchBar.enablesReturnKeyAutomatically = NO;
    
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
        };
        [self.filterView configWithData:self.httpDataArray];
        [self.view addSubview:self.filterView];
    }
}

- (void)loadData {
    self.searchBar.text = nil;
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Loading"];
    [[LLStorageManager sharedManager] getModels:[LLNetworkModel class] launchDate:_launchDate complete:^(NSArray<LLStorageModel *> *result) {
        [LLTool hideLoadingMessage];
        [weakSelf.httpDataArray removeAllObjects];
        [weakSelf.httpDataArray addObjectsFromArray:result];
        [weakSelf.tempHttpDataArray removeAllObjects];
        [weakSelf.tempHttpDataArray addObjectsFromArray:weakSelf.httpDataArray];
        [weakSelf.filterView configWithData:weakSelf.httpDataArray];
        [weakSelf.tableView reloadData];
    }];
}

- (void)filterData {
    @synchronized (self) {
        [self.tempHttpDataArray removeAllObjects];
        [self.tempHttpDataArray addObjectsFromArray:self.httpDataArray];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (LLNetworkModel *model in self.httpDataArray) {

            // Filter Host
            if (self.currentHost.count) {
                NSString *host = model.url.host;
                if (![self.currentHost containsObject:host]) {
                    [tempArray addObject:model];
                    continue;
                }
            }

            // Filter "Search"
            if (self.searchText.length) {
                NSMutableArray *filterArray = [[NSMutableArray alloc] initWithObjects:model.url.absoluteString ?:model.url.host, nil];
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
                    if ([filter.lowercaseString containsString:self.searchText.lowercaseString]) {
                        needPop = NO;
                        break;
                    }
                }
                
                if (needPop) {
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
    __block NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:self.tempHttpDataArray[indexPath.row]];
    }
    
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Deleting"];
    [[LLStorageManager sharedManager] removeModels:models complete:^(BOOL result) {
        [LLTool hideLoadingMessage];
        if (result) {
            [weakSelf.httpDataArray removeObjectsInArray:models];
            [weakSelf.tempHttpDataArray removeObjectsInArray:models];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [weakSelf showAlertControllerWithMessage:@"Remove network model fail" handler:^(NSInteger action) {
                if (action == 1) {
                    [weakSelf loadData];
                }
            }];
        }
    }];
}

@end
