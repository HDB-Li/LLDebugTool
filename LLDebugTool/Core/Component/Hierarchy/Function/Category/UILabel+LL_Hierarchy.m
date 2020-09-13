//
//  UILabel+LL_Hierarchy.m
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

#import "UILabel+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UILabel (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[LLHierarchyFormatter formatText:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[LLHierarchyFormatter formatColor:self.textColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatObject:self.font]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [LLEnumDescription textAlignmentDescription:self.textAlignment]]] noneInsets];
    model5.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAlignments]
                                        currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                           completion:^(NSInteger index) {
                                               weakSelf.textAlignment = index;
                                           }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfLines]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfLines"];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Enabled" isOn:self.isEnabled] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.enabled = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Highlighted" isOn:self.isHighlighted];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.highlighted = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [[LLDetailTitleCellModel modelWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@", [LLEnumDescription baselineAdjustmentDescription:self.baselineAdjustment]]] noneInsets];
    model9.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription baselineAdjustments]
                                        currentAction:[LLEnumDescription baselineAdjustmentDescription:weakSelf.baselineAdjustment]
                                           completion:^(NSInteger index) {
                                               weakSelf.baselineAdjustment = index;
                                           }];
    };
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]] noneInsets];
    model10.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription lineBreaks]
                                        currentAction:[LLEnumDescription lineBreakModeDescription:weakSelf.lineBreakMode]
                                           completion:^(NSInteger index) {
                                               weakSelf.lineBreakMode = index;
                                           }];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:@"Min Font Scale" detailTitle:[LLFormatterTool formatNumber:@(self.minimumScaleFactor)]];
    model11.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumScaleFactor"];
    };
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [[LLDetailTitleCellModel modelWithTitle:@"Highlighted" detailTitle:[LLHierarchyFormatter formatColor:self.highlightedTextColor]] noneInsets];
    model12.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"highlightedTextColor"];
    };
    [settings addObject:model12];

    LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[LLHierarchyFormatter formatColor:self.shadowColor]] noneInsets];
    model13.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"shadowColor"];
    };
    [settings addObject:model13];

    LLDetailTitleCellModel *model14 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[LLHierarchyFormatter formatSize:self.shadowOffset]];
    model14.block = ^{
        [weakSelf LL_showSizeAlertAndAutomicSetWithKeyPath:@"shadowOffset"];
    };
    [settings addObject:model14];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Label" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
