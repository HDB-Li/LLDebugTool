//
//  UIScrollView+LL_Hierarchy.m
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

#import "UIScrollView+LL_Hierarchy.h"

#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UIScrollView (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    model1.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription scrollViewIndicatorStyles]
                                        currentAction:[LLEnumDescription scrollViewIndicatorStyleDescription:weakSelf.indicatorStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.indicatorStyle = index;
                                           }];
    };
    [settings addObject:model1];

    LLTitleSwitchCellModel *model2 = [[LLTitleSwitchCellModel modelWithTitle:@"Indicators" detailTitle:@"Shows Horizontal Indicator" isOn:self.showsHorizontalScrollIndicator] noneInsets];
    model2.changePropertyBlock = ^(id obj) {
        weakSelf.showsHorizontalScrollIndicator = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Vertical Indicator" isOn:self.showsVerticalScrollIndicator];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.showsVerticalScrollIndicator = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [[LLTitleSwitchCellModel modelWithTitle:@"Scrolling" detailTitle:@"Enable" isOn:self.isScrollEnabled] noneInsets];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.scrollEnabled = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Paging" isOn:self.isPagingEnabled] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.pagingEnabled = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Direction Lock" isOn:self.isDirectionalLockEnabled];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.directionalLockEnabled = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Bounce" detailTitle:@"Bounces" isOn:self.bounces] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.bounces = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Bounce Horizontal" isOn:self.alwaysBounceHorizontal] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.alwaysBounceHorizontal = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Bounce Vertical" isOn:self.alwaysBounceVertical];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.alwaysBounceVertical = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Zoom Min" detailTitle:[LLFormatterTool formatNumber:@(self.minimumZoomScale)]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumZoomScale"];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:@"Max" detailTitle:[LLFormatterTool formatNumber:@(self.maximumZoomScale)]];
    model11.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumZoomScale"];
    };
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [[LLDetailTitleCellModel modelWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@", [LLHierarchyFormatter formatBool:self.isZoomBouncing]]] noneInsets];
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Delays Content Touches" isOn:self.delaysContentTouches] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.delaysContentTouches = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Cancellable Content Touches" isOn:self.canCancelContentTouches];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.canCancelContentTouches = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
    model15.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription scrollViewKeyboardDismissModes]
                                        currentAction:[LLEnumDescription scrollViewKeyboardDismissModeDescription:weakSelf.keyboardDismissMode]
                                           completion:^(NSInteger index) {
                                               weakSelf.keyboardDismissMode = index;
                                           }];
    };
    [settings addObject:model15];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Scroll View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
