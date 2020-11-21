//
//  LLSandboxViewController.m
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

#import "LLSandboxViewController.h"

#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLPreviewController.h"
#import "LLSandboxCell.h"
#import "LLSandboxHelper.h"
#import "LLSandboxHtmlPreviewController.h"
#import "LLSandboxImagePreviewController.h"
#import "LLSandboxModel.h"
#import "LLSandboxTextPreviewController.h"
#import "LLSandboxVideoPreviewController.h"
#import "LLToastUtils.h"
#import "LLTool.h"
#import "LLUITableViewLongPressGestureRecognizerDelegate.h"

#import "UIViewController+LL_Utils.h"

static NSString *const kSandboxCellID = @"LLSandboxCell";

@interface LLSandboxViewController () <LLUITableViewLongPressGestureRecognizerDelegate>

@end

@implementation LLSandboxViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSearchEnable = YES;
        self.isSelectEnable = YES;
        self.isShareEnable = YES;
        self.isDeleteEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Data source
    if (_sandboxModel == nil) {
        _sandboxModel = [LLDT_CC_Sandbox getCurrentSandboxStructure];
    }
    if (self.sandboxModel.isHomeDirectory) {
        self.title = LLLocalizedString(@"function.sandbox");
    } else {
        self.title = self.sandboxModel.name;
    }
    // TableView
    [self.tableView registerClass:[LLSandboxCell class] forCellReuseIdentifier:kSandboxCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)shareFilesWithIndexPaths:(NSArray *)indexPaths {
    [super shareFilesWithIndexPaths:indexPaths];
    NSMutableArray *paths = [[NSMutableArray alloc] initWithCapacity:indexPaths.count];
    NSMutableArray<LLSandboxModel *> *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        LLSandboxModel *model = self.datas[indexPath.row];
        [models addObject:model];
        if (model.filePath) {
            [paths addObject:model.filePath];
        }
    }
    if ([self needCreateZipArchiveWithFilePaths:models]) {
        [[LLToastUtils shared] loadingMessage:LLLocalizedString(@"sandbox.archiving")];
        [LLTool createDirectoryAtPath:LLDT_CC_Sandbox.archiveFolderPath];
        NSString *path = [LLDT_CC_Sandbox.archiveFolderPath stringByAppendingPathComponent:[self recommendNameWithFilePaths:paths]];
        [LLTool removePath:path];
        if ([LLDT_CC_Sandbox createZipFileAtPath:path withFilesAtPaths:paths.copy]) {
            [[LLToastUtils shared] hide];
            [self showActivityViewControllerWithPaths:@[path]];
        } else {
            [[LLToastUtils shared] hide];
            [LLTool log:@"Create zip failed"];
            [self showActivityViewControllerWithPaths:paths.copy];
        }
    } else {
        [self showActivityViewControllerWithPaths:paths.copy];
    }
}

#pragma mark - Primary
- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    [super deleteFilesWithIndexPaths:indexPaths];
    NSMutableArray *finishedModels = [[NSMutableArray alloc] init];
    NSMutableArray *finishedIndexPaths = [[NSMutableArray alloc] init];

    for (NSIndexPath *indexPath in indexPaths) {
        LLSandboxModel *model = self.datas[indexPath.row];
        BOOL ret = [self deleteFile:model];
        if (ret) {
            [finishedModels addObject:model];
            [finishedIndexPaths addObject:indexPath];
        }
    }
    [self.oriDataArray removeObjectsInArray:finishedModels];
    [self textFieldDidChange:self.searchTextField.text];
}

- (NSMutableArray *)oriDataArray {
    return self.sandboxModel.subModels;
}

- (BOOL)deleteFile:(LLSandboxModel *)model {
    if (![LLTool removePath:model.filePath]) {
        [self LL_showAlertControllerWithMessage:LLLocalizedString(@"remove.fail") handler:nil];
        return NO;
    }
    return YES;
}

- (BOOL)needCreateZipArchiveWithFilePaths:(NSArray<LLSandboxModel *> *)paths {
    if (!LLDT_CC_Sandbox.enableZipArchive) {
        return NO;
    }

    if (paths.count >= 2) {
        return YES;
    }

    NSString *path = paths.firstObject.filePath;
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        return YES;
    }

    // Big than 100M.
    if (paths.firstObject.fileSize > 100 * 1024 * 1024) {
        return YES;
    }

    return NO;
}

- (NSString *)recommendNameWithFilePaths:(NSArray<NSString *> *)paths {
    if (paths.count > 1) {
        return @"archive.zip";
    }

    NSString *lastPathComponent = paths.firstObject.lastPathComponent;
    if (![lastPathComponent length]) {
        lastPathComponent = @"temp";
    }
    return [NSString stringWithFormat:@"%@.zip", lastPathComponent];
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:kSandboxCellID forIndexPath:indexPath];
    if (TARGET_IPHONE_SIMULATOR) {
        cell.delegate = self;
    }
    [cell confirmWithModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (self.tableView.isEditing == NO) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        LLSandboxModel *model = self.datas[indexPath.row];
        [self selectSandboxModel:model];
    }
}

- (void)selectSandboxModel:(LLSandboxModel *)model {
    if (model.isDirectory) {
        [self openDirectory:model];
    } else {
        [self openFile:model];
    }
}

- (void)openDirectory:(LLSandboxModel *)model {
    if (model.subModels.count) {
        LLSandboxViewController *vc = [[LLSandboxViewController alloc] init];
        vc.sandboxModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"empty.folder")];
    }
}

- (void)openFile:(LLSandboxModel *)model {
    if (model.canOpenWithTextView) {
        [self openWithTextPreviewController:model];
    } else if (model.canOpenWithImageView) {
        [self openWithImagePreviewController:model];
    } else if (model.canOpenWithVideo) {
        [self openWithVideoPreviewController:model];
    } else {
        if (@available(iOS 13.0, *)) {
            if (model.canOpenWithWebView) {
                [self openWithHtmlPreviewController:model];
            } else if (model.canPreview) {
                [self openWithPreviewController:model];
            } else {
                [self showActivityViewController:model];
            }
        } else {
            if (model.canPreview) {
                [self openWithPreviewController:model];
            } else if (model.canOpenWithWebView) {
                [self openWithHtmlPreviewController:model];
            } else {
                [self showActivityViewController:model];
            }
        }
    }
}

- (void)openWithTextPreviewController:(LLSandboxModel *)model {
    LLSandboxTextPreviewController *vc = [[LLSandboxTextPreviewController alloc] init];
    vc.filePath = model.filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openWithImagePreviewController:(LLSandboxModel *)model {
    LLSandboxImagePreviewController *vc = [[LLSandboxImagePreviewController alloc] init];
    vc.filePath = model.filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openWithVideoPreviewController:(LLSandboxModel *)model {
    LLSandboxVideoPreviewController *vc = [[LLSandboxVideoPreviewController alloc] init];
    vc.filePath = model.filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openWithHtmlPreviewController:(LLSandboxModel *)model {
    LLSandboxHtmlPreviewController *vc = [[LLSandboxHtmlPreviewController alloc] init];
    vc.filePath = model.filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openWithPreviewController:(LLSandboxModel *)model {
    LLPreviewController *vc = [[LLPreviewController alloc] init];
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (LLSandboxModel *mod in self.datas) {
        if (mod == model) {
            [paths addObject:mod.filePath];
            index = [paths indexOfObject:mod.filePath];
        } else if (mod.canPreview) {
            [paths addObject:mod.filePath];
        }
    }
    vc.filePaths = paths;
    vc.currentPreviewItemIndex = index;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showActivityViewController:(LLSandboxModel *)model {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:model.filePath]] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showActivityViewControllerWithPaths:(NSArray<NSString *> *)paths {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:paths.count];
    for (NSString *path in paths) {
        NSURL *url = [NSURL fileURLWithPath:path];
        if (url) {
            [items addObject:url];
        }
    }
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    __weak typeof(self) weakSelf = self;
    vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [weakSelf rightItemClick:weakSelf.navigationItem.rightBarButtonItem.customView];
        if (activityError) {
            [[LLToastUtils shared] toastMessage:activityError.debugDescription];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
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
        for (LLSandboxModel *model in self.oriDataArray) {
            [self.searchDataArray addObjectsFromArray:[self modelsByFilter:text.lowercaseString model:model]];
        }
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)modelsByFilter:(NSString *)filter model:(LLSandboxModel *)model {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([model.name.lowercaseString containsString:filter]) {
        [array addObject:model];
    }
    for (LLSandboxModel *subModel in model.subModels) {
        [array addObjectsFromArray:[self modelsByFilter:filter model:subModel]];
    }
    return array;
}

#pragma mark - LLUITableViewLongPressGestureRecognizerDelegate
- (void)LL_tableViewCellDidLongPress:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLSandboxModel *model = self.datas[indexPath.row];
    [UIPasteboard generalPasteboard].string = model.filePath;
    [[LLToastUtils shared] toastMessage:[NSString stringWithFormat:LLLocalizedString(@"copy.path.suceess"), model.filePath]];
}

@end
