//
//  UISlider+LL_Hierarchy.m
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

#import "UISlider+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UISlider (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Current" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Min Image" detailTitle:[LLHierarchyFormatter formatImage:self.minimumValueImage]] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [LLDetailTitleCellModel modelWithTitle:@"Max Image" detailTitle:[LLHierarchyFormatter formatImage:self.maximumValueImage]];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Min Track Tint" detailTitle:[LLHierarchyFormatter formatColor:self.minimumTrackTintColor]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"minimumTrackTintColor"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Max Track Tint" detailTitle:[LLHierarchyFormatter formatColor:self.maximumTrackTintColor]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"maximumTrackTintColor"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [LLDetailTitleCellModel modelWithTitle:@"Thumb Tint" detailTitle:[LLHierarchyFormatter formatColor:self.tintColor]];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:@"Events" detailTitle:@"Continuous Update" isOn:self.isContinuous];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.continuous = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Slider" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
