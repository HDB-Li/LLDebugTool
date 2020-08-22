//
//  UISwitch+LL_Hierarchy.m
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

#import "UISwitch+LL_Hierarchy.h"

#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UISwitch (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLTitleSwitchCellModel *model1 = [[LLTitleSwitchCellModel modelWithTitle:@"State" isOn:self.isOn] noneInsets];
    model1.changePropertyBlock = ^(id obj) {
        weakSelf.on = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"On Tint" detailTitle:[LLHierarchyFormatter formatColor:self.onTintColor]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"onTintColor"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Thumb Tint" detailTitle:[LLHierarchyFormatter formatColor:self.thumbTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"thumbTintColor"];
    };
    [settings addObject:model3];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Switch" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
