//
//  UIButton+LL_Hierarchy.m
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

#import "UIButton+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"
#import "UIColor+LL_Utils.h"

@implementation UIButton (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Type" detailTitle:[LLEnumDescription buttonTypeDescription:self.buttonType]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"State" detailTitle:[LLEnumDescription controlStateDescription:self.state]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Title" detailTitle:[LLHierarchyFormatter formatText:self.currentTitle]] noneInsets];
    model3.block = ^{
        [[LLHierarchyHelper shared] showTextFieldAlertWithText:weakSelf.currentTitle
                                                       handler:^(NSString *originText, NSString *newText) {
                                                           [weakSelf setTitle:newText forState:weakSelf.state];
                                                       }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Text Color" detailTitle:[LLHierarchyFormatter formatColor:self.currentTitleColor]] noneInsets];
    model5.block = ^{
        [[LLHierarchyHelper shared] showTextFieldAlertWithText:[weakSelf.currentTitleColor LL_hexString]
                                                       handler:^(NSString *originText, NSString *newText) {
                                                           [weakSelf setTitleColor:[LLHierarchyFormatter colorFromString:newText defaultValue:weakSelf.currentTitleColor] forState:weakSelf.state];
                                                       }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Color" detailTitle:[LLHierarchyFormatter formatColor:self.currentTitleShadowColor]];
    model6.block = ^{
        [[LLHierarchyHelper shared] showTextFieldAlertWithText:[weakSelf.currentTitleShadowColor LL_hexString]
                                                       handler:^(NSString *originText, NSString *newText) {
                                                           [weakSelf setTitleShadowColor:[LLHierarchyFormatter colorFromString:newText defaultValue:weakSelf.currentTitleShadowColor] forState:weakSelf.state];
                                                       }];
    };
    [settings addObject:model6];

    id target = self.allTargets.allObjects.firstObject;
    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@", target] : @"<nil>"] noneInsets];
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [LLDetailTitleCellModel modelWithTitle:@"Action" detailTitle:[LLHierarchyFormatter formatText:[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject]];
    ;
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[LLHierarchyFormatter formatImage:self.currentImage]];
    [settings addObject:model9];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[LLHierarchyFormatter formatSize:self.titleShadowOffset]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showSizeAlertAndAutomicSetWithKeyPath:@"titleShadowOffset"];
    };
    [settings addObject:model10];
#pragma clang diagnostic pop

    LLDetailTitleCellModel *model11 = [[LLDetailTitleCellModel modelWithTitle:@"On Highlight" detailTitle:self.reversesTitleShadowWhenHighlighted ? @"Shadow Reverses" : @"Normal Shadow"] noneInsets];
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.showsTouchWhenHighlighted ? @"Shows Touch" : @"Doesn't Show Touch"] noneInsets];
    [settings addObject:model12];

    LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.adjustsImageWhenHighlighted ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model13];

    LLDetailTitleCellModel *model14 = [[LLDetailTitleCellModel modelWithTitle:@"When Disabled" detailTitle:self.adjustsImageWhenDisabled ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model14];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLDetailTitleCellModel *model15 = [LLDetailTitleCellModel modelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]];
    [settings addObject:model15];
#pragma clang diagnostic pop

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Content Insets" detailTitle:[LLHierarchyFormatter formatInsetsTopBottom:self.contentEdgeInsets]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"contentEdgeInsets"];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatInsetsLeftRight:self.contentEdgeInsets]] noneInsets];
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Title Insets" detailTitle:[LLHierarchyFormatter formatInsetsTopBottom:self.titleEdgeInsets]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"titleEdgeInsets"];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatInsetsLeftRight:self.titleEdgeInsets]] noneInsets];
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [[LLDetailTitleCellModel modelWithTitle:@"Image Insets" detailTitle:[LLHierarchyFormatter formatInsetsTopBottom:self.imageEdgeInsets]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"imageEdgeInsets"];
    };
    [settings addObject:model20];

    LLDetailTitleCellModel *model21 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatInsetsLeftRight:self.imageEdgeInsets]];
    [settings addObject:model21];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Button" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end
