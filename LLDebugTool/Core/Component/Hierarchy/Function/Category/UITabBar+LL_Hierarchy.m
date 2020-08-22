//
//  UITabBar+LL_Hierarchy.m
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

#import "UITabBar+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UITabBar (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[LLHierarchyFormatter formatImage:self.backgroundImage]] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[LLHierarchyFormatter formatImage:self.shadowImage]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Selection" detailTitle:[LLHierarchyFormatter formatImage:self.selectionIndicatorImage]];
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model4.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription barStyles]
                                                 currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.barStyle = index;
                                                    }];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[LLHierarchyFormatter formatColor:self.barTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription tabBarItemPositioningDescription:self.itemPositioning]] noneInsets];
    model7.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription tabBarItemPositionings]
                                                 currentAction:[LLEnumDescription tabBarItemPositioningDescription:weakSelf.itemPositioning]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.itemPositioning = index;
                                                    }];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Item Width" detailTitle:[LLFormatterTool formatNumber:@(self.itemWidth)]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemWidth"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Item Spacing" detailTitle:[LLFormatterTool formatNumber:@(self.itemSpacing)]];
    model9.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemSpacing"];
    };
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Tab Bar" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
