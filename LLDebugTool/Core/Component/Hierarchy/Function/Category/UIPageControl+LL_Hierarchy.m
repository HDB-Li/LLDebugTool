//
//  UIPageControl+LL_Hierarchy.m
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

#import "UIPageControl+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIPageControl (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Pages" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfPages]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfPages"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Current Page" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.currentPage]] noneInsets];
    model2.block = ^{
        if (weakSelf.numberOfPages < 10) {
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < weakSelf.numberOfPages; i++) {
                [actions addObject:[NSString stringWithFormat:@"%ld", (long)i]];
            }
            [[LLHierarchyHelper shared] showActionSheetWithActions:actions
                                                     currentAction:[NSString stringWithFormat:@"%ld", (long)weakSelf.currentPage]
                                                        completion:^(NSInteger index) {
                                                            weakSelf.currentPage = index;
                                                        }];
        } else {
            [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"currentPage"];
        }
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Hides for Single Page" isOn:self.hidesForSinglePage] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.hidesForSinglePage = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Defers Page Display" isOn:self.defersCurrentPageDisplay];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.defersCurrentPageDisplay = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Tint Color" detailTitle:[LLHierarchyFormatter formatColor:self.pageIndicatorTintColor]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"pageIndicatorTintColor"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Current Page" detailTitle:[LLHierarchyFormatter formatColor:self.currentPageIndicatorTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"currentPageIndicatorTintColor"];
    };
    [settings addObject:model6];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Page Control" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
