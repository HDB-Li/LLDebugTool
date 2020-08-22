//
//  UIToolbar+LL_Hierarchy.m
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

#import "UIToolbar+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIToolbar (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription barStyles]
                                                 currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.barStyle = index;
                                                    }];
    };
    [settings addObject:model1];

    LLTitleSwitchCellModel *model2 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[LLHierarchyFormatter formatColor:self.barTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model3];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Tool Bar" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
