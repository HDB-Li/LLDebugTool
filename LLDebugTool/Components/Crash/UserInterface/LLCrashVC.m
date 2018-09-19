//
//  LLCrashVC.m
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

#import "LLCrashVC.h"
#import "LLCrashCell.h"
#import "LLCrashModel.h"
#import "LLConfig.h"
#import "LLCrashHelper.h"
#import "LLStorageManager.h"
#import "LLCrashContentVC.h"
#import "LLImageNameConfig.h"
#import "LLTool.h"

static NSString *const kCrashCellID = @"CrashCellID";

@interface LLCrashVC ()

@property (nonatomic , strong) UIBarButtonItem *selectAllItem;

@property (nonatomic , strong) UIBarButtonItem *deleteItem;

@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation LLCrashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tableView.isEditing) {
        [self rightItemClick];
    }
}

- (void)rightItemClick {
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
    [self _showDeleteAlertWithIndexPaths:indexPaths];
    [self rightItemClick];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCrashCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing == NO) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        LLCrashContentVC *vc = [[LLCrashContentVC alloc] initWithStyle:UITableViewStyleGrouped];
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
        [self _showDeleteAlertWithIndexPaths:@[indexPath]];
    }
}

#pragma mark - Primary
- (void)initial {
    self.navigationItem.title = @"Crash Report";
    self.dataArray = [[NSMutableArray alloc] init];
    // TableView
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLCrashCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kCrashCellID];
    
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
    
    // ToolBar
    self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = LLCONFIG_TEXT_COLOR;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.deleteItem.enabled = NO;
    [self setToolbarItems:@[self.selectAllItem,spaceItem,self.deleteItem] animated:YES];
    
    self.navigationController.toolbar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    
    [self _loadData];
}

- (void)_loadData {
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Loading"];
    [[LLStorageManager sharedManager] getModels:[LLCrashModel class] launchDate:nil complete:^(NSArray<LLStorageModel *> *result) {
        [LLTool hideLoadingMessage];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
    }];
}

- (void)_showDeleteAlertWithIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count) {
        [self showAlertControllerWithMessage:@"Sure to remove items ?" handler:^(NSInteger action) {
            if (action == 1) {
                [self _deleteFilesWithIndexPaths:indexPaths];
            }
        }];
    }
}

- (void)_deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    __block NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:self.dataArray[indexPath.row]];
    }
    
    __weak typeof(self) weakSelf = self;
    [LLTool loadingMessage:@"Deleting"];
    [[LLStorageManager sharedManager] removeModels:models complete:^(BOOL result) {
        [LLTool hideLoadingMessage];
        if (result) {
            [weakSelf.dataArray removeObjectsInArray:models];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [weakSelf showAlertControllerWithMessage:@"Remove crash model fail" handler:^(NSInteger action) {
                if (action == 1) {
                    [weakSelf _loadData];
                }
            }];
        }
    }];
}

@end
