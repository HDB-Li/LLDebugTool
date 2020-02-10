//
//  LLCrashViewController.m
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

#import "LLCrashViewController.h"

#import "LLCrashDetailViewController.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLStorageManager.h"
#import "LLCrashHelper.h"
#import "LLToastUtils.h"
#import "LLCrashModel.h"
#import "LLCrashCell.h"
#import "LLConfig.h"

#import "UIViewController+LL_Utils.h"

static NSString *const kCrashCellID = @"CrashCellID";

@interface LLCrashViewController ()

@end

@implementation LLCrashViewController

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
    self.title = LLLocalizedString(@"function.crash");
    [self.tableView registerClass:[LLCrashCell class] forCellReuseIdentifier:kCrashCellID];
    
    [self loadData];
}

#pragma mark - Primary
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[LLToastUtils shared] loadingMessage:LLLocalizedString(@"loading")];
    [[LLStorageManager shared] getModels:[LLCrashModel class] launchDate:nil complete:^(NSArray<LLStorageModel *> *result) {
        [[LLToastUtils shared] hide];
        [weakSelf.oriDataArray removeAllObjects];
        [weakSelf.oriDataArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Rewrite
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
            [weakSelf.oriDataArray removeObjectsInArray:models];
            [weakSelf.searchDataArray removeObjectsInArray:models];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [weakSelf LL_showAlertControllerWithMessage:LLLocalizedString(@"remove.fail") handler:^(NSInteger action) {
                if (action == 1) {
                    [weakSelf loadData];
                }
            }];
        }
    }];
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCrashCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (!self.tableView.isEditing) {
        LLCrashDetailViewController *vc = [[LLCrashDetailViewController alloc] init];
        vc.model = self.datas[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(NSString *)text {
    [super textFieldDidChange:text];
    if (text.length == 0) {
        [self.searchDataArray removeAllObjects];
        [self.searchDataArray addObjectsFromArray:self.oriDataArray];
        [self.tableView reloadData];
    } else {
        [self.searchDataArray removeAllObjects];
        for (LLCrashModel *model in self.oriDataArray) {
            if ([model.name.lowercaseString containsString:text.lowercaseString] || [model.reason.lowercaseString containsString:text.lowercaseString]) {
                [self.searchDataArray addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

@end
