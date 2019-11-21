//
//  LLSettingViewController.m
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

#import "LLSettingViewController.h"

#import "LLDetailTitleSelectorCell.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCell.h"
#import "LLImageNameConfig.h"
#import "LLTitleSliderCell.h"
#import "LLInternalMacros.h"
#import "LLSettingManager.h"
#import "LLConfigHelper.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"

@interface LLSettingViewController () <UITableViewDataSource>

@end

@implementation LLSettingViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Setting";
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpUI];
}

#pragma mark - Primary
- (void)loadData {
    [self.dataArray removeAllObjects];
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    // Short Cut
    [settings addObject:[self getDoubleClickComponentModel]];
    LLTitleCellCategoryModel *category0 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Short Cut" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category0];
    
    // ColorStyle
    [settings addObject:[self getColorStyleModel]];
    [settings addObject:[self getStatusBarStyleModel]];
    
    LLTitleCellCategoryModel *category1 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Color" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category1];
    
    // EntryWindowStyle
    [settings addObject:[self getEntryWindowStyleModel]];
    [settings addObject:[self getShrinkToEdgeWhenInactiveModel]];
    [settings addObject:[self getShakeToHideModel]];
    LLTitleCellCategoryModel *category2 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Entry Window" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category2];
    
#ifdef LLDEBUGTOOL_LOG
    // Log
    [settings addObject:[self getLogStyleModel]];
    LLTitleCellCategoryModel *category3 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Log" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category3];
#endif
#ifdef LLDEBUGTOOL_HIERARCHY
    // Hierarchy
    [settings addObject:[self getHierarchyIgnorePrivateClassModel]];
    LLTitleCellCategoryModel *category5 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Hierarchy" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category5];
#endif
#ifdef LLDEBUGTOOL_MAGNIFIER
    // Magnifier
    [settings addObject:[self getMagnifierZoomLevelModel]];
    [settings addObject:[self getMagnifierSizeModel]];
    LLTitleCellCategoryModel *category4 = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Magnifier" items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category4];
#endif
    [self.tableView reloadData];
}

- (void)setUpUI {
    self.tableView.frame = self.view.bounds;
}

- (LLTitleCellModel *)getDoubleClickComponentModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Double Click" detailTitle:[LLConfigHelper doubleClickComponentDescription]];
    model.block = ^{
        [weakSelf showDoubleClickAlert];
    };
    return model;
}

- (void)showDoubleClickAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (NSInteger i = LLDebugToolActionSetting; i < LLDebugToolActionWidgetBorder + 1; i++) {
        NSString *action = [LLConfigHelper componentDescription:i];
        if (action) {
            [actions addObject:action];
            [indexs addObject:@(i)];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:@"Double Click Event" actions:actions currentAction:[LLConfigHelper doubleClickComponentDescription] completion:^(NSInteger index) {
        [weakSelf setNewDoubleClick:[indexs[index] unsignedIntegerValue]];
    }];
}

- (void)setNewDoubleClick:(LLDebugToolAction)action {
    [LLConfig shared].doubleClickAction = action;
    [LLSettingManager shared].doubleClickAction = @(action);
    [self loadData];
}

- (LLTitleCellModel *)getShakeToHideModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Shake To Hide" flag:[LLConfig shared].isShakeToHide];
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewShakeToHide:[obj boolValue]];
    };
    return model;
}

- (void)setNewShakeToHide:(BOOL)isShakeToHide {
    [LLConfig shared].shakeToHide = isShakeToHide;
    [LLSettingManager shared].shakeToHide = @(isShakeToHide);
}

- (LLTitleCellModel *)getColorStyleModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLConfigHelper colorStyleDetailDescription]];
    model.block = ^{
        [weakSelf showColorStyleAlert];
    };
    return model;
}

- (void)showColorStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i++) {
        NSString *action = [LLConfigHelper colorStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:@"Color Style" actions:actions currentAction:[LLConfigHelper colorStyleDescription] completion:^(NSInteger index) {
        [weakSelf setNewColorStyle:index];
    }];
}

- (void)setNewColorStyle:(LLConfigColorStyle)style {
    if (style == [LLConfig shared].colorStyle) {
        return;
    }
    if (style == LLConfigColorStyleCustom) {
        
    } else {
        [LLConfig shared].colorStyle = style;
        [LLSettingManager shared].colorStyle = @(style);
        [self loadData];
    }
}

- (LLTitleCellModel *)getStatusBarStyleModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Status Bar" detailTitle:[LLConfigHelper statusBarStyleDescription]];
    __weak typeof(self) weakSelf = self;
    model.block = ^{
        [weakSelf showStatusBarStyleAlert];
    };
    return model;
}

- (void)showStatusBarStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
#ifdef __IPHONE_13_0
    NSInteger count = 4;
#else
    NSInteger count = 3;
#endif
    for (NSInteger i = 0; i < count; i++) {
        NSString *action = [LLConfigHelper statusBarStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:@"Status Bar Style" actions:actions currentAction:[LLConfigHelper statusBarStyleDescription] completion:^(NSInteger index) {
        [weakSelf setNewStatusBarStyle:index];
    }];
}

- (void)setNewStatusBarStyle:(UIStatusBarStyle)style {
    if (style == [LLThemeManager shared].statusBarStyle) {
        return;
    }
    
    [[LLConfig shared] configStatusBarStyle:style];
    [LLSettingManager shared].statusBarStyle = @(style);
    [self loadData];
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
#pragma clang diagnostic pop
}

- (LLTitleCellModel *)getEntryWindowStyleModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLConfigHelper entryWindowStyleDescription]];
    model.block = ^{
        [weakSelf showEntryWindowStyleAlert];
    };
    return model;
}

- (void)showEntryWindowStyleAlert {
#ifdef __IPHONE_13_0
    NSInteger count = 4;
#else
    NSInteger count = 6;
#endif
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {
        NSString *action = [LLConfigHelper entryWindowStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:@"Entry Window Style" actions:actions currentAction:[LLConfigHelper entryWindowStyleDescription] completion:^(NSInteger index) {
        [weakSelf setNewEntryWindowStyle:index];
    }];
}

- (void)setNewEntryWindowStyle:(LLConfigEntryWindowStyle)style {
    if (style == [LLConfig shared].entryWindowStyle) {
        return;
    }
    
    [LLConfig shared].entryWindowStyle = style;
    [LLSettingManager shared].entryWindowStyle = @(style);
    [self loadData];
}

- (LLTitleCellModel *)getShrinkToEdgeWhenInactiveModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Shrink To Edge" flag:[LLConfig shared].isShrinkToEdgeWhenInactive];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewShrinkToEdgeWhenInactive:[obj boolValue]];
    };
    return model;
}

- (void)setNewShrinkToEdgeWhenInactive:(BOOL)isShrinkToEdgeWhenInactive {
    [LLConfig shared].shrinkToEdgeWhenInactive = isShrinkToEdgeWhenInactive;
    [LLSettingManager shared].shrinkToEdgeWhenInactive = @(isShrinkToEdgeWhenInactive);
}

#ifdef LLDEBUGTOOL_LOG
- (LLTitleCellModel *)getLogStyleModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLConfigHelper logStyleDescription]];
    __weak typeof(self) weakSelf = self;
    model.block = ^{
        [weakSelf showLogStyleAlert];
    };
    return model;
}

- (void)showLogStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        NSString *action = [LLConfigHelper logStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:@"Log Style" actions:actions currentAction:[LLConfigHelper logStyleDescription] completion:^(NSInteger index) {
        [weakSelf setNewLogStyle:index];
    }];
}

- (void)setNewLogStyle:(LLConfigLogStyle)style {
    if (style == [LLConfig shared].logStyle) {
        return;
    }
    
    [LLConfig shared].logStyle = style;
    [LLSettingManager shared].logStyle = @(style);
    [self loadData];
}
#endif

#ifdef LLDEBUGTOOL_MAGNIFIER
- (LLTitleCellModel *)getMagnifierZoomLevelModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Zoom Level" value:[LLConfig shared].magnifierZoomLevel minValue:kLLMagnifierWindowMinZoomLevel maxValue:kLLMagnifierWindowMaxZoomLevel];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewMagnifierZoomLevel:[obj integerValue]];
    };
    return model;
}

- (void)setNewMagnifierZoomLevel:(NSInteger)zoomLevel {
    [LLConfig shared].magnifierZoomLevel = zoomLevel;
    [LLSettingManager shared].magnifierZoomLevel = @(zoomLevel);
    [self loadData];
}

- (LLTitleCellModel *)getMagnifierSizeModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Size" value:[LLConfig shared].magnifierSize minValue:kLLMagnifierWindowMinSize maxValue:kLLMagnifierWindowMaxSize];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewMagnifierSize:[obj integerValue]];
    };
    return model;
}

- (void)setNewMagnifierSize:(NSInteger)size {
    [LLConfig shared].magnifierSize = size;
    [LLSettingManager shared].magnifierSize = @(size);
    [self loadData];
}
#endif
#ifdef LLDEBUGTOOL_HIERARCHY
- (LLTitleCellModel *)getHierarchyIgnorePrivateClassModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:@"Ignore Private" flag:[LLConfig shared].hierarchyIgnorePrivateClass];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewHierarchyIgnorePrivateClass:[obj boolValue]];
    };
    return model;
}

- (void)setNewHierarchyIgnorePrivateClass:(BOOL)hierarchyIgnorePrivateClass {
    [LLConfig shared].hierarchyIgnorePrivateClass = hierarchyIgnorePrivateClass;
    [LLSettingManager shared].hierarchyIgnorePrivateClass = @(hierarchyIgnorePrivateClass);
}
#endif

@end
