//
//  UISearchBar+LL_Hierarchy.m
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

#import "UISearchBar+LL_Hierarchy.h"

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

@implementation UISearchBar (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[LLHierarchyFormatter formatText:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Placeholder" detailTitle:[LLHierarchyFormatter formatText:self.placeholder]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Prompt" detailTitle:[LLHierarchyFormatter formatText:self.prompt]];
    model3.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"prompt"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Search Style" detailTitle:[LLEnumDescription searchBarStyleDescription:self.searchBarStyle]] noneInsets];
    model4.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription searchBarStyles]
                                        currentAction:[LLEnumDescription searchBarStyleDescription:weakSelf.searchBarStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.searchBarStyle = index;
                                           }];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Bar Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model5.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription barStyles]
                                        currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.barStyle = index;
                                           }];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatColor:self.barTintColor]];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[LLHierarchyFormatter formatImage:self.backgroundImage]] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Scope Bar" detailTitle:[LLHierarchyFormatter formatImage:self.scopeBarBackgroundImage]];
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Text Offset" detailTitle:[LLHierarchyFormatter formatOffset:self.searchTextPositionAdjustment]] noneInsets];
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:@"BG Offset" detailTitle:[LLHierarchyFormatter formatOffset:self.searchFieldBackgroundPositionAdjustment]];
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:@"Options" detailTitle:@"Shows Search Results Button" isOn:self.showsSearchResultsButton] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.showsSearchResultsButton = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Bookmarks Button" isOn:self.showsBookmarkButton] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.showsBookmarkButton = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Cancel Button" isOn:self.showsCancelButton] noneInsets];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.showsCancelButton = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLTitleSwitchCellModel *model15 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Scope Bar" isOn:self.showsScopeBar];
    model15.changePropertyBlock = ^(id obj) {
        weakSelf.showsScopeBar = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [LLDetailTitleCellModel modelWithTitle:@"Scope Titles" detailTitle:[LLHierarchyFormatter formatObject:self.scopeButtonTitles]];
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model17.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                        currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                           completion:^(NSInteger index) {
                                               weakSelf.autocapitalizationType = index;
                                           }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model18.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                        currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                           completion:^(NSInteger index) {
                                               weakSelf.autocorrectionType = index;
                                           }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]];
    model19.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                        currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                           completion:^(NSInteger index) {
                                               weakSelf.keyboardType = index;
                                           }];
    };
    [settings addObject:model19];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Search Bar" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
