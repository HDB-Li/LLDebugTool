//
//  LLSandboxVC.m
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

#import "LLSandboxVC.h"
#import "LLSandboxCell.h"
#import "LLSandboxHelper.h"
#import "YWFilePreviewController.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"
#import "LLUITableViewLongPressGestureRecognizerDelegate.h"

static NSString *const kSandboxCellID = @"LLSandboxCell";

@interface LLSandboxVC () <LLUITableViewLongPressGestureRecognizerDelegate>

@property (nonatomic , strong) UIBarButtonItem *selectAllItem;

@property (nonatomic , strong) UIBarButtonItem *shareItem;

@property (nonatomic , strong) UIBarButtonItem *deleteItem;

@end

@implementation LLSandboxVC

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
    if (!btn.selected) {
        if (self.sandboxModel.subModels.count) {
            btn.selected = !btn.selected;
            [self.tableView setEditing:YES animated:YES];
            self.shareItem.enabled = NO;
            self.deleteItem.enabled = NO;
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
    } else {
        btn.selected = !btn.selected;
        self.selectAllItem.title = @"Select All";
        [self.tableView setEditing:NO animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)selectAllItemClick:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"Select All"]) {
        item.title = @"Cancel All";
        self.shareItem.enabled = YES;
        self.deleteItem.enabled = YES;
        for (int i = 0; i < self.sandboxModel.subModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        item.title = @"Select All";
        self.shareItem.enabled = NO;
        self.deleteItem.enabled = NO;
        for (int i = 0; i < self.sandboxModel.subModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (void)shareItemClick:(UIBarButtonItem *)item {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    if (indexPaths.count) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:indexPaths.count];
        for (NSIndexPath *indexPath in indexPaths) {
            LLSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
            [array addObject:[NSURL fileURLWithPath:model.filePath]];
        }
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
        __weak typeof(self) weakSelf = self;
        vc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            [weakSelf rightItemClick];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)deleteItemClick:(UIBarButtonItem *)item {
    NSArray *indexPaths = self.tableView.indexPathsForSelectedRows;
    [self showDeleteAlertWithIndexPaths:indexPaths];
    [self rightItemClick];
}

#pragma mark - Primary
/**
 * initial method
 */
- (void)initial {
    // Data source
    if (_sandboxModel == nil) {
        _sandboxModel = [[LLSandboxHelper sharedHelper] getCurrentSandboxStructure];
    }
    if (self.sandboxModel.isHomeDirectory) {
        self.navigationItem.title = @"Sandbox";
    } else {
        self.navigationItem.title = self.sandboxModel.name;
    }
    // TableView
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLSandboxCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kSandboxCellID];
    
    
    // Navigation bar item
    if (self.sandboxModel.subModels.count) {
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
    }
    
    // ToolBar
    self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = LLCONFIG_TEXT_COLOR;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.shareItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick:)];
    self.shareItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.shareItem.enabled = NO;
    
    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.deleteItem.enabled = NO;
    [self setToolbarItems:@[self.selectAllItem,spaceItem,self.shareItem,self.deleteItem] animated:YES];
    
    self.navigationController.toolbar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
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
    if (indexPaths.count) {
        for (NSIndexPath *indexPath in indexPaths) {
            [self deleteFile:indexPath];
        }
    }
}

- (BOOL)deleteFile:(NSIndexPath *)indexPath {
    LLSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
    NSError *error;
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:model.filePath error:&error];
    if (ret) {
        [self.sandboxModel.subModels removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self showAlertControllerWithMessage:[NSString stringWithFormat:@"Delete file fail\nFilePath:%@\nError:%@",model.filePath,error.localizedDescription] handler:nil];
    }
    return ret;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sandboxModel.subModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:kSandboxCellID forIndexPath:indexPath];
    if (TARGET_IPHONE_SIMULATOR) {
        cell.delegate = self;
    }
    [cell confirmWithModel:self.sandboxModel.subModels[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing == NO) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        LLSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
        if (model.isDirectory) {
            if (model.subModels.count) {
                LLSandboxVC *vc = [[LLSandboxVC alloc] initWithStyle:UITableViewStyleGrouped];
                vc.sandboxModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self toastMessage:@"Empty folder"];
            }
        } else {
            if (model.canPreview) {
                YWFilePreviewController *vc = [[YWFilePreviewController alloc] init];
                NSMutableArray *paths = [[NSMutableArray alloc] init];
                NSInteger index = 0;
                for (LLSandboxModel *mod in self.sandboxModel.subModels) {
                    if (mod == model) {
                        [paths addObject:mod.filePath];
                        index = [paths indexOfObject:mod.filePath];
                    } else if (mod.canPreview) {
                        [paths addObject:mod.filePath];
                    }
                }
                [vc previewFileWithPaths:paths on:self jump:YWJumpPushAnimat index:index];
            } else {
                UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:model.filePath]] applicationActivities:nil];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    } else {
        if (self.tableView.indexPathsForSelectedRows.count == self.sandboxModel.subModels.count) {
            self.selectAllItem.title = @"Cancel All";
        } else {
            self.selectAllItem.title = @"Select All";
        }
        self.shareItem.enabled = YES;
        self.deleteItem.enabled = YES;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectAllItem.title isEqualToString:@"Select All"] == NO) {
        self.selectAllItem.title = @"Select All";
    }
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        self.shareItem.enabled = NO;
        self.deleteItem.enabled = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showDeleteAlertWithIndexPaths:@[indexPath]];
    } 
}

#pragma mark - LLUITableViewLongPressGestureRecognizerDelegate
- (void)LL_tableViewCellDidLongPress:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLSandboxModel *model = self.sandboxModel.subModels[indexPath.row];
    [UIPasteboard generalPasteboard].string = model.filePath;
    [self toastMessage:[NSString stringWithFormat:@"Copy File Path Success\n%@",model.filePath]];
}

@end
