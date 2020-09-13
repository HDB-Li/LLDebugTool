//
//  UISegmentedControl+LL_Hierarchy.m
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

#import "UISegmentedControl+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UISegmentedControl (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLTitleSwitchCellModel *model1 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:self.isMomentary ? @"Momentary" : @"Persistent Selection" isOn:self.isMomentary] noneInsets];
    model1.changePropertyBlock = ^(id obj) {
        weakSelf.momentary = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Segments" detailTitle:[NSString stringWithFormat:@"%ld", (unsigned long)self.numberOfSegments]];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Selected Index" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.selectedSegmentIndex]] noneInsets];
    model3.block = ^{
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < weakSelf.numberOfSegments; i++) {
            [actions addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        [LLDT_CC_Hierarchy showActionSheetWithActions:actions
                                        currentAction:[NSString stringWithFormat:@"%ld", (long)weakSelf.selectedSegmentIndex]
                                           completion:^(NSInteger index) {
                                               weakSelf.selectedSegmentIndex = index;
                                           }];
    };
    [settings addObject:model3];

#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Large title" detailTitle:[LLHierarchyFormatter formatText:self.largeContentTitle]] noneInsets];
        model4.block = ^{
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"largeContentTitle"];
        };
        [settings addObject:model4];

        LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[LLHierarchyFormatter formatImage:self.largeContentImage]] noneInsets];
        [settings addObject:model5];
    }
#endif

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Selected" detailTitle:[self isEnabledForSegmentAtIndex:self.selectedSegmentIndex] ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Offset" detailTitle:[LLHierarchyFormatter formatSize:[self contentOffsetForSegmentAtIndex:self.selectedSegmentIndex]]] noneInsets];
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:@"Size Mode" detailTitle:self.apportionsSegmentWidthsByContent ? @"Proportional to Content" : @"Equal Widths" isOn:self.apportionsSegmentWidthsByContent] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.apportionsSegmentWidthsByContent = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Width" detailTitle:[LLFormatterTool formatNumber:@([self widthForSegmentAtIndex:self.selectedSegmentIndex])]];
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Segmented Control" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
