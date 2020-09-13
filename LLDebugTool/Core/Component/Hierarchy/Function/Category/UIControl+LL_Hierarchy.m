//
//  UIControl+LL_Hierarchy.m
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

#import "UIControl+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIControl (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [LLEnumDescription controlContentHorizontalAlignmentDescription:self.contentHorizontalAlignment]]] noneInsets];
    model1.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription controlContentHorizontalAlignments]
                                        currentAction:[LLEnumDescription controlContentHorizontalAlignmentDescription:weakSelf.contentHorizontalAlignment]
                                           completion:^(NSInteger index) {
                                               weakSelf.contentHorizontalAlignment = index;
                                           }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [LLEnumDescription controlContentVerticalAlignmentDescription:self.contentVerticalAlignment]]];
    model2.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription controlContentVerticalAlignments]
                                        currentAction:[LLEnumDescription controlContentVerticalAlignmentDescription:weakSelf.contentVerticalAlignment]
                                           completion:^(NSInteger index) {
                                               weakSelf.contentVerticalAlignment = index;
                                           }];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:@"Content" detailTitle:self.isSelected ? @"Selected" : @"Not Selected" isOn:self.isSelected] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.selected = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:self.isEnabled ? @"Enabled" : @"Not Enabled" isOn:self.isEnabled] noneInsets];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.enabled = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" isOn:self.isHighlighted];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.highlighted = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Control" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
