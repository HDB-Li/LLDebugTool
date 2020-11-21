//
//  NSObject+LL_Hierarchy.m
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

#import "NSObject+LL_Hierarchy.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLInternalMacros.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleCellModel.h"
#import "LLTitleSwitchCellModel.h"
#import "LLTool.h"

#import "NSObject+LL_Runtime.h"
#import "UIColor+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

@implementation NSObject (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Class Name" detailTitle:NSStringFromClass(self.class)] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p", self]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Description" detailTitle:self.description] noneInsets];
    [settings addObject:model3];

    return [[NSMutableArray alloc] initWithObjects:[LLTitleCellCategoryModel modelWithTitle:@"Object" items:settings], nil];
}

- (void)LL_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [self valueForKeyPath:keyPath]]
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:@([newText integerValue]) forKeyPath:keyPath];
                                          }];
}

- (void)LL_showDoubleAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[LLFormatterTool formatNumber:[self valueForKeyPath:keyPath]]
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:@([newText doubleValue]) forKeyPath:keyPath];
                                          }];
}

- (void)LL_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIColor *color = [self valueForKeyPath:keyPath];
    if (color && ![color isKindOfClass:[UIColor class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[color LL_hexString]
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:[LLHierarchyFormatter colorFromString:newText defaultValue:color] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showPointAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:NSStringFromCGPoint([value CGPointValue])
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:[NSValue valueWithCGPoint:[LLHierarchyFormatter pointFromString:newText defaultValue:[value CGPointValue]]] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showEdgeInsetsAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:NSStringFromUIEdgeInsets([value UIEdgeInsetsValue])
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:[NSValue valueWithUIEdgeInsets:[LLHierarchyFormatter insetsFromString:newText defaultValue:[value UIEdgeInsetsValue]]] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[self valueForKeyPath:keyPath]
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:newText forKeyPath:keyPath];
                                          }];
}

- (void)LL_showAttributeTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSAttributedString *attribute = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:attribute.string
                                          handler:^(NSString *originText, NSString *newText) {
                                              NSMutableAttributedString *mutAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attribute];
                                              [mutAttribute replaceCharactersInRange:NSMakeRange(0, attribute.string.length) withString:newText];
                                              [weakSelf setValue:[mutAttribute copy] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showSizeAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:NSStringFromCGSize([value CGSizeValue])
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:[NSValue valueWithCGSize:[LLHierarchyFormatter sizeFromString:newText defaultValue:[value CGSizeValue]]] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIFont *font = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(font.pointSize)]
                                          handler:^(NSString *originText, NSString *newText) {
                                              [weakSelf setValue:[font fontWithSize:[newText doubleValue]] forKeyPath:keyPath];
                                          }];
}

- (void)LL_showDateAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    NSDate *date = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [LLDT_CC_Hierarchy showTextFieldAlertWithText:[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3]
                                          handler:^(NSString *originText, NSString *newText) {
                                              NSDate *newDate = [LLFormatterTool dateFromString:newText style:FormatterToolDateStyle3];
                                              if (newDate) {
                                                  [weakSelf setValue:newDate forKeyPath:keyPath];
                                              }
                                          }];
}

@end
