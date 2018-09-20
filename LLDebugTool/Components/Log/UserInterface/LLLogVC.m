//
//  LLLogVC.m
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

#import "LLLogVC.h"
#import "LLLogCell.h"
#import "LLConfig.h"
#import "LLStorageManager.h"
#import "LLLogFilterView.h"
#import "LLMacros.h"
#import "LLLogContentVC.h"
#import "LLImageNameConfig.h"
#import "LLSearchBar.h"
#import "NSObject+LL_Utils.h"
#import "LLTool.h"

static NSString *const kLogCellID = @"LLLogCell";

@interface LLLogVC () <UISearchBarDelegate>

@property (nonatomic , strong) UISearchBar *searchBar;

@property (nonatomic , strong) UIBarButtonItem *selectAllItem;

@property (nonatomic , strong) UIBarButtonItem *deleteItem;

@property (nonatomic , strong) UIBarButtonItem *leftItem;

@property (nonatomic , strong) UIBarButtonItem *rightItem;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) NSMutableArray *totalDataArray;

@property (nonatomic , copy) NSString *searchText;

@property (nonatomic , strong) LLLogFilterView *filterView;

// Data
@property (nonatomic , strong) NSArray *currentLevels;
@property (nonatomic , strong) NSArray *currentEvents;
@property (nonatomic , copy) NSString *currentFile;
@property (nonatomic , copy) NSString *currentFunc;
@property (nonatomic , strong) NSDate *currentFromDate;
@property (nonatomic , strong) NSDate *currentEndDate;
@property (nonatomic , strong) NSArray *currentUserIdentities;

@end

@implementation LLLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tableView.isEditing) {
        [self rightItemClick];
    }
    [self.filterView cancelFiltering];
}

- (void)rightItemClick {
    if (self.filterView.isFiltering) {
        return;
    }
    UIBarButtonItem *buttonItem = self.navigationItem.rightBarButtonItem;
    UIButton *btn = buttonItem.customView;
    if (!btn.isSelected) {
        if (self.dataArray.count) {
            btn.selected = !btn.selected;
            [self.tableView setEditing:YES animated:YES];
            self.deleteItem.enabled = NO;
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
    } else {
        btn.selected = !btn.selected;
        [self.tableView setEditing:NO animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)selectAllItemClick:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"Select All"]) {
        item.title = @"Cancel All";
        self.deleteItem.enabled = YES;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        item.title = @"Select All";
        self.deleteItem.enabled = NO;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (void)deleteItemClick:(UIBarButtonItem *)item {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    [self showDeleteAlertWithIndexPaths:indexPaths];
    [self rightItemClick];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLLogCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing == NO) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        LLLogContentVC *vc = [[LLLogContentVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.model = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.deleteItem.enabled = YES;
        if (self.tableView.indexPathsForSelectedRows.count == self.dataArray.count) {
            if ([self.selectAllItem.title isEqualToString:@"Select All"]) {
                self.selectAllItem.title = @"Cancel All";
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        if ([self.selectAllItem.title isEqualToString:@"Select All"] == NO) {
            self.selectAllItem.title = @"Select All";
        }
        if (self.tableView.indexPathsForSelectedRows.count == 0) {
            self.deleteItem.enabled = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showDeleteAlertWithIndexPaths:@[indexPath]];
    }
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
        _launchDate = [NSObject launchDate];
    }
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.totalDataArray = [[NSMutableArray alloc] init];
    
    // TableView
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLLogCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kLogCellID];
    
    // Navigation bar item
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[[UIImage LL_imageNamed:kEditImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setImage:[[UIImage LL_imageNamed:kDoneImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.tintColor = LLCONFIG_TEXT_COLOR;
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
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
    
    self.leftItem = self.navigationItem.leftBarButtonItem;
    self.rightItem = self.navigationItem.rightBarButtonItem;
    
    // ToolBar
    self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = LLCONFIG_TEXT_COLOR;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.deleteItem.enabled = NO;
    
    [self setToolbarItems:@[self.selectAllItem,spaceItem,self.deleteItem] animated:YES];
    
    self.navigationController.toolbar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    
    [self initFilterView];
    
    [self loadData];
}

- (void)initFilterView {
    if (self.filterView == nil) {
        self.filterView = [[LLLogFilterView alloc] initWithFrame:CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, 40)];
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
        [self.filterView configWithData:self.totalDataArray];
        [self.view addSubview:self.filterView];
    }
}


- (void)loadData {
    self.searchBar.text = nil;
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Loading"];
    [[LLStorageManager sharedManager] getModels:[LLLogModel class] launchDate:_launchDate complete:^(NSArray<LLStorageModel *> *result) {
        [LLTool hideLoadingMessage];
        [weakSelf.totalDataArray removeAllObjects];
        [weakSelf.totalDataArray addObjectsFromArray:result];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:weakSelf.totalDataArray];
        [weakSelf.filterView configWithData:weakSelf.totalDataArray];
        [weakSelf.tableView reloadData];
    }];
}

- (void)filterData {
    @synchronized (self) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.totalDataArray];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (LLLogModel *model in self.totalDataArray) {
            // Filter "Search"
            if (self.searchText.length) {
                if (![model.message.lowercaseString containsString:self.searchText.lowercaseString]) {
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
        [self.dataArray removeObjectsInArray:tempArray];
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
        [models addObject:self.dataArray[indexPath.row]];
    }
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Deleting"];
    [[LLStorageManager sharedManager] removeModels:models complete:^(BOOL result) {
        [LLTool hideLoadingMessage];
        if (result) {
            [weakSelf.totalDataArray removeObjectsInArray:models];
            [weakSelf.dataArray removeObjectsInArray:models];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [weakSelf showAlertControllerWithMessage:@"Remove log model fail" handler:^(NSInteger action) {
                if (action == 1) {
                    [weakSelf loadData];
                }
            }];
        }
    }];
}

@end
