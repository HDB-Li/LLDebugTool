//
//  UITableView+LL_Hierarchy.m
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

#import "UITableView+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UITableView (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfSections]] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription tableViewStyleDescription:self.style]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Separator" detailTitle:[LLEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]] noneInsets];
    model3.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription tableViewCellSeparatorStyles]
                                        currentAction:[LLEnumDescription tableViewCellSeparatorStyleDescription:weakSelf.separatorStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.separatorStyle = index;
                                           }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatColor:self.separatorColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"separatorColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Data Source" detailTitle:[LLHierarchyFormatter formatObject:self.dataSource]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Delegate" detailTitle:[LLHierarchyFormatter formatObject:self.delegate]];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Separator Inset" detailTitle:[LLHierarchyFormatter formatInsetsTopBottom:self.separatorInset]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatInsetsLeftRight:self.separatorInset]] noneInsets];
    [settings addObject:model8];

    if (@available(iOS 11.0, *)) {
        LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        model9.block = ^{
            [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription tableViewSeparatorInsetReferences]
                                            currentAction:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:weakSelf.separatorInsetReference]
                                               completion:^(NSInteger index) {
                                                   weakSelf.separatorInsetReference = index;
                                               }];
        };
        [settings addObject:model9];
    }

    LLTitleSwitchCellModel *model10 = [[LLTitleSwitchCellModel modelWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled" isOn:self.allowsSelection] noneInsets];
    model10.changePropertyBlock = ^(id obj) {
        weakSelf.allowsSelection = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model10];

    LLTitleSwitchCellModel *model11 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@", self.allowsMultipleSelection ? @"" : @"Disabled"] isOn:self.allowsMultipleSelection] noneInsets];
    model11.changePropertyBlock = ^(id obj) {
        weakSelf.allowsMultipleSelection = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled" isOn:self.allowsSelectionDuringEditing] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.allowsSelectionDuringEditing = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@", self.allowsMultipleSelectionDuringEditing ? @"" : @"Disabled"] isOn:self.allowsMultipleSelectionDuringEditing];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.allowsMultipleSelectionDuringEditing = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLDetailTitleCellModel *model14 = [[LLDetailTitleCellModel modelWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.sectionIndexMinimumDisplayRowCount]] noneInsets];
    model14.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"sectionIndexMinimumDisplayRowCount"];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[LLHierarchyFormatter formatColor:self.sectionIndexColor]] noneInsets];
    model15.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexColor"];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[LLHierarchyFormatter formatColor:self.sectionIndexBackgroundColor]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexBackgroundColor"];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [LLDetailTitleCellModel modelWithTitle:@"Tracking" detailTitle:[LLHierarchyFormatter formatColor:self.sectionIndexTrackingBackgroundColor]];
    model17.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexTrackingBackgroundColor"];
    };
    model17.block = ^{

    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Row Height" detailTitle:[LLFormatterTool formatNumber:@(self.rowHeight)]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"rowHeight"];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Section Header" detailTitle:[LLFormatterTool formatNumber:@(self.sectionHeaderHeight)]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionHeaderHeight"];
    };
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [LLDetailTitleCellModel modelWithTitle:@"Section Footer" detailTitle:[LLFormatterTool formatNumber:@(self.sectionFooterHeight)]];
    model20.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionFooterHeight"];
    };
    [settings addObject:model20];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Table View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
