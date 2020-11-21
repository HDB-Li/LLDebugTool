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

#import "LLAppInfoHelper.h"
#import "LLBaseTableViewCell.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLFactory.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleCellModel.h"

@interface LLAppInfoViewController ()

@end

@implementation LLAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LLDT_CC_AppInfo deviceName] ?: LLLocalizedString(@"function.app.info");
    if ([LLDebugConfig shared].entryWindowStyle != LLDebugConfigEntryWindowStyleAppInfo) {
        [self createNavigationItemWithTitle:LLLocalizedString(@"app.info.monitor") imageName:nil isLeft:NO];
    }
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterNotification];
}

- (void)rightItemClick:(UIButton *)sender {
    [LLDebugConfig shared].entryWindowStyle = LLDebugConfigEntryWindowStyleAppInfo;
    LLDT_CC_Setting.entryWindowStyle = @(LLDebugConfigEntryWindowStyleAppInfo);
    [self componentDidFinish];
}

#pragma mark - LLDebugToolUpdateAppInfoNotification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolUpdateAppInfoNotification:) name:LLDebugToolUpdateAppInfoNotification object:nil];
}

- (void)unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLDebugToolUpdateAppInfoNotification object:nil];
}

- (void)didReceiveDebugToolUpdateAppInfoNotification:(NSNotification *)notification {
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

    // CPU
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"CPU" detailTitle:LLDT_CC_AppInfo.cpuUsage]];

    // Memory
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Memory" detailTitle:LLDT_CC_AppInfo.memoryUsage]];

    // FPS
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"FPS" detailTitle:LLDT_CC_AppInfo.fps]];

    // Data traffic
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Data Traffic" detailTitle:LLDT_CC_AppInfo.dataTraffic]];

    return [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"app.info.dynamic") items:settings];
}

- (LLTitleCellCategoryModel *)applicationData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    // Name
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Name" detailTitle:LLDT_CC_AppInfo.appName]];

    // Identifier
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Identifier" detailTitle:LLDT_CC_AppInfo.bundleIdentifier]];

    // Version
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Version" detailTitle:LLDT_CC_AppInfo.appVersion]];

    // Start time
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Start Time" detailTitle:LLDT_CC_AppInfo.appStartTimeConsuming]];

    return [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"app.info.application") items:settings];
}

- (LLTitleCellCategoryModel *)deviceData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    // Name
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Name" detailTitle:LLDT_CC_AppInfo.deviceName]];

    // Version
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Version" detailTitle:LLDT_CC_AppInfo.systemVersion]];

    // Resolution
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Resolution" detailTitle:LLDT_CC_AppInfo.screenResolution]];

    // Language
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Language" detailTitle:LLDT_CC_AppInfo.languageCode]];

    // Battery
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Battery" detailTitle:LLDT_CC_AppInfo.batteryLevel]];

    // CPU
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"CPU" detailTitle:LLDT_CC_AppInfo.cpuType]];

    // SSID
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"SSID" detailTitle:LLDT_CC_AppInfo.ssid]];

    // Disk
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Disk" detailTitle:LLDT_CC_AppInfo.disk]];

    // Network
    [settings addObject:[LLDetailTitleCellModel modelWithTitle:@"Network" detailTitle:LLDT_CC_AppInfo.networkState]];

    return [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"app.info.device") items:settings];
}

@end
