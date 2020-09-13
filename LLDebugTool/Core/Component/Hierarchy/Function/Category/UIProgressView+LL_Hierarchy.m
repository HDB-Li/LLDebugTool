//
//  UIProgressView+LL_Hierarchy.m
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

#import "UIProgressView+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIProgressView (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription progressViewStyleDescription:self.progressViewStyle]];
    model1.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription progressViewStyles]
                                        currentAction:[LLEnumDescription progressViewStyleDescription:weakSelf.progressViewStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.progressViewStyle = index;
                                           }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Progress" detailTitle:[LLFormatterTool formatNumber:@(self.progress)]];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"progress"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Progress Tint" detailTitle:[LLHierarchyFormatter formatColor:self.progressTintColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"progressTintColor"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Track Tint" detailTitle:[LLHierarchyFormatter formatColor:self.trackTintColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"trackTintColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Progress Image" detailTitle:[LLHierarchyFormatter formatImage:self.progressImage]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Track Image" detailTitle:[LLHierarchyFormatter formatImage:self.trackImage]];
    [settings addObject:model6];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Progress View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
