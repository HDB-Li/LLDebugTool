//
//  UITextView+LL_Hierarchy.m
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

#import "UITextView+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UITextView (LL_Hierarchy)

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
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
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

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]];
    model6.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription textAlignments]
                                                 currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.textAlignment = index;
                                                    }];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Editable" isOn:self.isEditable] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.editable = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Selectable" isOn:self.isSelectable];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.selectable = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [[LLTitleSwitchCellModel modelWithTitle:@"Data Detectors" detailTitle:@"Phone Number" isOn:self.dataDetectorTypes & UIDataDetectorTypePhoneNumber] noneInsets];
    model9.changePropertyBlock = ^(id obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypePhoneNumber;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypePhoneNumber;
        }
    };
    [settings addObject:model9];

    LLTitleSwitchCellModel *model10 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Link" isOn:self.dataDetectorTypes & UIDataDetectorTypeLink] noneInsets];
    model10.changePropertyBlock = ^(id obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeLink;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeLink;
        }
    };
    [settings addObject:model10];

    LLTitleSwitchCellModel *model11 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Address" isOn:self.dataDetectorTypes & UIDataDetectorTypeAddress] noneInsets];
    model11.changePropertyBlock = ^(id obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeAddress;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeAddress;
        }
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Calendar Event" isOn:self.dataDetectorTypes & UIDataDetectorTypeCalendarEvent] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeCalendarEvent;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeCalendarEvent;
        }
    };
    [settings addObject:model12];

    if (@available(iOS 10.0, *)) {
        LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shipment Tracking Number" isOn:self.dataDetectorTypes & UIDataDetectorTypeShipmentTrackingNumber] noneInsets];
        model13.changePropertyBlock = ^(id obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeShipmentTrackingNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeShipmentTrackingNumber;
            }
        };
        [settings addObject:model13];

        LLTitleSwitchCellModel *model14 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Flight Number" isOn:self.dataDetectorTypes & UIDataDetectorTypeFlightNumber] noneInsets];
        model14.changePropertyBlock = ^(id obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeFlightNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeFlightNumber;
            }
        };
        [settings addObject:model14];

        LLTitleSwitchCellModel *model15 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Lookup Suggestion" isOn:self.dataDetectorTypes & UIDataDetectorTypeLookupSuggestion];
        model15.changePropertyBlock = ^(id obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeLookupSuggestion;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeLookupSuggestion;
            }
        };
        [settings addObject:model15];
    } else {
        [model12 normalInsets];
    }

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model16.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                                 currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.autocapitalizationType = index;
                                                    }];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model17.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                                 currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.autocorrectionType = index;
                                                    }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model18.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                                 currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.keyboardType = index;
                                                    }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model19.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription keyboardAppearances]
                                                 currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.keyboardAppearance = index;
                                                    }];
    };
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [[LLDetailTitleCellModel modelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model20.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription returnKeyTypes]
                                                 currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.returnKeyType = index;
                                                    }];
    };
    [settings addObject:model20];

    LLTitleSwitchCellModel *model21 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Auto-enable Return Key" isOn:self.enablesReturnKeyAutomatically] noneInsets];
    model21.changePropertyBlock = ^(id obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model21];

    LLTitleSwitchCellModel *model22 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Secure Entry" isOn:self.isSecureTextEntry];
    model22.changePropertyBlock = ^(id obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model22];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Text View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
