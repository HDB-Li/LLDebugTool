//
//  LLAppInfoViewController.m
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

#import "LLAppInfoViewController.h"

#import "LLTitleCellCategoryModel.h"
#import "LLBaseTableViewCell.h"
#import "LLInternalMacros.h"
#import "LLTitleCellModel.h"
#import "LLAppInfoHelper.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

@interface LLAppInfoViewController ()

@end

@implementation LLAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[LLAppInfoHelper shared] deviceName] ?: LLLocalizedString(@"function.app.info");
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerLLAppInfoHelperNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterLLAppInfoHelperNotification];
}

#pragma mark - LLAppInfoHelperNotification
- (void)registerLLAppInfoHelperNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:) name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)unregisterLLAppInfoHelperNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:(NSNotification *)notification {
    [self updateDynamicData];
}

#pragma mark - Primary
- (void)loadData {
    [self.dataArray removeAllObjects];
    
    [self.dataArray addObject:[self dynamicData]];
    [self.dataArray addObject:[self applicationData]];
    [self.dataArray addObject:[self deviceData]];

    [self.tableView reloadData];
}

- (void)updateDynamicData {
    if (self.dataArray.count > 1) {
        [self.dataArray replaceObjectAtIndex:0 withObject:[self dynamicData]];
        [self.tableView reloadData];
    }
}

- (LLTitleCellCategoryModel *)dynamicData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in [[LLAppInfoHelper shared] dynamicInfos]) {
        LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:dic.allKeys.firstObject detailTitle:dic.allValues.firstObject];
        [settings addObject:model];
    }
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"app.info.dynamic") items:settings];
}

- (LLTitleCellCategoryModel *)applicationData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in [[LLAppInfoHelper shared] applicationInfos]) {
        LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:dic.allKeys.firstObject detailTitle:dic.allValues.firstObject];
        [settings addObject:model];
    }
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"app.info.application") items:settings];
}

- (LLTitleCellCategoryModel *)deviceData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in [[LLAppInfoHelper shared] deviceInfos]) {
        LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:dic.allKeys.firstObject detailTitle:dic.allValues.firstObject];
        [settings addObject:model];
    }
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"app.info.device") items:settings];
}

@end
