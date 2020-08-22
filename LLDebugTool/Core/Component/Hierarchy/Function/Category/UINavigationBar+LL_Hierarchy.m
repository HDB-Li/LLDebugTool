//
//  UINavigationBar+LL_Hierarchy.m
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

#import "UINavigationBar+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UINavigationBar (LL_Hierarchy)

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

    if (@available(iOS 11.0, *)) {
        LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Prefers Large Titles" isOn:self.prefersLargeTitles] noneInsets];
        model3.changePropertyBlock = ^(id obj) {
            weakSelf.prefersLargeTitles = [obj boolValue];
            [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
        };
        [settings addObject:model3];
    }

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[LLHierarchyFormatter formatColor:self.barTintColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow Image" detailTitle:[LLHierarchyFormatter formatImage:self.shadowImage]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Back Image" detailTitle:[LLHierarchyFormatter formatImage:self.backIndicatorImage]] noneInsets];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Back Mask" detailTitle:[LLHierarchyFormatter formatImage:self.backIndicatorTransitionMaskImage]];
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Title Attr." detailTitle:nil] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [[LLDetailTitleCellModel modelWithTitle:@"Title Font" detailTitle:[LLHierarchyFormatter formatObject:self.titleTextAttributes[NSFontAttributeName]]] noneInsets];
    if (self.titleTextAttributes[NSFontAttributeName]) {
        model9.block = ^{
            __block UIFont *font = weakSelf.titleTextAttributes[NSFontAttributeName];
            if (!font) {
                return;
            }
            [[LLHierarchyHelper shared] showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [LLFormatterTool formatNumber:@(font.pointSize)]]
                                                           handler:^(NSString *originText, NSString *newText) {
                                                               NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.titleTextAttributes];
                                                               attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                                                               weakSelf.titleTextAttributes = [attributes copy];
                                                           }];
        };
    }
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Title Color" detailTitle:[LLHierarchyFormatter formatColor:self.titleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
    [settings addObject:model10];

    NSShadow *shadow = self.titleTextAttributes[NSShadowAttributeName];
    if (![shadow isKindOfClass:[NSShadow class]]) {
        shadow = nil;
    }

    LLDetailTitleCellModel *model11 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[LLHierarchyFormatter formatColor:shadow.shadowColor]] noneInsets];
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[LLHierarchyFormatter formatSize:shadow.shadowOffset]];
    [settings addObject:model12];

    if (@available(iOS 11.0, *)) {
        LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:@"Large Title Attr." detailTitle:nil] noneInsets];
        [settings addObject:model13];

        LLDetailTitleCellModel *model14 = [[LLDetailTitleCellModel modelWithTitle:@"Title Font" detailTitle:[LLHierarchyFormatter formatColor:self.largeTitleTextAttributes[NSFontAttributeName]]] noneInsets];
        if (self.largeTitleTextAttributes[NSFontAttributeName]) {
            model14.block = ^{
                __block UIFont *font = weakSelf.largeTitleTextAttributes[NSFontAttributeName];
                if (!font) {
                    return;
                }
                [[LLHierarchyHelper shared] showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [LLFormatterTool formatNumber:@(font.pointSize)]]
                                                               handler:^(NSString *originText, NSString *newText) {
                                                                   NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.largeTitleTextAttributes];
                                                                   attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                                                                   weakSelf.largeTitleTextAttributes = [attributes copy];
                                                               }];
            };
        }
        [settings addObject:model14];

        LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Title Color" detailTitle:[LLHierarchyFormatter formatColor:self.largeTitleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
        [settings addObject:model15];

        shadow = self.largeTitleTextAttributes[NSShadowAttributeName];
        if (![shadow isKindOfClass:[NSShadow class]]) {
            shadow = nil;
        }

        LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[LLHierarchyFormatter formatColor:shadow.shadowColor]] noneInsets];
        [settings addObject:model16];

        LLDetailTitleCellModel *model17 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[LLHierarchyFormatter formatSize:shadow.shadowOffset]];
        [settings addObject:model17];
    }

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Navigation Bar" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
