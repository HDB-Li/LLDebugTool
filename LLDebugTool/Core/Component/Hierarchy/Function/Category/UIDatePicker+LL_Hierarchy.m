//
//  UIDatePicker+LL_Hierarchy.m
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

#import "UIDatePicker+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIDatePicker (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Mode" detailTitle:[LLEnumDescription datePickerModeDescription:self.datePickerMode]] noneInsets];
    model1.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription datePickerModes]
                                                 currentAction:[LLEnumDescription datePickerModeDescription:weakSelf.datePickerMode]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.datePickerMode = index;
                                                    }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Locale Identifier" detailTitle:self.locale.localeIdentifier] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Interval" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.minuteInterval]];
    model3.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"minuteInterval"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Date" detailTitle:[LLHierarchyFormatter formatDate:self.date]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"date"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Min Date" detailTitle:[LLHierarchyFormatter formatDate:self.minimumDate]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"minimumDate"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Max Date" detailTitle:[LLHierarchyFormatter formatDate:self.maximumDate]];
    model6.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"maximumDate"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Count Down" detailTitle:[LLFormatterTool formatNumber:@(self.countDownDuration)]];
    [settings addObject:model7];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Date Picker" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
