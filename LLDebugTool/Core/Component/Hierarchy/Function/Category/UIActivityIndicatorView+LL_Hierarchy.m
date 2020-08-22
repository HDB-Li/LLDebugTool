//
//  UIActivityIndicatorView+LL_Hierarchy.m
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

#import "UIActivityIndicatorView+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIActivityIndicatorView (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription activityIndicatorViewStyleDescription:self.activityIndicatorViewStyle]] noneInsets];
    model1.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription activityIndicatorViewStyles]
                                                 currentAction:[LLEnumDescription activityIndicatorViewStyleDescription:weakSelf.activityIndicatorViewStyle]
                                                    completion:^(NSInteger index) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                        if (index <= UIActivityIndicatorViewStyleGray) {
                                                            weakSelf.activityIndicatorViewStyle = index;
                                                        } else {
#ifdef __IPHONE_13_0
                                                            if (@available(iOS 13.0, *)) {
                                                                weakSelf.activityIndicatorViewStyle = index + (UIActivityIndicatorViewStyleMedium - UIActivityIndicatorViewStyleGray - 1);
                                                            }
#endif
                                                        }
#pragma clang diagnostic pop
                                                    }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Color" detailTitle:[LLHierarchyFormatter formatColor:self.color]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"color"];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Animating" isOn:self.isAnimating] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        if ([obj boolValue]) {
            if (!weakSelf.isAnimating) {
                [weakSelf startAnimating];
            };
        } else {
            if (weakSelf.isAnimating) {
                [weakSelf stopAnimating];
            }
        }
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Hides When Stopped" isOn:self.hidesWhenStopped];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.hidesWhenStopped = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Activity Indicator View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
