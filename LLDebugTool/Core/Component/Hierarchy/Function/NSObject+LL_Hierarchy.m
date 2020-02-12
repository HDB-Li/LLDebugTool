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

#import "LLTitleCellCategoryModel.h"
#import "LLEnumDescription.h"
#import "LLInternalMacros.h"
#import "LLTitleCellModel.h"
#import "LLFormatterTool.h"
#import "LLConfig.h"
#import "LLConst.h"
#import "LLTool.h"

#import "UIViewController+LL_Utils.h"
#import "UIColor+LL_Utils.h"

NSNotificationName const LLHierarchyChangeNotificationName = @"LLHierarchyChangeNotificationName";

@implementation NSObject (LL_Hierarchy)

- (NSArray <LLTitleCellCategoryModel *>*)LL_hierarchyCategoryModels {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Class Name" detailTitle:NSStringFromClass(self.class)] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p",self]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Description" detailTitle:self.description] noneInsets];
    [settings addObject:model3];
    
    return @[[[LLTitleCellCategoryModel alloc] initWithTitle:@"Object" items:settings]];
}

- (NSString *)LL_hierarchyColorDescription:(UIColor *_Nullable)color {
    if (!color) {
        return @"<nil color>";
    }
    
    NSArray *rgba = [color LL_RGBA];
    NSString *rgb = [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [LLFormatterTool formatNumber:rgba[0]], [LLFormatterTool formatNumber:rgba[1]], [LLFormatterTool formatNumber:rgba[2]], [LLFormatterTool formatNumber:rgba[3]]];
    
    NSString *colorName = [color LL_systemColorName];
    
    return colorName ? [rgb stringByAppendingFormat:@"\n%@",colorName] : [rgb stringByAppendingFormat:@"\n%@",[color LL_hexString]];
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
        text = [NSString stringWithFormat:@"%@",obj];
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
    return [NSString stringWithFormat:@"X: %@   Y: %@",[LLFormatterTool formatNumber:@(point.x)],[LLFormatterTool formatNumber:@(point.y)]];
}

- (CGPoint)LL_pointFromString:(NSString *)string orginalPoint:(CGPoint)point {
    CGPoint newPoint = CGPointFromString(string);
    return newPoint;
}

- (NSString *)LL_hierarchySizeDescription:(CGSize)size {
    return [NSString stringWithFormat:@"W: %@   H: %@",[LLFormatterTool formatNumber:@(size.width)], [LLFormatterTool formatNumber:@(size.height)]];
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
    return [NSString stringWithFormat:@"top %@    bottom %@",[LLFormatterTool formatNumber:@(insets.top)], [LLFormatterTool formatNumber:@(insets.bottom)]];
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
    return [NSString stringWithFormat:@"left %@    right %@",[LLFormatterTool formatNumber:@(insets.left)], [LLFormatterTool formatNumber:@(insets.right)]];
}

- (NSString *)LL_hierarchyOffsetDescription:(UIOffset)offset {
    return [NSString stringWithFormat:@"h %@   v %@",[LLFormatterTool formatNumber:@(offset.horizontal)], [LLFormatterTool formatNumber:@(offset.vertical)]];
}

- (void)LL_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[self valueForKeyPath:keyPath]] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:@([newText integerValue]) forKeyPath:keyPath];
    }];
}

- (void)LL_showDoubleAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:[self valueForKeyPath:keyPath]] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:@([newText doubleValue]) forKeyPath:keyPath];
    }];
}

- (void)LL_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIColor *color = [self valueForKeyPath:keyPath];
    if (color && ![color isKindOfClass:[UIColor class]]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[color LL_hexString] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[weakSelf LL_colorFromString:newText originalColor:color] forKeyPath:keyPath];
    }];
}

- (void)LL_showFrameAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGRect([value CGRectValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGRect:[weakSelf LL_rectFromString:newText originalRect:[value CGRectValue]]] forKeyPath:keyPath];
    }];
}

- (void)LL_showPointAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGPoint([value CGPointValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGPoint:[weakSelf LL_pointFromString:newText orginalPoint:[value CGPointValue]]] forKeyPath:keyPath];
    }];
}

- (void)LL_showEdgeInsetsAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithUIEdgeInsets:[weakSelf LL_insetsFromString:newText originalInsets:[value UIEdgeInsetsValue]]] forKeyPath:keyPath];
    }];
}

- (void)LL_showTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[self valueForKeyPath:keyPath] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:newText forKeyPath:keyPath];
    }];
}

- (void)LL_showAttributeTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSAttributedString *attribute = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:attribute.string handler:^(NSString * _Nullable newText) {
        NSMutableAttributedString *mutAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attribute];
        [mutAttribute replaceCharactersInRange:NSMakeRange(0, attribute.string.length) withString:newText];
        [weakSelf setValue:[mutAttribute copy] forKeyPath:keyPath];
    }];
}

- (void)LL_showSizeAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:NSStringFromCGSize([value CGSizeValue]) handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[NSValue valueWithCGSize:[weakSelf LL_sizeFromString:newText originalSize:[value CGSizeValue]]] forKeyPath:keyPath];
    }];
}

- (void)LL_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block UIFont *font = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(font.pointSize)] handler:^(NSString * _Nullable newText) {
        [weakSelf setValue:[font fontWithSize:[newText doubleValue]] forKeyPath:keyPath];
    }];
}

- (void)LL_showDateAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    NSDate *date = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertWithText:[LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3] handler:^(NSString * _Nullable newText) {
        NSDate *newDate = [LLFormatterTool dateFromString:newText style:FormatterToolDateStyle3];
        if (newDate) {
            [weakSelf setValue:newDate forKeyPath:keyPath];
        }
    }];
}

- (void)LL_showTextFieldAlertWithText:(NSString *)text handler:(nullable void (^)(NSString * _Nullable newText))handler {
    __weak typeof(self) weakSelf = self;
    [[LLTool keyWindow].rootViewController.LL_currentShowingViewController LL_showTextFieldAlertControllerWithMessage:LLLocalizedString(@"hierarchy.change.property") text:text handler:^(NSString * _Nullable newText) {
        if (handler) {
            handler(newText);
        }
        [weakSelf LL_postHierarchyChangeNotification];
    }];
}

- (void)LL_showActionSheetWithActions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    __weak typeof(self) weakSelf = self;
    [[LLTool keyWindow].rootViewController.LL_currentShowingViewController LL_showActionSheetWithTitle:LLLocalizedString(@"hierarchy.change.property") actions:actions currentAction:currentAction completion:^(NSInteger index) {
        if (completion) {
            completion(index);
        }
        [weakSelf LL_postHierarchyChangeNotification];
    }];
}

- (void)LL_postHierarchyChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LLHierarchyChangeNotificationName object:self];
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Layer" detailTitle:self.layer.description] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Layer Class" detailTitle:NSStringFromClass(self.layer.class)];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Content Model" detailTitle:[LLEnumDescription viewContentModeDescription:self.contentMode]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription viewContentModeDescriptions] currentAction:[LLEnumDescription viewContentModeDescription:weakSelf.contentMode] completion:^(NSInteger index) {
            weakSelf.contentMode = index;
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    model4.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"User Interaction" flag: self.isUserInteractionEnabled] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.userInteractionEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Multiple Touch" flag:self.isMultipleTouchEnabled];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.multipleTouchEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(self.alpha)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"alpha"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.backgroundColor]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    model9.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Drawing" detailTitle:@"Opaque" flag:self.isOpaque] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.opaque = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Hidden" flag:self.isHidden] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidden = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Clears Graphics Context" flag:self.clearsContextBeforeDrawing] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsContextBeforeDrawing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Clip To Bounds" flag:self.clipsToBounds] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clipsToBounds = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Autoresizes Subviews" flag:self.autoresizesSubviews];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.autoresizesSubviews = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[[LLTitleCellModel alloc] initWithTitle:@"Trait Collection" detailTitle:nil] noneInsets];
    [settings addObject:model15];
    
    if (@available(iOS 12.0, *)) {
        LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLEnumDescription userInterfaceStyleDescription:self.traitCollection.userInterfaceStyle]] noneInsets];
        [settings addObject:model16];
    }
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.verticalSizeClass]]] noneInsets];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.horizontalSizeClass]]] noneInsets];
    [settings addObject:model18];
    
    if (@available(iOS 10.0, *)) {
        LLTitleCellModel *model19 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLEnumDescription traitEnvironmentLayoutDirectionDescription:self.traitCollection.layoutDirection]];
        [settings addObject:model19];
    }
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"View" items:settings];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

- (NSArray <LLTitleCellCategoryModel *>*)LL_sizeHierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Frame" detailTitle:[self LL_hierarchyPointDescription:self.frame.origin]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchySizeDescription:self.frame.size]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Bounds" detailTitle:[self LL_hierarchyPointDescription:self.bounds.origin]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"bounds"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchySizeDescription:self.bounds.size]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Center" detailTitle:[self LL_hierarchyPointDescription:self.center]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"center"];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Position" detailTitle:[self LL_hierarchyPointDescription:self.layer.position]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.position"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Z Position" detailTitle:[LLFormatterTool formatNumber:@(self.layer.zPosition)]];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.zPosition"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Anchor Point" detailTitle:[self LL_hierarchyPointDescription:self.layer.anchorPoint]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.anchorPoint"];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Anchor Point Z" detailTitle:[LLFormatterTool formatNumber:@(self.layer.anchorPointZ)]];
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
            LLTitleCellModel *mod = [[[LLTitleCellModel alloc] initWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
            __weak NSLayoutConstraint *cons = constrain;
            mod.block = ^{
                [weakSelf LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)] handler:^(NSString * _Nullable newText) {
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
                LLTitleCellModel *mod = [[[LLTitleCellModel alloc] initWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
                __weak NSLayoutConstraint *cons = constrain;
                mod.block = ^{
                    [weakSelf LL_showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)] handler:^(NSString * _Nullable newText) {
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
    
    return @[[[LLTitleCellCategoryModel alloc] initWithTitle:@"View" items:settings]];
}

- (NSString *)LL_hierarchyLayoutConstraintDescription:(NSLayoutConstraint *)constraint {
    NSMutableString *string = [[NSMutableString alloc] init];
    if (constraint.firstItem == self) {
        [string appendString:@"self."];
    } else if (constraint.firstItem == self.superview) {
        [string appendString:@"superview."];
    } else {
        [string appendFormat:@"%@.",NSStringFromClass([constraint.firstItem class])];
    }
    [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.firstAttribute]];
    [string appendString:[LLEnumDescription layoutRelationDescription:constraint.relation]];
    if (constraint.secondItem) {
        if (constraint.secondItem == self) {
            [string appendString:@"self."];
        } else if (constraint.secondItem == self.superview) {
            [string appendString:@"superview."];
        } else {
            [string appendFormat:@"%@.",NSStringFromClass([constraint.secondItem class])];
        }
        [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.secondAttribute]];
        if (constraint.multiplier != 1) {
            [string appendFormat:@" * %@",[LLFormatterTool formatNumber:@(constraint.multiplier)]];
        }
        if (constraint.constant > 0) {
            [string appendFormat:@" + %@",[LLFormatterTool formatNumber:@(constraint.constant)]];
        } else if (constraint.constant < 0) {
            [string appendFormat:@" - %@",[LLFormatterTool formatNumber:@(fabs(constraint.constant))]];
        }
    } else if (constraint.constant) {
        [string appendString:[LLFormatterTool formatNumber:@(constraint.constant)]];
    } else {
        return nil;
    }
    
    [string appendFormat:@" @ %@",[LLFormatterTool formatNumber:@(constraint.priority)]];
    return string;
}

@end

@implementation UILabel (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [LLEnumDescription textAlignmentDescription:self.textAlignment]]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments] currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfLines]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfLines"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Enabled" flag:self.isEnabled] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Highlighted" flag:self.isHighlighted];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[[LLTitleCellModel alloc] initWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",[LLEnumDescription baselineAdjustmentDescription:self.baselineAdjustment]]] noneInsets];
    model9.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription baselineAdjustments] currentAction:[LLEnumDescription baselineAdjustmentDescription:weakSelf.baselineAdjustment] completion:^(NSInteger index) {
            weakSelf.baselineAdjustment = index;
        }];
    };
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription lineBreaks] currentAction:[LLEnumDescription lineBreakModeDescription:weakSelf.lineBreakMode] completion:^(NSInteger index) {
            weakSelf.lineBreakMode = index;
        }];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:@"Min Font Scale" detailTitle:[LLFormatterTool formatNumber:@(self.minimumScaleFactor)]];
    model11.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumScaleFactor"];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Highlighted" detailTitle:[self LL_hierarchyColorDescription:self.highlightedTextColor]] noneInsets];
    model12.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"highlightedTextColor"];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:self.shadowColor]] noneInsets];
    model13.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"shadowColor"];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.shadowOffset]];
    model14.block = ^{
        [weakSelf LL_showSizeAlertAndAutomicSetWithKeyPath:@"shadowOffset"];
    };
    [settings addObject:model14];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Label" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [LLEnumDescription controlContentHorizontalAlignmentDescription:self.contentHorizontalAlignment]]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription controlContentHorizontalAlignments] currentAction:[LLEnumDescription controlContentHorizontalAlignmentDescription:weakSelf.contentHorizontalAlignment] completion:^(NSInteger index) {
            weakSelf.contentHorizontalAlignment = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [LLEnumDescription controlContentVerticalAlignmentDescription:self.contentVerticalAlignment]]];
    model2.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription controlContentVerticalAlignments] currentAction:[LLEnumDescription controlContentVerticalAlignmentDescription:weakSelf.contentVerticalAlignment] completion:^(NSInteger index) {
            weakSelf.contentVerticalAlignment = index;
        }];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Content" detailTitle:self.isSelected ? @"Selected" : @"Not Selected" flag:self.isSelected] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.selected = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.isEnabled ? @"Enabled" : @"Not Enabled" flag:self.isEnabled] noneInsets];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" flag:self.isHighlighted];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Control" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Type" detailTitle:[LLEnumDescription buttonTypeDescription:self.buttonType]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"State" detailTitle:[LLEnumDescription controlStateDescription:self.state]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Title" detailTitle:[self LL_hierarchyTextDescription:self.currentTitle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:weakSelf.currentTitle handler:^(NSString * _Nullable newText) {
            [weakSelf setTitle:newText forState:weakSelf.state];
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Text Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleColor]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:[weakSelf.currentTitleColor LL_hexString] handler:^(NSString * _Nullable newText) {
            [weakSelf setTitleColor:[weakSelf LL_colorFromString:newText originalColor:weakSelf.currentTitleColor] forState:weakSelf.state];
        }];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleShadowColor]];
    model6.block = ^{
        [weakSelf LL_showTextFieldAlertWithText:[weakSelf.currentTitleShadowColor LL_hexString] handler:^(NSString * _Nullable newText) {
            [weakSelf setTitleShadowColor:[weakSelf LL_colorFromString:newText originalColor:weakSelf.currentTitleShadowColor] forState:weakSelf.state];
        }];
    };
    [settings addObject:model6];
    
    id target = self.allTargets.allObjects.firstObject;
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@",target] : @"<nil>"] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:@"Action" detailTitle:[self LL_hierarchyTextDescription:[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject]];;
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.currentImage]];
    [settings addObject:model9];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.titleShadowOffset]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showSizeAlertAndAutomicSetWithKeyPath:@"titleShadowOffset"];
    };
    [settings addObject:model10];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:@"On Highlight" detailTitle:self.reversesTitleShadowWhenHighlighted ? @"Shadow Reverses" : @"Normal Shadow"] noneInsets];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.showsTouchWhenHighlighted ? @"Shows Touch" : @"Doesn't Show Touch"] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.adjustsImageWhenHighlighted ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:@"When Disabled" detailTitle:self.adjustsImageWhenDisabled ? @"Adjusts Image" : @"No Image Adjustment"] noneInsets];
    [settings addObject:model14];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]];
    [settings addObject:model15];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Content Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.contentEdgeInsets]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"contentEdgeInsets"];
    };
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.contentEdgeInsets]] noneInsets];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.titleEdgeInsets]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"titleEdgeInsets"];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.titleEdgeInsets]] noneInsets];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:@"Image Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.imageEdgeInsets]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"imageEdgeInsets"];
    };
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.imageEdgeInsets]];
    [settings addObject:model21];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Button" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle: [self LL_hierarchyImageDescription:self.image]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Highlighted" detailTitle: [self LL_hierarchyImageDescription:self.highlightedImage]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"State" detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted" flag:self.isHighlighted];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.highlighted = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Image View" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Allows Editing Attributes" flag:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments] currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyTextDescription:self.placeholder ?: self.attributedPlaceholder.string]];
    model7.block = ^{
        if (weakSelf.placeholder) {
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
        } else {
            [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedPlaceholder"];
        }
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle: [self LL_hierarchyImageDescription:self.background]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Disabled" detailTitle: [self LL_hierarchyImageDescription:self.disabledBackground]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[LLTitleCellModel alloc] initWithTitle:@"Border Style" detailTitle:[LLEnumDescription textBorderStyleDescription:self.borderStyle]];
    model10.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textBorderStyles] currentAction:[LLEnumDescription textBorderStyleDescription:weakSelf.borderStyle] completion:^(NSInteger index) {
            weakSelf.borderStyle = index;
        }];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:@"Clear Button" detailTitle:[LLEnumDescription textFieldViewModeDescription:self.clearButtonMode]] noneInsets];
    model11.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textFieldViewModes] currentAction:[LLEnumDescription textFieldViewModeDescription:weakSelf.clearButtonMode] completion:^(NSInteger index) {
            weakSelf.clearButtonMode = index;
        }];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Clear when editing begins" flag:self.clearsOnBeginEditing];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsOnBeginEditing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Font Size" detailTitle:[LLFormatterTool formatNumber:@(self.minimumFontSize)]] noneInsets];
    model13.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumFontSize"];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Adjusts to Fit" flag:self.adjustsFontSizeToFitWidth];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.adjustsFontSizeToFitWidth = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[[LLTitleCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model15.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes] currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes] currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes] currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardAppearances] currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance] completion:^(NSInteger index) {
            weakSelf.keyboardAppearance = index;
        }];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription returnKeyTypes] currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType] completion:^(NSInteger index) {
            weakSelf.returnKeyType = index;
        }];
    };
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Auto-enable Return Key" flag:self.enablesReturnKeyAutomatically] noneInsets];
    model20.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Secure Entry" flag:self.isSecureTextEntry];
    model21.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model21];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Text Field" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:self.isMomentary ? @"Momentary" : @"Persistent Selection" flag:self.isMomentary] noneInsets];
    model1.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.momentary = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Segments" detailTitle:[NSString stringWithFormat:@"%ld",(unsigned long)self.numberOfSegments]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Selected Index" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.selectedSegmentIndex]] noneInsets];
    model3.block = ^{
        NSMutableArray *actions = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < weakSelf.numberOfSegments; i++) {
            [actions addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        [weakSelf LL_showActionSheetWithActions:actions currentAction:[NSString stringWithFormat:@"%ld",(long)weakSelf.selectedSegmentIndex] completion:^(NSInteger index) {
            weakSelf.selectedSegmentIndex = index;
        }];
    };
    [settings addObject:model3];
    
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Large title" detailTitle:[self LL_hierarchyTextDescription:self.largeContentTitle]] noneInsets];
        model4.block = ^{
            [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"largeContentTitle"];
        };
        [settings addObject:model4];
        
        LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle: [self LL_hierarchyImageDescription:self.largeContentImage]] noneInsets];
        [settings addObject:model5];
    }
#endif
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Selected" detailTitle:[self isEnabledForSegmentAtIndex:self.selectedSegmentIndex] ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Offset" detailTitle:[self LL_hierarchySizeDescription:[self contentOffsetForSegmentAtIndex:self.selectedSegmentIndex]]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Size Mode" detailTitle:self.apportionsSegmentWidthsByContent ? @"Proportional to Content" : @"Equal Widths" flag:self.apportionsSegmentWidthsByContent] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.apportionsSegmentWidthsByContent = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Width" detailTitle:[LLFormatterTool formatNumber:@([self widthForSegmentAtIndex:self.selectedSegmentIndex])]];
    [settings addObject:model9];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Segmented Control" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Current" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Image" detailTitle: [self LL_hierarchyImageDescription:self.minimumValueImage]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:@"Max Image" detailTitle: [self LL_hierarchyImageDescription:self.maximumValueImage]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.minimumTrackTintColor]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"minimumTrackTintColor"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Max Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.maximumTrackTintColor]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"maximumTrackTintColor"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Events" detailTitle:@"Continuous Update" flag:self.isContinuous];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    LLTitleCellCategoryModel *model =  [[LLTitleCellCategoryModel alloc] initWithTitle:@"Slider" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"State" flag:self.isOn] noneInsets];
    model1.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.on = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"On Tint" detailTitle:[self LL_hierarchyColorDescription:self.onTintColor]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"onTintColor"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.thumbTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"thumbTintColor"];
    };
    [settings addObject:model3];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Switch" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription activityIndicatorViewStyleDescription:self.activityIndicatorViewStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription activityIndicatorViewStyles] currentAction:[LLEnumDescription activityIndicatorViewStyleDescription:weakSelf.activityIndicatorViewStyle] completion:^(NSInteger index) {
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
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.color]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"color"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Animating" flag:self.isAnimating] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            if (!weakSelf.isAnimating) {
                [weakSelf startAnimating];
            };
        } else {
            if (weakSelf.isAnimating) {
                [weakSelf stopAnimating];
            }
        }
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Hides When Stopped" flag:self.hidesWhenStopped];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidesWhenStopped = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Activity Indicator View" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription progressViewStyleDescription:self.progressViewStyle]];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription progressViewStyles] currentAction:[LLEnumDescription progressViewStyleDescription:weakSelf.progressViewStyle] completion:^(NSInteger index) {
            weakSelf.progressViewStyle = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Progress" detailTitle:[LLFormatterTool formatNumber:@(self.progress)]];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"progress"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Progress Tint" detailTitle:[self LL_hierarchyColorDescription:self.progressTintColor]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"progressTintColor"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.trackTintColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"trackTintColor"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Progress Image" detailTitle:[self LL_hierarchyImageDescription:self.progressImage]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Track Image" detailTitle:[self LL_hierarchyImageDescription:self.trackImage]];
    [settings addObject:model6];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Progress View" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Pages" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfPages]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"numberOfPages"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Current Page" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.currentPage]] noneInsets];
    model2.block = ^{
        if (weakSelf.numberOfPages < 10) {
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < weakSelf.numberOfPages; i++) {
                [actions addObject:[NSString stringWithFormat:@"%ld",(long)i]];
            }
            [weakSelf LL_showActionSheetWithActions:actions currentAction:[NSString stringWithFormat:@"%ld",(long)weakSelf.currentPage] completion:^(NSInteger index) {
                weakSelf.currentPage = index;
            }];
        } else {
            [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"currentPage"];
        }
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Hides for Single Page" flag:self.hidesForSinglePage] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidesForSinglePage = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Defers Page Display" flag:self.defersCurrentPageDisplay];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.defersCurrentPageDisplay = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Tint Color" detailTitle:[self LL_hierarchyColorDescription:self.pageIndicatorTintColor]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"pageIndicatorTintColor"];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Current Page" detailTitle:[self LL_hierarchyColorDescription:self.currentPageIndicatorTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"currentPageIndicatorTintColor"];
    };
    [settings addObject:model6];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Page Control" items:settings];
    
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
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Value" detailTitle:[LLFormatterTool formatNumber:@(self.value)]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"value"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumValue"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumValue"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Step" detailTitle:[LLFormatterTool formatNumber:@(self.stepValue)]];
    model4.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"stepValue"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Autorepeat" flag:self.autorepeat] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.autorepeat = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Continuous" flag:self.isContinuous] noneInsets];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Wrap" flag:self.wraps];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.wraps = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Stepper" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription scrollViewIndicatorStyles] currentAction:[LLEnumDescription scrollViewIndicatorStyleDescription:weakSelf.indicatorStyle] completion:^(NSInteger index) {
            weakSelf.indicatorStyle = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Indicators" detailTitle:@"Shows Horizontal Indicator" flag:self.showsHorizontalScrollIndicator] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsHorizontalScrollIndicator = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shows Vertical Indicator" flag:self.showsVerticalScrollIndicator];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsVerticalScrollIndicator = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Scrolling" detailTitle:@"Enable" flag:self.isScrollEnabled] noneInsets];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.scrollEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Paging" flag:self.isPagingEnabled] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.pagingEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Direction Lock" flag:self.isDirectionalLockEnabled];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.directionalLockEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Bounce" detailTitle:@"Bounces" flag:self.bounces] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.bounces = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Bounce Horizontal" flag:self.alwaysBounceHorizontal] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.alwaysBounceHorizontal = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Bounce Vertical" flag:self.alwaysBounceVertical];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.alwaysBounceVertical = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Zoom Min" detailTitle:[LLFormatterTool formatNumber:@(self.minimumZoomScale)]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"minimumZoomScale"];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:@"Max" detailTitle:[LLFormatterTool formatNumber:@(self.maximumZoomScale)]];
    model11.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"maximumZoomScale"];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@",[self LL_hierarchyBoolDescription:self.isZoomBouncing]]] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Delays Content Touches" flag:self.delaysContentTouches] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.delaysContentTouches = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Cancellable Content Touches" flag:self.canCancelContentTouches];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.canCancelContentTouches = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
    model15.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription scrollViewKeyboardDismissModes] currentAction:[LLEnumDescription scrollViewKeyboardDismissModeDescription:weakSelf.keyboardDismissMode] completion:^(NSInteger index) {
            weakSelf.keyboardDismissMode = index;
        }];
    };
    [settings addObject:model15];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Scroll View" items:settings];
    
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
    __weak typeof(self)weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfSections]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription tableViewStyleDescription:self.style]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator" detailTitle:[LLEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellSeparatorStyles] currentAction:[LLEnumDescription tableViewCellSeparatorStyleDescription:weakSelf.separatorStyle] completion:^(NSInteger index) {
            weakSelf.separatorStyle = index;
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.separatorColor]];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"separatorColor"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]] noneInsets];
    [settings addObject:model8];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        model9.block = ^{
            [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewSeparatorInsetReferences] currentAction:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:weakSelf.separatorInsetReference] completion:^(NSInteger index) {
                weakSelf.separatorInsetReference = index;
            }];
        };
        [settings addObject:model9];
    }
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled" flag:self.allowsSelection] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsSelection = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"] flag:self.allowsMultipleSelection] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsMultipleSelection = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled" flag:self.allowsSelectionDuringEditing] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsSelectionDuringEditing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelectionDuringEditing ? @"" : @"Disabled"] flag:self.allowsMultipleSelectionDuringEditing];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsMultipleSelectionDuringEditing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.sectionIndexMinimumDisplayRowCount]] noneInsets];
    model14.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"sectionIndexMinimumDisplayRowCount"];
    };
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexColor]] noneInsets];
    model15.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexColor"];
    };
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexBackgroundColor]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexBackgroundColor"];
    };
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[LLTitleCellModel alloc] initWithTitle:@"Tracking" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexTrackingBackgroundColor]];
    model17.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"sectionIndexTrackingBackgroundColor"];
    };
    model17.block = ^{
        
    };
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Row Height" detailTitle:[LLFormatterTool formatNumber:@(self.rowHeight)]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"rowHeight"];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:@"Section Header" detailTitle:[LLFormatterTool formatNumber:@(self.sectionHeaderHeight)]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionHeaderHeight"];
    };
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[LLTitleCellModel alloc] initWithTitle:@"Section Footer" detailTitle:[LLFormatterTool formatNumber:@(self.sectionFooterHeight)]];
    model20.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"sectionFooterHeight"];
    };
    [settings addObject:model20];

    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Table View" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.imageView.image]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Identifier" detailTitle:[self LL_hierarchyTextDescription:self.reuseIdentifier]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:[LLEnumDescription tableViewCellSelectionStyleDescription:self.selectionStyle]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellSelectionStyles] currentAction:[LLEnumDescription tableViewCellSelectionStyleDescription:weakSelf.selectionStyle] completion:^(NSInteger index) {
            weakSelf.selectionStyle = index;
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Accessory" detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.accessoryType]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes] currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.accessoryType] completion:^(NSInteger index) {
            weakSelf.accessoryType = index;
        }];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:@"Editing Acc." detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.editingAccessoryType]];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tableViewCellAccessoryTypes] currentAction:[LLEnumDescription tableViewCellAccessoryTypeDescription:weakSelf.editingAccessoryType] completion:^(NSInteger index) {
            weakSelf.editingAccessoryType = index;
        }];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Indentation" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.indentationLevel]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"indentationLevel"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLFormatterTool formatNumber:@(self.indentationWidth)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"indentationWidth"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Indent While Editing" flag:self.shouldIndentWhileEditing] noneInsets];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.shouldIndentWhileEditing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shows Re-order Controls" flag:self.showsReorderControl];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsReorderControl = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    model10.block = ^{
        [weakSelf LL_showEdgeInsetsAndAutomicSetWithKeyPath:@"separatorInset"];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]];
    [settings addObject:model11];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Table View Cell" items:settings];
    
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
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfSections]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Layout" detailTitle:[self LL_hierarchyObjectDescription:self.collectionViewLayout]];
    [settings addObject:model4];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Collection View" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Identifier" detailTitle:[self LL_hierarchyTextDescription:self.reuseIdentifier]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Collection Reusable View" items:settings];
                                
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
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showAttributeTextAlertAndAutomicSetWithKeyPath:@"attributedText"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Allows Editing Attributes" flag:self.allowsEditingTextAttributes] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.allowsEditingTextAttributes = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]];
    model6.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAlignments] currentAction:[LLEnumDescription textAlignmentDescription:weakSelf.textAlignment] completion:^(NSInteger index) {
            weakSelf.textAlignment = index;
        }];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:@"Editable" flag:self.isEditable] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.editable = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Selectable" flag:self.isSelectable];
    model8.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.selectable = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[[LLTitleCellModel alloc] initWithTitle:@"Data Detectors" detailTitle:@"Phone Number" flag:self.dataDetectorTypes & UIDataDetectorTypePhoneNumber] noneInsets];
    model9.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypePhoneNumber;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypePhoneNumber;
        }
    };
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Link" flag:self.dataDetectorTypes & UIDataDetectorTypeLink] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeLink;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeLink;
        }
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Address" flag:self.dataDetectorTypes & UIDataDetectorTypeAddress] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeAddress;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeAddress;
        }
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Calendar Event" flag:self.dataDetectorTypes & UIDataDetectorTypeCalendarEvent] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        if ([obj boolValue]) {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeCalendarEvent;
        } else {
            weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeCalendarEvent;
        }
    };
    [settings addObject:model12];
    
    if (@available(iOS 10.0, *)) {
        LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shipment Tracking Number" flag:self.dataDetectorTypes & UIDataDetectorTypeShipmentTrackingNumber] noneInsets];
        model13.changePropertyBlock = ^(id  _Nullable obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeShipmentTrackingNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeShipmentTrackingNumber;
            }
        };
        [settings addObject:model13];
        
        LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Flight Number" flag:self.dataDetectorTypes & UIDataDetectorTypeFlightNumber] noneInsets];
        model14.changePropertyBlock = ^(id  _Nullable obj) {
            if ([obj boolValue]) {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes | UIDataDetectorTypeFlightNumber;
            } else {
                weakSelf.dataDetectorTypes = weakSelf.dataDetectorTypes & ~UIDataDetectorTypeFlightNumber;
            }
        };
        [settings addObject:model14];
        
        LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Lookup Suggestion" flag:self.dataDetectorTypes & UIDataDetectorTypeLookupSuggestion];
        model15.changePropertyBlock = ^(id  _Nullable obj) {
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
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model16.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes] currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes] currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes] currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardAppearances] currentAction:[LLEnumDescription keyboardAppearanceDescription:weakSelf.keyboardAppearance] completion:^(NSInteger index) {
            weakSelf.keyboardAppearance = index;
        }];
    };
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription returnKeyTypes] currentAction:[LLEnumDescription returnKeyTypeDescription:weakSelf.returnKeyType] completion:^(NSInteger index) {
            weakSelf.returnKeyType = index;
        }];
    };
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Auto-enable Return Key" flag:self.enablesReturnKeyAutomatically] noneInsets];
    model21.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enablesReturnKeyAutomatically = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model21];
    
    LLTitleCellModel *model22 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Secure Entry" flag:self.isSecureTextEntry];
    model22.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.secureTextEntry = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model22];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Text View" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Mode" detailTitle:[LLEnumDescription datePickerModeDescription:self.datePickerMode]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription datePickerModes] currentAction:[LLEnumDescription datePickerModeDescription:weakSelf.datePickerMode] completion:^(NSInteger index) {
            weakSelf.datePickerMode = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Locale Identifier" detailTitle:self.locale.localeIdentifier] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Interval" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.minuteInterval]];
    model3.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"minuteInterval"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Date" detailTitle:[self LL_hierarchyDateDescription:self.date]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"date"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Date" detailTitle:[self LL_hierarchyDateDescription:self.minimumDate]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"minimumDate"];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Max Date" detailTitle:[self LL_hierarchyDateDescription:self.maximumDate]];
    model6.block = ^{
        [weakSelf LL_showDateAlertAndAutomicSetWithKeyPath:@"maximumDate"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Count Down" detailTitle:[LLFormatterTool formatNumber:@(self.countDownDuration)]];
    [settings addObject:model7];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Date Picker" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model1];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Picker View" items:settings];
                                
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
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles] currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Prefers Large Titles" flag:self.prefersLargeTitles] noneInsets];
        model3.changePropertyBlock = ^(id  _Nullable obj) {
            weakSelf.prefersLargeTitles = [obj boolValue];
            [weakSelf LL_postHierarchyChangeNotification];
        };
        [settings addObject:model3];
    }
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow Image" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Back Image" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorImage]] noneInsets];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Back Mask" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorTransitionMaskImage]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Attr." detailTitle:nil] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Font" detailTitle:[self LL_hierarchyObjectDescription:self.titleTextAttributes[NSFontAttributeName]]] noneInsets];
    if (self.titleTextAttributes[NSFontAttributeName]) {
        model9.block = ^{
            __block UIFont *font = weakSelf.titleTextAttributes[NSFontAttributeName];
            if (!font) {
                return;
            }
            [weakSelf LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[LLFormatterTool formatNumber:@(font.pointSize)]] handler:^(NSString * _Nullable newText) {
                NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.titleTextAttributes];
                attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                weakSelf.titleTextAttributes = [attributes copy];
            }];
        };
    }
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Color" detailTitle:[self LL_hierarchyColorDescription:self.titleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
    [settings addObject:model10];
    
    NSShadow *shadow = self.titleTextAttributes[NSShadowAttributeName];
    if (![shadow isKindOfClass:[NSShadow class]]) {
        shadow = nil;
    }
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:shadow.shadowOffset]];
    [settings addObject:model12];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Large Title Attr." detailTitle:nil] noneInsets];
        [settings addObject:model13];
        
        LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Font" detailTitle:[self LL_hierarchyColorDescription:self.largeTitleTextAttributes[NSFontAttributeName]]] noneInsets];
        if (self.largeTitleTextAttributes[NSFontAttributeName]) {
            model14.block = ^{
                __block UIFont *font = weakSelf.largeTitleTextAttributes[NSFontAttributeName];
                if (!font) {
                    return;
                }
                [weakSelf LL_showTextFieldAlertWithText:[NSString stringWithFormat:@"%@",[LLFormatterTool formatNumber:@(font.pointSize)]] handler:^(NSString * _Nullable newText) {
                    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:weakSelf.largeTitleTextAttributes];
                    attributes[NSFontAttributeName] = [font fontWithSize:[newText doubleValue]];
                    weakSelf.largeTitleTextAttributes = [attributes copy];
                }];
            };
        }
        [settings addObject:model14];
        
        LLTitleCellModel *model15 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Color" detailTitle:[self LL_hierarchyColorDescription:self.largeTitleTextAttributes[NSForegroundColorAttributeName]]] noneInsets];
        [settings addObject:model15];
        
        shadow = self.largeTitleTextAttributes[NSShadowAttributeName];
        if (![shadow isKindOfClass:[NSShadow class]]) {
            shadow = nil;
        }
        
        LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:shadow.shadowColor]] noneInsets];
        [settings addObject:model16];
        
        LLTitleCellModel *model17 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:shadow.shadowOffset]];
        [settings addObject:model17];
    }
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Navigation Bar" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles] currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model2.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model3.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model3];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Tool Bar" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:[self LL_hierarchyImageDescription:self.selectionIndicatorImage]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles] currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model6.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription tabBarItemPositioningDescription:self.itemPositioning]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription tabBarItemPositionings] currentAction:[LLEnumDescription tabBarItemPositioningDescription:weakSelf.itemPositioning] completion:^(NSInteger index) {
            weakSelf.itemPositioning = index;
        }];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Item Width" detailTitle:[LLFormatterTool formatNumber:@(self.itemWidth)]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemWidth"];
    };
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Item Spacing" detailTitle:[LLFormatterTool formatNumber:@(self.itemSpacing)]];
    model9.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"itemSpacing"];
    };
    [settings addObject:model9];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Tab Bar" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyTextDescription:self.placeholder]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"placeholder"];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Prompt" detailTitle:[self LL_hierarchyTextDescription:self.prompt]];
    model3.block = ^{
        [weakSelf LL_showTextAlertAndAutomicSetWithKeyPath:@"prompt"];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Search Style" detailTitle:[LLEnumDescription searchBarStyleDescription:self.searchBarStyle]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription searchBarStyles] currentAction:[LLEnumDescription searchBarStyleDescription:weakSelf.searchBarStyle] completion:^(NSInteger index) {
            weakSelf.searchBarStyle = index;
        }];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Bar Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription barStyles] currentAction:[LLEnumDescription barStyleDescription:weakSelf.barStyle] completion:^(NSInteger index) {
            weakSelf.barStyle = index;
        }];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Translucent" flag:self.isTranslucent] noneInsets];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.translucent = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    model7.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"barTintColor"];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Scope Bar" detailTitle:[self LL_hierarchyImageDescription:self.scopeBarBackgroundImage]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Text Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchTextPositionAdjustment]] noneInsets];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:@"BG Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchFieldBackgroundPositionAdjustment]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Options" detailTitle:@"Shows Search Results Button" flag:self.showsSearchResultsButton] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsSearchResultsButton = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shows Bookmarks Button" flag:self.showsBookmarkButton] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsBookmarkButton = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shows Cancel Button" flag:self.showsCancelButton] noneInsets];
    model14.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsCancelButton = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Shows Scope Bar" flag:self.showsScopeBar];
    model15.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.showsScopeBar = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [[LLTitleCellModel alloc] initWithTitle:@"Scope Titles" detailTitle:[self LL_hierarchyObjectDescription:self.scopeButtonTitles]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    model17.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocapitalizationTypes] currentAction:[LLEnumDescription textAutocapitalizationTypeDescription:weakSelf.autocapitalizationType] completion:^(NSInteger index) {
            weakSelf.autocapitalizationType = index;
        }];
    };
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription textAutocorrectionTypes] currentAction:[LLEnumDescription textAutocorrectionTypeDescription:weakSelf.autocorrectionType] completion:^(NSInteger index) {
            weakSelf.autocorrectionType = index;
        }];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]];
    model19.block = ^{
        [weakSelf LL_showActionSheetWithActions:[LLEnumDescription keyboardTypes] currentAction:[LLEnumDescription keyboardTypeDescription:weakSelf.keyboardType] completion:^(NSInteger index) {
            weakSelf.keyboardType = index;
        }];
    };
    [settings addObject:model19];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Search Bar" items:settings];
                                
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Key Window %@",[self LL_hierarchyBoolDescription:self.isKeyWindow]]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Root Controller" detailTitle:[self LL_hierarchyObjectDescription:self.rootViewController]];
    [settings addObject:model2];
    
    LLTitleCellCategoryModel *model = [[LLTitleCellCategoryModel alloc] initWithTitle:@"Window" items:settings];
                                
    NSMutableArray *models = [[NSMutableArray alloc] initWithArray:[super LL_hierarchyCategoryModels]];
    if (models.count > 0) {
        [models insertObject:model atIndex:1];
    } else {
        [models addObject:model];
    }
    return [models copy];
}

@end
