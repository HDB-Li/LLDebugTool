//
//  UIStepper+LL_Hierarchy.m
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

#import "UIStepper+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLFormatterTool.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIStepper (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Value" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Step" detailTitle:[LLFormatterTool formatNumber:@(self.stepValue)]];
    model4.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"stepValue"];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Autorepeat" isOn:self.autorepeat] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.autorepeat = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Continuous" isOn:self.isContinuous] noneInsets];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.continuous = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Wrap" isOn:self.wraps];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.wraps = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Stepper" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
