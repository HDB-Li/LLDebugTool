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
#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLInternalMacros.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleCellModel.h"
#import "LLTitleSwitchCellModel.h"
#import "LLTool.h"

#import "UIColor+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

NSNotificationName const LLDebugToolChangeHierarchyNotification = @"LLDebugToolChangeHierarchyNotification";

@implementation NSObject (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Class Name" detailTitle:NSStringFromClass(self.class)] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p", self]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Description" detailTitle:self.description] noneInsets];
    [settings addObject:model3];

    return @[[LLTitleCellCategoryModel modelWithTitle:@"Object" items:settings]];
}

- (NSString *)LL_hierarchyColorDescription:(UIColor *)color {
    if (!color) {
        return @"<nil color>";
    }

    NSArray *rgba = [color LL_RGBA];
    NSString *rgb = [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [LLFormatterTool formatNumber:rgba[0]], [LLFormatterTool formatNumber:rgba[1]], [LLFormatterTool formatNumber:rgba[2]], [LLFormatterTool formatNumber:rgba[3]]];

    NSString *colorName = [color LL_systemColorName];

    return colorName ? [rgb stringByAppendingFormat:@"\n%@", colorName] : [rgb stringByAppendingFormat:@"\n%@", [color LL_hexString]];
}

- (UIColor *)LL_colorFromString:(NSString *)string originalColor:(UIColor *)color {
    BOOL error = NO;
    UIColor *newColor = [UIColor LL_colorWithHex:string error:&error];
    if (error) {
        return color;
    }
    return newColor;
}

- (NSString *)LL_hierarchyBoolDescription:(BOOL)flag {
    return flag ? @"On" : @"Off";
}

- (NSString *)LL_hierarchyImageDescription:(UIImage *)image {
    return image ? image.description : @"No image";
}

- (NSString *)LL_hierarchyObjectDescription:(NSObject *)obj {
    NSString *text = @"<null>";
    if (obj) {
        text = [NSString stringWithFormat:@"%@", obj];
    }
    if ([text length] == 0) {
        text = @"<empty string>";
    }
    return text;
}

- (NSString *)LL_hierarchyDateDescription:(NSDate *)date {
    if (!date) {
        return @"<null>";
    }
    return [LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3] ?: @"<null>";
}

- (NSString *)LL_hierarchyTextDescription:(NSString *)text {
    if (text == nil) {
        return @"<nil>";
    }
    if ([text length] == 0) {
        return @"<empty string>";
    }
    return text;
}

- (NSString *)LL_hierarchyPointDescription:(CGPoint)point {
    return [NSString stringWithFormat:@"X: %@   Y: %@", [LLFormatterTool formatNumber:@(point.x)], [LLFormatterTool formatNumber:@(point.y)]];
}

- (CGPoint)LL_pointFromString:(NSString *)string orginalPoint:(CGPoint)point {
    return CGPointFromString(string);
}

- (NSString *)LL_hierarchySizeDescription:(CGSize)size {
    return [NSString stringWithFormat:@"W: %@   H: %@", [LLFormatterTool formatNumber:@(size.width)], [LLFormatterTool formatNumber:@(size.height)]];
}

- (CGRect)LL_rectFromString:(NSString *)string originalRect:(CGRect)rect {
    CGRect newRect = CGRectFromString(string);
    if (CGRectEqualToRect(newRect, CGRectZero) && ![string isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong rect string"];
        return rect;
    }
    return newRect;
}

- (CGSize)LL_sizeFromString:(NSString *)string originalSize:(CGSize)size {
    CGSize newSize = CGSizeFromString(string);
    if (CGSizeEqualToSize(newSize, CGSizeZero) && ![string isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong size string"];
        return size;
    }
    return newSize;
}

- (NSString *)LL_hierarchyInsetsTopBottomDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"top %@    bottom %@", [LLFormatterTool formatNumber:@(insets.top)], [LLFormatterTool formatNumber:@(insets.bottom)]];
}

- (UIEdgeInsets)LL_insetsFromString:(NSString *)string originalInsets:(UIEdgeInsets)insets {
    UIEdgeInsets newInsets = UIEdgeInsetsFromString(string);
    if (UIEdgeInsetsEqualToEdgeInsets(newInsets, UIEdgeInsetsZero) && ![string isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong insets string"];
        return insets;
    }
    return newInsets;
}

- (NSString *)LL_hierarchyInsetsLeftRightDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"left %@    right %@", [LLFormatterTool formatNumber:@(insets.left)], [LLFormatterTool formatNumber:@(insets.right)]];
}

- (NSString *)LL_hierarchyOffsetDescription:(UIOffset)offset {
    return [NSString stringWithFormat:@"h %@   v %@", [LLFormatterTool formatNumber:@(offset.horizontal)], [LLFormatterTool formatNumber:@(offset.vertical)]];
}

- (void)LL_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [self valueForKeyPath:keyPath]]
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:@([newText integerValue]) forKeyPath:keyPath];
                                }];
}

- (void)LL_showDoubleAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:[self valueForKeyPath:keyPath]]
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:@([newText doubleValue]) forKeyPath:keyPath];
                                }];
}

- (void)LL_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIColor *color = [self valueForKeyPath:keyPath];
    if (color && ![color isKindOfClass:[UIColor class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[color LL_hexString]
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[weakSelf LL_colorFromString:newText originalColor:color] forKeyPath:keyPath];
                                }];
}

- (void)LL_showFrameAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGRect([value CGRectValue])
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[NSValue valueWithCGRect:[weakSelf LL_rectFromString:newText originalRect:[value CGRectValue]]] forKeyPath:keyPath];
                                }];
}

- (void)LL_showPointAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGPoint([value CGPointValue])
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[NSValue valueWithCGPoint:[weakSelf LL_pointFromString:newText orginalPoint:[value CGPointValue]]] forKeyPath:keyPath];
                                }];
}

- (void)LL_showEdgeInsetsAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromUIEdgeInsets([value UIEdgeInsetsValue])
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[NSValue valueWithUIEdgeInsets:[weakSelf LL_insetsFromString:newText originalInsets:[value UIEdgeInsetsValue]]] forKeyPath:keyPath];
                                }];
}

- (void)LL_showTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[self valueForKeyPath:keyPath]
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:newText forKeyPath:keyPath];
                                }];
}

- (void)LL_showAttributeTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSAttributedString *attribute = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:attribute.string
                                handler:^(NSString *newText) {
                                    NSMutableAttributedString *mutAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attribute];
                                    [mutAttribute replaceCharactersInRange:NSMakeRange(0, attribute.string.length) withString:newText];
                                    [weakSelf setValue:[mutAttribute copy] forKeyPath:keyPath];
                                }];
}

- (void)LL_showSizeAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGSize([value CGSizeValue])
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[NSValue valueWithCGSize:[weakSelf LL_sizeFromString:newText originalSize:[value CGSizeValue]]] forKeyPath:keyPath];
                                }];
}

- (void)LL_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIFont *font = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(font.pointSize)]
                                handler:^(NSString *newText) {
                                    [weakSelf setValue:[font fontWithSize:[newText doubleValue]] forKeyPath:keyPath];
                                }];
}

- (void)LL_showDateAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    NSDate *date = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3]
                                handler:^(NSString *newText) {
                                    NSDate *newDate = [LLFormatterTool dateFromString:newText style:FormatterToolDateStyle3];
                                    if (newDate) {
                                        [weakSelf setValue:newDate forKeyPath:keyPath];
                                    }
                                }];
}

- (void)LL_showTextFieldAlertWithText:(NSString *)text handler:(void (^)(NSString *newText))handler {
    __weak typeof(self) weakSelf = self;
    [[LLTool keyWindow]
            .rootViewController.LL_currentShowingViewController LL_showTextFieldAlertControllerWithMessage:LLLocalizedString(@"hierarchy.change.property")
                                                                                                      text:text
                                                                                                   handler:^(NSString *newText) {
                                                                                                       if (handler) {
                                                                                                           handler(newText);
                                                                                                       }
                                                                                                       [weakSelf LL_postDebugToolChangeHierarchyNotification];
                                                                                                   }];
}

- (void)LL_showActionSheetWithActions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    __weak typeof(self) weakSelf = self;
    [[LLTool keyWindow]
            .rootViewController.LL_currentShowingViewController LL_showActionSheetWithTitle:LLLocalizedString(@"hierarchy.change.property")
                                                                                    actions:actions
                                                                              currentAction:currentAction
                                                                                 completion:^(NSInteger index) {
                                                                                     if (completion) {
                                                                                         completion(index);
                                                                                     }
                                                                                     [weakSelf LL_postDebugToolChangeHierarchyNotification];
                                                                                 }];
}

- (void)LL_postDebugToolChangeHierarchyNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolChangeHierarchyNotification object:self];
}

- (void)LL_replaceAttributeString:(NSString *)newString key:(NSString *)key {
    NSAttributedString *string = [self valueForKey:key];
    if (string && ![string isKindOfClass:[NSAttributedString class]]) {
        [LLTool log:[NSString stringWithFormat:@"KeyPath:%@ isn't a NSAttributedString or nil", key]];
        return;
    }
    NSMutableAttributedString *attribute = string ? [[NSMutableAttributedString alloc] initWithAttributedString:string] : [[NSMutableAttributedString alloc] init];
    [attribute replaceCharactersInRange:NSMakeRange(0, string.length) withString:newString];
    [self setValue:string forKey:key];
}

@end

@implementation UIView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Layer" detailTitle:self.layer.description] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Layer Class" detailTitle:NSStringFromClass(self.layer.class)];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Content Model" detailTitle:[LLEnumDescription viewContentModeDescription:self.contentMode]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription viewContentModeDescriptions]
                                  currentAction:[LLEnumDescription viewContentModeDescription:weakSelf.contentMode]
                                     completion:^(NSInteger index) {
                                         weakSelf.contentMode = index;
                                     }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.tag]];
    model4.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:@"User Interaction" isOn:self.isUserInteractionEnabled] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.userInteractionEnabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Multiple Touch" isOn:self.isMultipleTouchEnabled];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.multipleTouchEnabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(self.alpha)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"alpha"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.backgroundColor]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    model9.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model9];

    LLTitleSwitchCellModel *model10 = [[LLTitleSwitchCellModel modelWithTitle:@"Drawing" detailTitle:@"Opaque" isOn:self.isOpaque] noneInsets];
    model10.changePropertyBlock = ^(id obj) {
        weakSelf.opaque = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model10];

    LLTitleSwitchCellModel *model11 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Hidden" isOn:self.isHidden] noneInsets];
    model11.changePropertyBlock = ^(id obj) {
        weakSelf.hidden = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clears Graphics Context" isOn:self.clearsContextBeforeDrawing] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.clearsContextBeforeDrawing = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clip To Bounds" isOn:self.clipsToBounds] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.clipsToBounds = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Autoresizes Subviews" isOn:self.autoresizesSubviews];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.autoresizesSubviews = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Trait Collection" detailTitle:nil] noneInsets];
    [settings addObject:model15];

    if (@available(iOS 12.0, *)) {
        LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription userInterfaceStyleDescription:self.traitCollection.userInterfaceStyle]] noneInsets];
        [settings addObject:model16];
    }

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@", [LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.verticalSizeClass]]] noneInsets];
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@", [LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.horizontalSizeClass]]] noneInsets];
    [settings addObject:model18];

    if (@available(iOS 10.0, *)) {
        LLDetailTitleCellModel *model19 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription traitEnvironmentLayoutDirectionDescription:self.traitCollection.layoutDirection]];
        [settings addObject:model19];
    }

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

- (NSArray<LLTitleCellCategoryModel *> *)LL_sizeHierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Frame" detailTitle:[self LL_hierarchyPointDescription:self.frame.origin]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchySizeDescription:self.frame.size]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Bounds" detailTitle:[self LL_hierarchyPointDescription:self.bounds.origin]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"bounds"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchySizeDescription:self.bounds.size]] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Center" detailTitle:[self LL_hierarchyPointDescription:self.center]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"center"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Position" detailTitle:[self LL_hierarchyPointDescription:self.layer.position]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.position"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Z Position" detailTitle:[LLFormatterTool formatNumber:@(self.layer.zPosition)]];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.zPosition"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Anchor Point" detailTitle:[self LL_hierarchyPointDescription:self.layer.anchorPoint]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.anchorPoint"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Anchor Point Z" detailTitle:[LLFormatterTool formatNumber:@(self.layer.anchorPointZ)]];
    model9.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.anchorPointZ"];
    };
    [settings addObject:model9];

    LLTitleCellModel *lastConstrainModel = nil;

    for (NSLayoutConstraint *constrain in self.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        NSString *constrainDesc = [self LL_hierarchyLayoutConstraintDescription:constrain];
        if (constrainDesc) {
            LLDetailTitleCellModel *mod = [[LLDetailTitleCellModel modelWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
            __weak NSLayoutConstraint *cons = constrain;
            mod.block = ^{
                [weakSelf LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)]
                                                handler:^(NSString *newText) {
                                                    cons.constant = [newText doubleValue];
                                                    [weakSelf setNeedsLayout];
                                                }];
            };
            [settings addObject:mod];
            lastConstrainModel = mod;
        }
    }

    for (NSLayoutConstraint *constrain in self.superview.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        if (constrain.firstItem == self || constrain.secondItem == self) {
            NSString *constrainDesc = [self LL_hierarchyLayoutConstraintDescription:constrain];
            if (constrainDesc) {
                LLDetailTitleCellModel *mod = [[LLDetailTitleCellModel modelWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
                __weak NSLayoutConstraint *cons = constrain;
                mod.block = ^{
                    [weakSelf LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)]
                                                    handler:^(NSString *newText) {
                                                        cons.constant = [newText doubleValue];
                                                        [weakSelf setNeedsLayout];
                                                    }];
                };
                [settings addObject:mod];
                lastConstrainModel = mod;
            }
        }
    }

    [lastConstrainModel normalInsets];

    return @[[LLTitleCellCategoryModel modelWithTitle:@"View" items:settings]];
}

- (NSString *)LL_hierarchyLayoutConstraintDescription:(NSLayoutConstraint *)constraint {
    NSMutableString *string = [[NSMutableString alloc] init];
    if (constraint.firstItem == self) {
        [string appendString:@"self."];
    } else if (constraint.firstItem == self.superview) {
        [string appendString:@"superview."];
    } else {
        [string appendFormat:@"%@.", NSStringFromClass([constraint.firstItem class])];
    }
    [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.firstAttribute]];
    [string appendString:[LLEnumDescription layoutRelationDescription:constraint.relation]];
    if (constraint.secondItem) {
        if (constraint.secondItem == self) {
            [string appendString:@"self."];
        } else if (constraint.secondItem == self.superview) {
            [string appendString:@"superview."];
        } else {
            [string appendFormat:@"%@.", NSStringFromClass([constraint.secondItem class])];
        }
        [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.secondAttribute]];
        if (constraint.multiplier != 1) {
            [string appendFormat:@" * %@", [LLFormatterTool formatNumber:@(constraint.multiplier)]];
        }
        if (constraint.constant > 0) {
            [string appendFormat:@" + %@", [LLFormatterTool formatNumber:@(constraint.constant)]];
        } else if (constraint.constant < 0) {
            [string appendFormat:@" - %@", [LLFormatterTool formatNumber:@(fabs(constraint.constant))]];
        }
    } else if (constraint.constant) {
        [string appendString:[LLFormatterTool formatNumber:@(constraint.constant)]];
    } else {
        return nil;
    }

    [string appendFormat:@" @ %@", [LLFormatterTool formatNumber:@(constraint.priority)]];
    return string;
}

@end

@implementation UILabel (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [LLEnumDescription textAlignmentDescription:self.textAlignment]]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments]
                                  currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                     completion:^(NSInteger index) {
                                         weakSelf.textAlignment = index;
                                     }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfLines]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfLines"];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Enabled" isOn:self.isEnabled] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Highlighted" isOn:self.isHighlighted];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [[LLDetailTitleCellModel modelWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@", [LLEnumDescription baselineAdjustmentDescription:self.baselineAdjustment]]] noneInsets];
    model9.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription baselineAdjustments]
                                  currentAction:[LLEnumDescription baselineAdjustmentDescription:weakSelf.baselineAdjustment]
                                     completion:^(NSInteger index) {
                                         weakSelf.baselineAdjustment = index;
                                     }];
    };
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription lineBreaks]
                                  currentAction:[LLEnumDescription lineBreakModeDescription:weakSelf.lineBreakMode]
                                     completion:^(NSInteger index) {
                                         weakSelf.lineBreakMode = index;
                                     }];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:@"Min Font Scale" detailTitle:[LLFormatterTool formatNumber:@(self.minimumScaleFactor)]];
    model11.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumScaleFactor"];
    };
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [[LLDetailTitleCellModel modelWithTitle:@"Highlighted" detailTitle:[self LL_hierarchyColorDescription:self.highlightedTextColor]] noneInsets];
    model12.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"highlightedTextColor"];
    };
    [settings addObject:model12];

    LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:self.shadowColor]] noneInsets];
    model13.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"shadowColor"];
    };
    [settings addObject:model13];

    LLDetailTitleCellModel *model14 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.shadowOffset]];
    model14.block = ^{
        [weakSelf LL_showSizeAlertAndAutomicSetWithKeyPath:@"shadowOffset"];
    };
    [settings addObject:model14];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Label" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIControl (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [LLEnumDescription controlContentHorizontalAlignmentDescription:self.contentHorizontalAlignment]]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription controlContentHorizontalAlignments]
                                  currentAction:[LLEnumDescription controlContentHorizontalAlignmentDescription:weakSelf.contentHorizontalAlignment]
                                     completion:^(NSInteger index) {
                                         weakSelf.contentHorizontalAlignment = index;
                                     }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [LLEnumDescription controlContentVerticalAlignmentDescription:self.contentVerticalAlignment]]];
    model2.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription controlContentVerticalAlignments]
                                  currentAction:[LLEnumDescription controlContentVerticalAlignmentDescription:weakSelf.contentVerticalAlignment]
                                     completion:^(NSInteger index) {
                                         weakSelf.contentVerticalAlignment = index;
                                     }];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:@"Content" detailTitle:self.isSelected ? @"Selected" : @"Not Selected" isOn:self.isSelected] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.selected = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:self.isEnabled ? @"Enabled" : @"Not Enabled" isOn:self.isEnabled] noneInsets];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" isOn:self.isHighlighted];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Control" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIButton (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Type" detailTitle:[LLEnumDescription buttonTypeDescription:self.buttonType]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"State" detailTitle:[LLEnumDescription controlStateDescription:self.state]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Title" detailTitle:[self LL_hierarchyTextDescription:self.currentTitle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:weakSelf.currentTitle
                                        handler:^(NSString *newText) {
                                            [weakSelf setTitle:newText forState:weakSelf.state];
                                        }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Text Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleColor]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:[weakSelf.currentTitleColor LL_hexString]
                                        handler:^(NSString *newText) {
                                            [weakSelf setTitleColor:[weakSelf LL_colorFromString:newText originalColor:weakSelf.currentTitleColor] forState:weakSelf.state];
                                        }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleShadowColor]];
    model6.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:[weakSelf.currentTitleShadowColor LL_hexString]
                                        handler:^(NSString *newText) {
                                            [weakSelf setTitleShadowColor:[weakSelf LL_colorFromString:newText originalColor:weakSelf.currentTitleShadowColor] forState:weakSelf.state];
                                        }];
    };
    [settings addObject:model6];

    id target = self.allTargets.allObjects.firstObject;
    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@", target] : @"<nil>"] noneInsets];
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [LLDetailTitleCellModel modelWithTitle:@"Action" detailTitle:[self LL_hierarchyTextDescription:[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject]];
    ;
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.currentImage]];
    [settings addObject:model9];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.titleShadowOffset]] noneInsets];
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

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Content Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.contentEdgeInsets]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"contentEdgeInsets"];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.contentEdgeInsets]] noneInsets];
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Title Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.titleEdgeInsets]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"titleEdgeInsets"];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.titleEdgeInsets]] noneInsets];
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [[LLDetailTitleCellModel modelWithTitle:@"Image Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.imageEdgeInsets]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"imageEdgeInsets"];
    };
    [settings addObject:model20];

    LLDetailTitleCellModel *model21 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.imageEdgeInsets]];
    [settings addObject:model21];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Button" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIImageView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.image]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Highlighted" detailTitle:[self LL_hierarchyImageDescription:self.highlightedImage]];
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [LLTitleSwitchCellModel modelWithTitle:@"State" detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" isOn:self.isHighlighted];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Image View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITextField (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Allows Editing Attributes" isOn:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments]
                                  currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                     completion:^(NSInteger index) {
                                         weakSelf.textAlignment = index;
                                     }];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyTextDescription:self.placeholder ?: self.attributedPlaceholder.string]];
    model7.block = ^{
        if (weakSelf.placeholder) {
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
        } else {
            [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedPlaceholder"];
        }
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.background]] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Disabled" detailTitle:[self LL_hierarchyImageDescription:self.disabledBackground]];
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [LLDetailTitleCellModel modelWithTitle:@"Border Style" detailTitle:[LLEnumDescription textBorderStyleDescription:self.borderStyle]];
    model10.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textBorderStyles]
                                  currentAction:[LLEnumDescription textBorderStyleDescription:weakSelf.borderStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.borderStyle = index;
                                     }];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [[LLDetailTitleCellModel modelWithTitle:@"Clear Button" detailTitle:[LLEnumDescription textFieldViewModeDescription:self.clearButtonMode]] noneInsets];
    model11.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textFieldViewModes]
                                  currentAction:[LLEnumDescription textFieldViewModeDescription:weakSelf.clearButtonMode]
                                     completion:^(NSInteger index) {
                                         weakSelf.clearButtonMode = index;
                                     }];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clear when editing begins" isOn:self.clearsOnBeginEditing];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.clearsOnBeginEditing = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
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
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model15.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                  currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocapitalizationType = index;
                                     }];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                  currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocorrectionType = index;
                                     }];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                  currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardType = index;
                                     }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardAppearances]
                                  currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardAppearance = index;
                                     }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription returnKeyTypes]
                                  currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType]
                                     completion:^(NSInteger index) {
                                         weakSelf.returnKeyType = index;
                                     }];
    };
    [settings addObject:model19];

    LLTitleSwitchCellModel *model20 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Auto-enable Return Key" isOn:self.enablesReturnKeyAutomatically] noneInsets];
    model20.changePropertyBlock = ^(id obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model20];

    LLTitleSwitchCellModel *model21 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Secure Entry" isOn:self.isSecureTextEntry];
    model21.changePropertyBlock = ^(id obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model21];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Text Field" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISegmentedControl (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLTitleSwitchCellModel *model1 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:self.isMomentary ? @"Momentary" : @"Persistent Selection" isOn:self.isMomentary] noneInsets];
    model1.changePropertyBlock = ^(id obj) {
        weakSelf.momentary = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Segments" detailTitle:[NSString stringWithFormat:@"%ld", (unsigned long)self.numberOfSegments]];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Selected Index" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.selectedSegmentIndex]] noneInsets];
    model3.block = ^{
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < weakSelf.numberOfSegments; i++) {
            [actions addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        [weakSelf LL_showActionSheetWithActions:actions
                                  currentAction:[NSString stringWithFormat:@"%ld", (long)weakSelf.selectedSegmentIndex]
                                     completion:^(NSInteger index) {
                                         weakSelf.selectedSegmentIndex = index;
                                     }];
    };
    [settings addObject:model3];

#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Large title" detailTitle:[self LL_hierarchyTextDescription:self.largeContentTitle]] noneInsets];
        model4.block = ^{
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"largeContentTitle"];
        };
        [settings addObject:model4];

        LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.largeContentImage]] noneInsets];
        [settings addObject:model5];
    }
#endif

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Selected" detailTitle:[self isEnabledForSegmentAtIndex:self.selectedSegmentIndex] ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Offset" detailTitle:[self LL_hierarchySizeDescription:[self contentOffsetForSegmentAtIndex:self.selectedSegmentIndex]]] noneInsets];
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:@"Size Mode" detailTitle:self.apportionsSegmentWidthsByContent ? @"Proportional to Content" : @"Equal Widths" isOn:self.apportionsSegmentWidthsByContent] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.apportionsSegmentWidthsByContent = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Width" detailTitle:[LLFormatterTool formatNumber:@([self widthForSegmentAtIndex:self.selectedSegmentIndex])]];
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Segmented Control" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISlider (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Current" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Min Image" detailTitle:[self LL_hierarchyImageDescription:self.minimumValueImage]] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [LLDetailTitleCellModel modelWithTitle:@"Max Image" detailTitle:[self LL_hierarchyImageDescription:self.maximumValueImage]];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Min Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.minimumTrackTintColor]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"minimumTrackTintColor"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Max Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.maximumTrackTintColor]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"maximumTrackTintColor"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [LLDetailTitleCellModel modelWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:@"Events" detailTitle:@"Continuous Update" isOn:self.isContinuous];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Slider" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISwitch (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLTitleSwitchCellModel *model1 = [[LLTitleSwitchCellModel modelWithTitle:@"State" isOn:self.isOn] noneInsets];
    model1.changePropertyBlock = ^(id obj) {
        weakSelf.on = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"On Tint" detailTitle:[self LL_hierarchyColorDescription:self.onTintColor]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"onTintColor"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.thumbTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"thumbTintColor"];
    };
    [settings addObject:model3];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Switch" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIActivityIndicatorView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription activityIndicatorViewStyleDescription:self.activityIndicatorViewStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription activityIndicatorViewStyles]
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

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.color]] noneInsets];
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
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Hides When Stopped" isOn:self.hidesWhenStopped];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.hidesWhenStopped = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Activity Indicator View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIProgressView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription progressViewStyleDescription:self.progressViewStyle]];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription progressViewStyles]
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

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Progress Tint" detailTitle:[self LL_hierarchyColorDescription:self.progressTintColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"progressTintColor"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.trackTintColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"trackTintColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Progress Image" detailTitle:[self LL_hierarchyImageDescription:self.progressImage]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Track Image" detailTitle:[self LL_hierarchyImageDescription:self.trackImage]];
    [settings addObject:model6];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Progress View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIPageControl (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Pages" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfPages]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfPages"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Current Page" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.currentPage]] noneInsets];
    model2.block = ^{
        if (weakSelf.numberOfPages < 10) {
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < weakSelf.numberOfPages; i++) {
                [actions addObject:[NSString stringWithFormat:@"%ld", (long)i]];
            }
            [weakSelf LL_showActionSheetWithActions:actions
                                      currentAction:[NSString stringWithFormat:@"%ld", (long)weakSelf.currentPage]
                                         completion:^(NSInteger index) {
                                             weakSelf.currentPage = index;
                                         }];
        } else {
            [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"currentPage"];
        }
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Hides for Single Page" isOn:self.hidesForSinglePage] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.hidesForSinglePage = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Defers Page Display" isOn:self.defersCurrentPageDisplay];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.defersCurrentPageDisplay = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Tint Color" detailTitle:[self LL_hierarchyColorDescription:self.pageIndicatorTintColor]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"pageIndicatorTintColor"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Current Page" detailTitle:[self LL_hierarchyColorDescription:self.currentPageIndicatorTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"currentPageIndicatorTintColor"];
    };
    [settings addObject:model6];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Page Control" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIStepper (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Value" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Step" detailTitle:[LLFormatterTool formatNumber:@(self.stepValue)]];
    model4.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"stepValue"];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Autorepeat" isOn:self.autorepeat] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.autorepeat = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Continuous" isOn:self.isContinuous] noneInsets];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Wrap" isOn:self.wraps];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.wraps = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Stepper" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIScrollView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription scrollViewIndicatorStyles]
                                  currentAction:[LLEnumDescription scrollViewIndicatorStyleDescription:weakSelf.indicatorStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.indicatorStyle = index;
                                     }];
    };
    [settings addObject:model1];

    LLTitleSwitchCellModel *model2 = [[LLTitleSwitchCellModel modelWithTitle:@"Indicators" detailTitle:@"Shows Horizontal Indicator" isOn:self.showsHorizontalScrollIndicator] noneInsets];
    model2.changePropertyBlock = ^(id obj) {
        weakSelf.showsHorizontalScrollIndicator = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Vertical Indicator" isOn:self.showsVerticalScrollIndicator];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.showsVerticalScrollIndicator = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLTitleSwitchCellModel *model4 = [[LLTitleSwitchCellModel modelWithTitle:@"Scrolling" detailTitle:@"Enable" isOn:self.isScrollEnabled] noneInsets];
    model4.changePropertyBlock = ^(id obj) {
        weakSelf.scrollEnabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Paging" isOn:self.isPagingEnabled] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.pagingEnabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Direction Lock" isOn:self.isDirectionalLockEnabled];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.directionalLockEnabled = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Bounce" detailTitle:@"Bounces" isOn:self.bounces] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.bounces = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Bounce Horizontal" isOn:self.alwaysBounceHorizontal] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.alwaysBounceHorizontal = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Bounce Vertical" isOn:self.alwaysBounceVertical];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.alwaysBounceVertical = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
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

    LLDetailTitleCellModel *model12 = [[LLDetailTitleCellModel modelWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@", [self LL_hierarchyBoolDescription:self.isZoomBouncing]]] noneInsets];
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Delays Content Touches" isOn:self.delaysContentTouches] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.delaysContentTouches = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Cancellable Content Touches" isOn:self.canCancelContentTouches];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.canCancelContentTouches = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
    model15.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription scrollViewKeyboardDismissModes]
                                  currentAction:[LLEnumDescription scrollViewKeyboardDismissModeDescription:weakSelf.keyboardDismissMode]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardDismissMode = index;
                                     }];
    };
    [settings addObject:model15];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Scroll View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITableView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfSections]] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription tableViewStyleDescription:self.style]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Separator" detailTitle:[LLEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellSeparatorStyles]
                                  currentAction:[LLEnumDescription tableViewCellSeparatorStyleDescription:weakSelf.separatorStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.separatorStyle = index;
                                     }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.separatorColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"separatorColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]] noneInsets];
    [settings addObject:model8];

    if (@available(iOS 11.0, *)) {
        LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        model9.block = ^{
            [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewSeparatorInsetReferences]
                                      currentAction:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:weakSelf.separatorInsetReference]
                                         completion:^(NSInteger index) {
                                             weakSelf.separatorInsetReference = index;
                                         }];
        };
        [settings addObject:model9];
    }

    LLTitleSwitchCellModel *model10 = [[LLTitleSwitchCellModel modelWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled" isOn:self.allowsSelection] noneInsets];
    model10.changePropertyBlock = ^(id obj) {
        weakSelf.allowsSelection = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model10];

    LLTitleSwitchCellModel *model11 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@", self.allowsMultipleSelection ? @"" : @"Disabled"] isOn:self.allowsMultipleSelection] noneInsets];
    model11.changePropertyBlock = ^(id obj) {
        weakSelf.allowsMultipleSelection = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled" isOn:self.allowsSelectionDuringEditing] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.allowsSelectionDuringEditing = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@", self.allowsMultipleSelectionDuringEditing ? @"" : @"Disabled"] isOn:self.allowsMultipleSelectionDuringEditing];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.allowsMultipleSelectionDuringEditing = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLDetailTitleCellModel *model14 = [[LLDetailTitleCellModel modelWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.sectionIndexMinimumDisplayRowCount]] noneInsets];
    model14.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"sectionIndexMinimumDisplayRowCount"];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexColor]] noneInsets];
    model15.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexColor"];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexBackgroundColor]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexBackgroundColor"];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [LLDetailTitleCellModel modelWithTitle:@"Tracking" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexTrackingBackgroundColor]];
    model17.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexTrackingBackgroundColor"];
    };
    model17.block = ^{

    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Row Height" detailTitle:[LLFormatterTool formatNumber:@(self.rowHeight)]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"rowHeight"];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Section Header" detailTitle:[LLFormatterTool formatNumber:@(self.sectionHeaderHeight)]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionHeaderHeight"];
    };
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [LLDetailTitleCellModel modelWithTitle:@"Section Footer" detailTitle:[LLFormatterTool formatNumber:@(self.sectionFooterHeight)]];
    model20.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionFooterHeight"];
    };
    [settings addObject:model20];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Table View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITableViewCell (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.imageView.image]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Identifier" detailTitle:[self LL_hierarchyTextDescription:self.reuseIdentifier]];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Selection" detailTitle:[LLEnumDescription tableViewCellSelectionStyleDescription:self.selectionStyle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellSelectionStyles]
                                  currentAction:[LLEnumDescription tableViewCellSelectionStyleDescription:weakSelf.selectionStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.selectionStyle = index;
                                     }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Accessory" detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.accessoryType]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes]
                                  currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.accessoryType]
                                     completion:^(NSInteger index) {
                                         weakSelf.accessoryType = index;
                                     }];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [LLDetailTitleCellModel modelWithTitle:@"Editing Acc." detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.editingAccessoryType]];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes]
                                  currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.editingAccessoryType]
                                     completion:^(NSInteger index) {
                                         weakSelf.editingAccessoryType = index;
                                     }];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Indentation" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.indentationLevel]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"indentationLevel"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLFormatterTool formatNumber:@(self.indentationWidth)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"indentationWidth"];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Indent While Editing" isOn:self.shouldIndentWhileEditing] noneInsets];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.shouldIndentWhileEditing = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model8];

    LLTitleSwitchCellModel *model9 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Re-order Controls" isOn:self.showsReorderControl];
    model9.changePropertyBlock = ^(id obj) {
        weakSelf.showsReorderControl = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]];
    [settings addObject:model11];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Table View Cell" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UICollectionView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfSections]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Layout" detailTitle:[self LL_hierarchyObjectDescription:self.collectionViewLayout]];
    [settings addObject:model4];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Collection View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UICollectionReusableView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Identifier" detailTitle:[self LL_hierarchyTextDescription:self.reuseIdentifier]] noneInsets];
    [settings addObject:model1];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Collection Reusable View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITextView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];

    LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Allows Editing Attributes" isOn:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]];
    model6.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments]
                                  currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment]
                                     completion:^(NSInteger index) {
                                         weakSelf.textAlignment = index;
                                     }];
    };
    [settings addObject:model6];

    LLTitleSwitchCellModel *model7 = [[LLTitleSwitchCellModel modelWithTitle:@"Behavior" detailTitle:@"Editable" isOn:self.isEditable] noneInsets];
    model7.changePropertyBlock = ^(id obj) {
        weakSelf.editable = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model7];

    LLTitleSwitchCellModel *model8 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Selectable" isOn:self.isSelectable];
    model8.changePropertyBlock = ^(id obj) {
        weakSelf.selectable = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
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
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                  currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocapitalizationType = index;
                                     }];
    };
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                  currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocorrectionType = index;
                                     }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                  currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardType = index;
                                     }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [[LLDetailTitleCellModel modelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardAppearances]
                                  currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardAppearance = index;
                                     }];
    };
    [settings addObject:model19];

    LLDetailTitleCellModel *model20 = [[LLDetailTitleCellModel modelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription returnKeyTypes]
                                  currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType]
                                     completion:^(NSInteger index) {
                                         weakSelf.returnKeyType = index;
                                     }];
    };
    [settings addObject:model20];

    LLTitleSwitchCellModel *model21 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Auto-enable Return Key" isOn:self.enablesReturnKeyAutomatically] noneInsets];
    model21.changePropertyBlock = ^(id obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model21];

    LLTitleSwitchCellModel *model22 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Secure Entry" isOn:self.isSecureTextEntry];
    model22.changePropertyBlock = ^(id obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model22];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Text View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIDatePicker (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Mode" detailTitle:[LLEnumDescription datePickerModeDescription:self.datePickerMode]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription datePickerModes]
                                  currentAction:[LLEnumDescription datePickerModeDescription:weakSelf.datePickerMode]
                                     completion:^(NSInteger index) {
                                         weakSelf.datePickerMode = index;
                                     }];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Locale Identifier" detailTitle:self.locale.localeIdentifier] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Interval" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.minuteInterval]];
    model3.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"minuteInterval"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Date" detailTitle:[self LL_hierarchyDateDescription:self.date]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"date"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Min Date" detailTitle:[self LL_hierarchyDateDescription:self.minimumDate]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"minimumDate"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Max Date" detailTitle:[self LL_hierarchyDateDescription:self.maximumDate]];
    model6.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"maximumDate"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Count Down" detailTitle:[LLFormatterTool formatNumber:@(self.countDownDuration)]];
    [settings addObject:model7];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Date Picker" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIPickerView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model1];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Picker View" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UINavigationBar (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles]
                                  currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.barStyle = index;
                                     }];
    };
    [settings addObject:model1];

    LLTitleSwitchCellModel *model2 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model2];

    if (@available(iOS 11.0, *)) {
        LLTitleSwitchCellModel *model3 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Prefers Large Titles" isOn:self.prefersLargeTitles] noneInsets];
        model3.changePropertyBlock = ^(id obj) {
            weakSelf.prefersLargeTitles = [obj boolValue];
            [weakSelf LL_postDebugToolChangeHierarchyNotification];
        };
        [settings addObject:model3];
    }

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow Image" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Back Image" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorImage]] noneInsets];
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Back Mask" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorTransitionMaskImage]];
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Title Attr." detailTitle:nil] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [[LLDetailTitleCellModel modelWithTitle:@"Title Font" detailTitle:[self LL_hierarchyObjectDescription:self.titleTextAttributes[NSFontAttributeName]]] noneInsets];
    if (self.titleTextAttributes[NSFontAttributeName]) {
        model9.block = ^{
            __block UIFont *font = weakSelf.titleTextAttributes[NSFontAttributeName];
            if (!font) {
                return;
            }
            [weakSelf LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [LLFormatterTool formatNumber:@(font.pointSize)]]
                                            handler:^(NSString *newText) {
                                                NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.titleTextAttributes];
                                                attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                                                weakSelf.titleTextAttributes = [attributes copy];
                                            }];
        };
    }
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Title Color" detailTitle:[self LL_hierarchyColorDescription:self.titleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
    [settings addObject:model10];

    NSShadow *shadow = self.titleTextAttributes[NSShadowAttributeName];
    if (![shadow isKindOfClass:[NSShadow class]]) {
        shadow = nil;
    }

    LLDetailTitleCellModel *model11 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
    [settings addObject:model11];

    LLDetailTitleCellModel *model12 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:shadow.shadowOffset]];
    [settings addObject:model12];

    if (@available(iOS 11.0, *)) {
        LLDetailTitleCellModel *model13 = [[LLDetailTitleCellModel modelWithTitle:@"Large Title Attr." detailTitle:nil] noneInsets];
        [settings addObject:model13];

        LLDetailTitleCellModel *model14 = [[LLDetailTitleCellModel modelWithTitle:@"Title Font" detailTitle:[self LL_hierarchyColorDescription:self.largeTitleTextAttributes[NSFontAttributeName]]] noneInsets];
        if (self.largeTitleTextAttributes[NSFontAttributeName]) {
            model14.block = ^{
                __block UIFont *font = weakSelf.largeTitleTextAttributes[NSFontAttributeName];
                if (!font) {
                    return;
                }
                [weakSelf LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@", [LLFormatterTool formatNumber:@(font.pointSize)]]
                                                handler:^(NSString *newText) {
                                                    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.largeTitleTextAttributes];
                                                    attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                                                    weakSelf.largeTitleTextAttributes = [attributes copy];
                                                }];
            };
        }
        [settings addObject:model14];

        LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Title Color" detailTitle:[self LL_hierarchyColorDescription:self.largeTitleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
        [settings addObject:model15];

        shadow = self.largeTitleTextAttributes[NSShadowAttributeName];
        if (![shadow isKindOfClass:[NSShadow class]]) {
            shadow = nil;
        }

        LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
        [settings addObject:model16];

        LLDetailTitleCellModel *model17 = [LLDetailTitleCellModel modelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:shadow.shadowOffset]];
        [settings addObject:model17];
    }

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Navigation Bar" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIToolbar (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles]
                                  currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.barStyle = index;
                                     }];
    };
    [settings addObject:model1];

    LLTitleSwitchCellModel *model2 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model3];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Tool Bar" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UITabBar (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Shadow" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Selection" detailTitle:[self LL_hierarchyImageDescription:self.selectionIndicatorImage]];
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles]
                                  currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.barStyle = index;
                                     }];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [LLDetailTitleCellModel modelWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Style" detailTitle:[LLEnumDescription tabBarItemPositioningDescription:self.itemPositioning]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tabBarItemPositionings]
                                  currentAction:[LLEnumDescription tabBarItemPositioningDescription:weakSelf.itemPositioning]
                                     completion:^(NSInteger index) {
                                         weakSelf.itemPositioning = index;
                                     }];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Item Width" detailTitle:[LLFormatterTool formatNumber:@(self.itemWidth)]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemWidth"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Item Spacing" detailTitle:[LLFormatterTool formatNumber:@(self.itemSpacing)]];
    model9.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemSpacing"];
    };
    [settings addObject:model9];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Tab Bar" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UISearchBar (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyTextDescription:self.placeholder]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
    };
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [LLDetailTitleCellModel modelWithTitle:@"Prompt" detailTitle:[self LL_hierarchyTextDescription:self.prompt]];
    model3.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"prompt"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:@"Search Style" detailTitle:[LLEnumDescription searchBarStyleDescription:self.searchBarStyle]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription searchBarStyles]
                                  currentAction:[LLEnumDescription searchBarStyleDescription:weakSelf.searchBarStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.searchBarStyle = index;
                                     }];
    };
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Bar Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles]
                                  currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle]
                                     completion:^(NSInteger index) {
                                         weakSelf.barStyle = index;
                                     }];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Translucent" isOn:self.isTranslucent] noneInsets];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Scope Bar" detailTitle:[self LL_hierarchyImageDescription:self.scopeBarBackgroundImage]];
    [settings addObject:model9];

    LLDetailTitleCellModel *model10 = [[LLDetailTitleCellModel modelWithTitle:@"Text Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchTextPositionAdjustment]] noneInsets];
    [settings addObject:model10];

    LLDetailTitleCellModel *model11 = [LLDetailTitleCellModel modelWithTitle:@"BG Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchFieldBackgroundPositionAdjustment]];
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:@"Options" detailTitle:@"Shows Search Results Button" isOn:self.showsSearchResultsButton] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.showsSearchResultsButton = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Bookmarks Button" isOn:self.showsBookmarkButton] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.showsBookmarkButton = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Cancel Button" isOn:self.showsCancelButton] noneInsets];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.showsCancelButton = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLTitleSwitchCellModel *model15 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Shows Scope Bar" isOn:self.showsScopeBar];
    model15.changePropertyBlock = ^(id obj) {
        weakSelf.showsScopeBar = [obj boolValue];
        [weakSelf LL_postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model15];

    LLDetailTitleCellModel *model16 = [LLDetailTitleCellModel modelWithTitle:@"Scope Titles" detailTitle:[self LL_hierarchyObjectDescription:self.scopeButtonTitles]];
    [settings addObject:model16];

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes]
                                  currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocapitalizationType = index;
                                     }];
    };
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes]
                                  currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType]
                                     completion:^(NSInteger index) {
                                         weakSelf.autocorrectionType = index;
                                     }];
    };
    [settings addObject:model18];

    LLDetailTitleCellModel *model19 = [LLDetailTitleCellModel modelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes]
                                  currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType]
                                     completion:^(NSInteger index) {
                                         weakSelf.keyboardType = index;
                                     }];
    };
    [settings addObject:model19];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Search Bar" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end

@implementation UIWindow (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Key Window %@", [self LL_hierarchyBoolDescription:self.isKeyWindow]]] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Root Controller" detailTitle:[self LL_hierarchyObjectDescription:self.rootViewController]];
    [settings addObject:model2];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Window" items:settings];

    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end
