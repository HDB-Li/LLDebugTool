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

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLDebugConfigHelper.h"
#import "LLDetailTitleCellModel.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLSettingManager.h"
#import "LLThemeManager.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSliderCell.h"
#import "LLTitleSliderCellModel.h"
#import "LLTitleSwitchCell.h"

#import "UIViewController+LL_Utils.h"

@interface LLSettingViewController ()

@end

@implementation LLSettingViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"function.setting");
    [self loadData];
}

#pragma mark - Primary
- (void)loadData {
    [self.dataArray removeAllObjects];
    [self loadShortCutData];
    [self loadColorStyleData];
    [self loadEntryWindowStyleData];
    [self loadLogData];
    [self loadHierarchyData];
    [self loadMagnifierData];
    [self.tableView reloadData];
}

- (void)loadShortCutData {
    // Short cut.
    LLTitleCellModel *model = [self getDoubleClickComponentModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.short.cut") items:@[model]];
    [self.dataArray addObject:category];
}

- (void)loadColorStyleData {
    // Color style.
    LLTitleCellModel *model = [self getColorStyleModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.color") items:@[model]];
    [self.dataArray addObject:category];
}

- (void)loadEntryWindowStyleData {
    // EntryWindowStyle
    LLTitleCellModel *model1 = [self getEntryWindowStyleModel];
    LLTitleCellModel *model2 = [self getShrinkToEdgeWhenInactiveModel];
    LLTitleCellModel *model3 = [self getShakeToHideModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.entry.window") items:@[model1, model2, model3]];
    [self.dataArray addObject:category];
}

- (void)loadLogData {
#ifdef LLDEBUGTOOL_LOG
    // Log
    LLTitleCellModel *model = [self getLogStyleModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.log") items:@[model]];
    [self.dataArray addObject:category];
#endif
}

- (void)loadHierarchyData {
#ifdef LLDEBUGTOOL_HIERARCHY
    // Hierarchy
    LLTitleCellModel *model = [self getHierarchyIgnorePrivateClassModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.hierarchy") items:@[model]];
    [self.dataArray addObject:category];
#endif
}

- (void)loadMagnifierData {
#ifdef LLDEBUGTOOL_MAGNIFIER
    // Magnifier
    LLTitleCellModel *model1 = [self getMagnifierZoomLevelModel];
    LLTitleCellModel *model2 = [self getMagnifierSizeModel];
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"setting.magnifier") items:@[model1, model2]];
    [self.dataArray addObject:category];
#endif
}

- (LLDetailTitleCellModel *)getDoubleClickComponentModel {
    __weak typeof(self) weakSelf = self;
    LLDetailTitleCellModel *model = [LLDetailTitleCellModel modelWithTitle:LLLocalizedString(@"setting.double.click") detailTitle:[LLDebugConfigHelper doubleClickComponentDescription]];
    model.block = ^{
        [weakSelf showDoubleClickAlert];
    };
    return model;
}

- (void)showDoubleClickAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (NSInteger i = LLDebugToolActionSetting; i < LLDebugToolActionResolution + 1; i++) {
        NSString *action = [LLDebugConfigHelper componentDescription:i];
        if (action) {
            [actions addObject:action];
            [indexs addObject:@(i)];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"setting.double.click")
                              actions:actions
                        currentAction:[LLDebugConfigHelper doubleClickComponentDescription]
                           completion:^(NSInteger index) {
                               [weakSelf setNewDoubleClick:[indexs[index] unsignedIntegerValue]];
                           }];
}

- (void)setNewDoubleClick:(LLDebugToolAction)action {
    [LLDebugConfig shared].doubleClickAction = action;
    [LLSettingManager shared].doubleClickAction = @(action);
    [self loadData];
}

- (LLDetailTitleCellModel *)getColorStyleModel {
    __weak typeof(self) weakSelf = self;
    LLDetailTitleCellModel *model = [LLDetailTitleCellModel modelWithTitle:LLLocalizedString(@"style") detailTitle:[LLDebugConfigHelper colorStyleDetailDescription]];
    model.block = ^{
        [weakSelf showColorStyleAlert];
    };
    return model;
}

- (void)showColorStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (LLDebugConfigColorStyle i = LLDebugConfigColorStyleHack; i < LLDebugConfigColorStyleCustom; i++) {
        NSString *action = [LLDebugConfigHelper colorStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style")
                              actions:actions
                        currentAction:[LLDebugConfigHelper colorStyleDescription]
                           completion:^(NSInteger index) {
                               [weakSelf setNewColorStyle:index];
                           }];
}

- (void)setNewColorStyle:(LLDebugConfigColorStyle)style {
    if (style == [LLDebugConfig shared].colorStyle) {
        return;
    }
    if (style != LLDebugConfigColorStyleCustom) {
        [LLDebugConfig shared].colorStyle = style;
        [LLSettingManager shared].colorStyle = @(style);
        [self loadData];
    }
}

- (LLDetailTitleCellModel *)getEntryWindowStyleModel {
    __weak typeof(self) weakSelf = self;
    LLDetailTitleCellModel *model = [LLDetailTitleCellModel modelWithTitle:LLLocalizedString(@"style") detailTitle:[LLDebugConfigHelper entryWindowStyleDescription]];
    model.block = ^{
        [weakSelf showEntryWindowStyleAlert];
    };
    return model;
}

- (void)showEntryWindowStyleAlert {
    NSInteger count = 6;
    if (@available(iOS 13.0, *)) {
        count = 4;
    }
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {
        NSString *action = [LLDebugConfigHelper entryWindowStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style")
                              actions:actions
                        currentAction:[LLDebugConfigHelper entryWindowStyleDescription]
                           completion:^(NSInteger index) {
                               [weakSelf setNewEntryWindowStyle:index];
                           }];
}

- (void)setNewEntryWindowStyle:(LLDebugConfigEntryWindowStyle)style {
    if (style == [LLDebugConfig shared].entryWindowStyle) {
        return;
    }

    [LLDebugConfig shared].entryWindowStyle = style;
    [LLSettingManager shared].entryWindowStyle = @(style);
    [self loadData];
}

- (LLTitleCellModel *)getShrinkToEdgeWhenInactiveModel {
    LLTitleSwitchCellModel *model = [LLTitleSwitchCellModel modelWithTitle:LLLocalizedString(@"setting.shrink") isOn:[LLDebugConfig shared].isShrinkToEdgeWhenInactive];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id obj) {
        [weakSelf setNewShrinkToEdgeWhenInactive:[obj boolValue]];
    };
    return model;
}

- (void)setNewShrinkToEdgeWhenInactive:(BOOL)isShrinkToEdgeWhenInactive {
    [LLDebugConfig shared].shrinkToEdgeWhenInactive = isShrinkToEdgeWhenInactive;
    [LLSettingManager shared].shrinkToEdgeWhenInactive = @(isShrinkToEdgeWhenInactive);
}

- (LLTitleCellModel *)getShakeToHideModel {
    __weak typeof(self) weakSelf = self;
    LLTitleSwitchCellModel *model = [LLTitleSwitchCellModel modelWithTitle:LLLocalizedString(@"setting.shake") isOn:[LLDebugConfig shared].isShakeToHide];
    model.changePropertyBlock = ^(id obj) {
        [weakSelf setNewShakeToHide:[obj boolValue]];
    };
    return model;
}

- (void)setNewShakeToHide:(BOOL)isShakeToHide {
    [LLDebugConfig shared].shakeToHide = isShakeToHide;
    [LLSettingManager shared].shakeToHide = @(isShakeToHide);
}

#ifdef LLDEBUGTOOL_LOG
- (LLDetailTitleCellModel *)getLogStyleModel {
    LLDetailTitleCellModel *model = [LLDetailTitleCellModel modelWithTitle:LLLocalizedString(@"style") detailTitle:[LLDebugConfigHelper logStyleDescription]];
    __weak typeof(self) weakSelf = self;
    model.block = ^{
        [weakSelf showLogStyleAlert];
    };
    return model;
}

- (void)showLogStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        NSString *action = [LLDebugConfigHelper logStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style")
                              actions:actions
                        currentAction:[LLDebugConfigHelper logStyleDescription]
                           completion:^(NSInteger index) {
                               [weakSelf setNewLogStyle:index];
                           }];
}

- (void)setNewLogStyle:(LLDebugConfigLogStyle)style {
    if (style == [LLDebugConfig shared].logStyle) {
        return;
    }

    [LLDebugConfig shared].logStyle = style;
    [LLSettingManager shared].logStyle = @(style);
    [self loadData];
}
#endif
#ifdef LLDEBUGTOOL_HIERARCHY
- (LLTitleCellModel *)getHierarchyIgnorePrivateClassModel {
    LLTitleSwitchCellModel *model = [LLTitleSwitchCellModel modelWithTitle:LLLocalizedString(@"setting.ignore.private") isOn:[LLDebugConfig shared].hierarchyIgnorePrivateClass];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id obj) {
        [weakSelf setNewHierarchyIgnorePrivateClass:[obj boolValue]];
    };
    return model;
}

- (void)setNewHierarchyIgnorePrivateClass:(BOOL)hierarchyIgnorePrivateClass {
    [LLDebugConfig shared].hierarchyIgnorePrivateClass = hierarchyIgnorePrivateClass;
    [LLSettingManager shared].hierarchyIgnorePrivateClass = @(hierarchyIgnorePrivateClass);
}
#endif
#ifdef LLDEBUGTOOL_MAGNIFIER
- (LLTitleSliderCellModel *)getMagnifierZoomLevelModel {
    LLTitleSliderCellModel *model = [LLTitleSliderCellModel modelWithTitle:LLLocalizedString(@"setting.zoom.level") value:[LLDebugConfig shared].magnifierZoomLevel minValue:kLLMagnifierWindowMinZoomLevel maxValue:kLLMagnifierWindowMaxZoomLevel];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id obj) {
        [weakSelf setNewMagnifierZoomLevel:[obj integerValue]];
    };
    return model;
}

- (void)setNewMagnifierZoomLevel:(NSInteger)zoomLevel {
    [LLDebugConfig shared].magnifierZoomLevel = zoomLevel;
    [LLSettingManager shared].magnifierZoomLevel = @(zoomLevel);
    [self loadData];
}

- (LLTitleSliderCellModel *)getMagnifierSizeModel {
    LLTitleSliderCellModel *model = [LLTitleSliderCellModel modelWithTitle:LLLocalizedString(@"setting.zoom.size") value:[LLDebugConfig shared].magnifierSize minValue:kLLMagnifierWindowMinSize maxValue:kLLMagnifierWindowMaxSize];
    __weak typeof(self) weakSelf = self;
    model.changePropertyBlock = ^(id obj) {
        [weakSelf setNewMagnifierSize:[obj integerValue]];
    };
    return model;
}

- (void)setNewMagnifierSize:(NSInteger)size {
    [LLDebugConfig shared].magnifierSize = size;
    [LLSettingManager shared].magnifierSize = @(size);
    [self loadData];
}
#endif

@end
