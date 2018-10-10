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

@end

@implementation LLCrashVC

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
    [self initial];
}

- (void)deleteItemClick:(UIBarButtonItem *)item {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    [self _showDeleteAlertWithIndexPaths:indexPaths];
    [self rightItemClick:self.navigationItem.rightBarButtonItem.customView];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (!self.tableView.isEditing) {
        LLCrashContentVC *vc = [[LLCrashContentVC alloc] init];
        vc.model = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
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

    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"LLCrashCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kCrashCellID];
    
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
