//
//  UITableViewCell+LL_Hierarchy.m
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

#import "UITableViewCell+LL_Hierarchy.h"

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

@implementation UITableViewCell (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[LLHierarchyFormatter formatImage:self.imageView.image]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Identifier" detailTitle:[LLHierarchyFormatter formatText:self.reuseIdentifier]];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Selection" detailTitle:[LLEnumDescription tableViewCellSelectionStyleDescription:self.selectionStyle]] noneInsets];
    model3.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription tableViewCellSelectionStyles]
                                        currentAction:[LLEnumDescription tableViewCellSelectionStyleDescription:weakSelf.selectionStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.selectionStyle = index;
                                           }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Accessory" detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.accessoryType]] noneInsets];
    model4.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes]
                                        currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.accessoryType]
                                           completion:^(NSInteger index) {
                                               weakSelf.accessoryType = index;
                                           }];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [LLDetailTitleCellModel modelWithTitle:@"Editing Acc." detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.editingAccessoryType]];
    model5.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes]
                                        currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.editingAccessoryType]
                                           completion:^(NSInteger index) {
                                               weakSelf.editingAccessoryType = index;
                                           }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Indentation" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.indentationLevel]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"indentationLevel"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLFormatterTool formatNumber:@(self.indentationWidth)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"indentationWidth"];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Indent While Editing" isOn:self.shouldIndentWhileEditing] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.shouldIndentWhileEditing = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Re-order Controls" isOn:self.showsReorderControl];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.showsReorderControl = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Separator Inset" detailTitle:[LLHierarchyFormatter formatInsetsTopBottom:self.separatorInset]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatInsetsLeftRight:self.separatorInset]];
    [settings addObject:model11];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Table View Cell" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
