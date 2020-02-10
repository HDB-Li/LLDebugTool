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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    // Short Cut
    [settings addObject:[self getDoubleClickComponentModel]];
    LLTitleCellCategoryModel *category0 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.short.cut") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category0];
    
    // ColorStyle
    [settings addObject:[self getColorStyleModel]];
    
    LLTitleCellCategoryModel *category1 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.color") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category1];
    
    // EntryWindowStyle
    [settings addObject:[self getEntryWindowStyleModel]];
    [settings addObject:[self getShrinkToEdgeWhenInactiveModel]];
    [settings addObject:[self getShakeToHideModel]];
    LLTitleCellCategoryModel *category2 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.entry.window") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category2];
    
#ifdef LLDEBUGTOOL_LOG
    // Log
    [settings addObject:[self getLogStyleModel]];
    LLTitleCellCategoryModel *category3 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.log") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category3];
#endif
#ifdef LLDEBUGTOOL_HIERARCHY
    // Hierarchy
    [settings addObject:[self getHierarchyIgnorePrivateClassModel]];
    LLTitleCellCategoryModel *category5 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.hierarchy") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category5];
#endif
#ifdef LLDEBUGTOOL_MAGNIFIER
    // Magnifier
    [settings addObject:[self getMagnifierZoomLevelModel]];
    [settings addObject:[self getMagnifierSizeModel]];
    LLTitleCellCategoryModel *category4 = [[LLTitleCellCategoryModel alloc] initWithTitle:LLLocalizedString(@"setting.magnifier") items:settings];
    [settings removeAllObjects];
    [self.dataArray addObject:category4];
#endif
    [self.tableView reloadData];
}

- (LLTitleCellModel *)getDoubleClickComponentModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.double.click") detailTitle:[LLConfigHelper doubleClickComponentDescription]];
    model.block = ^{
        [weakSelf showDoubleClickAlert];
    };
    return model;
}

- (void)showDoubleClickAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (NSInteger i = LLDebugToolActionSetting; i < LLDebugToolActionShortCut + 1; i++) {
        NSString *action = [LLConfigHelper componentDescription:i];
        if (action) {
            [actions addObject:action];
            [indexs addObject:@(i)];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"setting.double.click") actions:actions currentAction:[LLConfigHelper doubleClickComponentDescription] completion:^(NSInteger index) {
        [weakSelf setNewDoubleClick:[indexs[index] unsignedIntegerValue]];
    }];
}

- (void)setNewDoubleClick:(LLDebugToolAction)action {
    [LLConfig shared].doubleClickAction = action;
    [LLSettingManager shared].doubleClickAction = @(action);
    [self loadData];
}

- (LLTitleCellModel *)getColorStyleModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"style") detailTitle:[LLConfigHelper colorStyleDetailDescription]];
    model.block = ^{
        [weakSelf showColorStyleAlert];
    };
    return model;
}

- (void)showColorStyleAlert {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (LLConfigColorStyle i = LLConfigColorStyleHack; i < LLConfigColorStyleCustom; i++) {
        NSString *action = [LLConfigHelper colorStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style") actions:actions currentAction:[LLConfigHelper colorStyleDescription] completion:^(NSInteger index) {
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

- (LLTitleCellModel *)getEntryWindowStyleModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"style") detailTitle:[LLConfigHelper entryWindowStyleDescription]];
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
        NSString *action = [LLConfigHelper entryWindowStyleDescription:i];
        if (action) {
            [actions addObject:action];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style") actions:actions currentAction:[LLConfigHelper entryWindowStyleDescription] completion:^(NSInteger index) {
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
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.shrink") flag:[LLConfig shared].isShrinkToEdgeWhenInactive];
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

- (LLTitleCellModel *)getShakeToHideModel {
    __weak typeof(self) weakSelf = self;
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.shake") flag:[LLConfig shared].isShakeToHide];
    model.changePropertyBlock = ^(id  _Nullable obj) {
        [weakSelf setNewShakeToHide:[obj boolValue]];
    };
    return model;
}

- (void)setNewShakeToHide:(BOOL)isShakeToHide {
    [LLConfig shared].shakeToHide = isShakeToHide;
    [LLSettingManager shared].shakeToHide = @(isShakeToHide);
}

#ifdef LLDEBUGTOOL_LOG
- (LLTitleCellModel *)getLogStyleModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"style") detailTitle:[LLConfigHelper logStyleDescription]];
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
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style") actions:actions currentAction:[LLConfigHelper logStyleDescription] completion:^(NSInteger index) {
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
#ifdef LLDEBUGTOOL_HIERARCHY
- (LLTitleCellModel *)getHierarchyIgnorePrivateClassModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.ignore.private") flag:[LLConfig shared].hierarchyIgnorePrivateClass];
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
#ifdef LLDEBUGTOOL_MAGNIFIER
- (LLTitleCellModel *)getMagnifierZoomLevelModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.zoom.level") value:[LLConfig shared].magnifierZoomLevel minValue:kLLMagnifierWindowMinZoomLevel maxValue:kLLMagnifierWindowMaxZoomLevel];
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
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"setting.zoom.size") value:[LLConfig shared].magnifierSize minValue:kLLMagnifierWindowMinSize maxValue:kLLMagnifierWindowMaxSize];
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

@end
