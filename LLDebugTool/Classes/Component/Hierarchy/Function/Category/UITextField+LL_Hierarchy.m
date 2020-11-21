//
//  UITextField+LL_Hierarchy.m
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

#import "UITextField+LL_Hierarchy.h"

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

@implementation UITextField (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Plain Text" detailTitle:[LLHierarchyFormatter formatText:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Attributed Text" detailTitle:[LLHierarchyFormatter formatObject:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Allows Editing Attributes" isOn:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Color" detailTitle:[LLHierarchyFormatter formatColor:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Font" detailTitle:[LLHierarchyFormatter formatObject:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]] noneInsets];
    model6.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAlignments]
                                        currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                           completion:^(NSInteger index) {
                                               weakSelf.textAlignment = index;
                                           }];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Placeholder" detailTitle:[LLHierarchyFormatter formatText:self.placeholder ?: self.attributedPlaceholder.string]];
    model7.block = ^{
        if (weakSelf.placeholder) {
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
        } else {
            [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedPlaceholder"];
        }
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[LLHierarchyFormatter formatImage:self.background]] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Disabled" detailTitle:[LLHierarchyFormatter formatImage:self.disabledBackground]];
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [LLDetailTitleCellModel modelWithTitle:@"Border Style" detailTitle:[LLEnumDescription textBorderStyleDescription:self.borderStyle]];
    model10.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textBorderStyles]
                                        currentAction:[LLEnumDescription textBorderStyleDescription:weakSelf.borderStyle]
                                           completion:^(NSInteger index) {
                                               weakSelf.borderStyle = index;
                                           }];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [[LLDetailTitleCellModel modelWithTitle:@"Clear Button" detailTitle:[LLEnumDescription textFieldViewModeDescription:self.clearButtonMode]] noneInsets];
    model11.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textFieldViewModes]
                                        currentAction:[LLEnumDescription textFieldViewModeDescription:weakSelf.clearButtonMode]
                                           completion:^(NSInteger index) {
                                               weakSelf.clearButtonMode = index;
                                           }];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clear when editing begins" isOn:self.clearsOnBeginEditing];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.clearsOnBeginEditing = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:@"Min Font Size" detailTitle:[LLFormatterTool formatNumber:@(self.minimumFontSize)]] noneInsets];
    model13.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumFontSize"];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Adjusts to Fit" isOn:self.adjustsFontSizeToFitWidth];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.adjustsFontSizeToFitWidth = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model15.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                        currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                           completion:^(NSInteger index) {
                                               weakSelf.autocapitalizationType = index;
                                           }];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model16.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                        currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                           completion:^(NSInteger index) {
                                               weakSelf.autocorrectionType = index;
                                           }];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model17.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                        currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                           completion:^(NSInteger index) {
                                               weakSelf.keyboardType = index;
                                           }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model18.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription keyboardAppearances]
                                        currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance]
                                           completion:^(NSInteger index) {
                                               weakSelf.keyboardAppearance = index;
                                           }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model19.block = ^{
        [LLDT_CC_Hierarchy showActionSheetWithActions:[LLEnumDescription returnKeyTypes]
                                        currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType]
                                           completion:^(NSInteger index) {
                                               weakSelf.returnKeyType = index;
                                           }];
    };
    [settings addObject:model19];

    LLTitleSwitchCellModel *model20 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Auto-enable Return Key" isOn:self.enablesReturnKeyAutomatically] noneInsets];
    model20.changePropertyBlock = ^(id obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model20];

    LLTitleSwitchCellModel *model21 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Secure Entry" isOn:self.isSecureTextEntry];
    model21.changePropertyBlock = ^(id obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [LLDT_CC_Hierarchy postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model21];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Text Field" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
