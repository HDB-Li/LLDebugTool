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
#import "LLMacros.h"
#import "UIColor+LL_Utils.h"
#import "LLFormatterTool.h"
#import "LLEnumDescription.h"
#import "LLTool.h"
#import "UIViewController+LL_Utils.h"

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
    
    return colorName ? [rgb stringByAppendingFormat:@"\n%@",colorName] : rgb;
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

- (NSString *)LL_hierarchyTextDescription:(NSString *)text {
    if (text == nil) {
        return @"<nil>";
    }
    if ([text length] == 0) {
        return @"<empty string>";
    }
    return text;
}

- (NSString *)LL_hierarchySizeDescription:(CGSize)size {
    return [NSString stringWithFormat:@"w %@   h %@",[LLFormatterTool formatNumber:@(size.width)], [LLFormatterTool formatNumber:@(size.height)]];
}

- (CGSize)LL_sizeFromString:(NSString *)string originalSize:(CGSize)size {
    CGSize newSize = CGSizeFromString(string);
    if (CGSizeEqualToSize(newSize, CGSizeZero) && ![string isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong size string."];
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
        [LLTool log:@"Input a wrong insets string."];
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

- (void)LL_showHierarchyChangeAlertWithText:(NSString *)text handler:(nullable void (^)(NSString * _Nullable newText))handler {
    [[LLTool keyWindow].rootViewController.LL_currentShowingViewController LL_showTextFieldAlertControllerWithMessage:@"Change Property" text:text handler:^(NSString * _Nullable newText) {
        if (handler) {
            handler(newText);
        }
        [self LL_postHierarchyChangeNotification];
    }];
}

- (void)LL_showActionSheetWithActions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    [[LLTool keyWindow].rootViewController.LL_currentShowingViewController LL_showActionSheetWithTitle:@"Change Property" actions:actions currentAction:currentAction completion:^(NSInteger index) {
        if (completion) {
            completion(index);
        }
        [self LL_postHierarchyChangeNotification];
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
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithAttributedString:string];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%ld",(long)weakSelf.tag] handler:^(NSString * _Nullable newText) {
            weakSelf.tag = [newText integerValue];
        }];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"User Interaction" flag: self.isUserInteractionEnabled] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.userInteractionEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Multiple Touch" flag:self.isMultipleTouchEnabled];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.multipleTouchEnabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(self.alpha)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(self.alpha)] handler:^(NSString * _Nullable newText) {
            weakSelf.alpha = [newText doubleValue];
        }];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.backgroundColor]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Opaque" flag:self.isOpaque] noneInsets];
    model10.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.opaque = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:@"Hidden" flag:self.isHidden] noneInsets];
    model11.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.hidden = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Clears Graphics Context" flag:self.clearsContextBeforeDrawing] noneInsets];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsContextBeforeDrawing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Clip To Bounds" flag:self.clipsToBounds] noneInsets];
    model13.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clipsToBounds = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:@"Autoresizes Subviews" flag:self.autoresizesSubviews];
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

@end

@implementation UILabel (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:weakSelf.text handler:^(NSString * _Nullable newText) {
            if (weakSelf.attributedText == nil) {
                weakSelf.text = newText;
            } else {
                [weakSelf LL_replaceAttributeString:newText key:@"attributedText"];
            }
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model4.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%@",[LLFormatterTool formatNumber:@(weakSelf.font.pointSize)]] handler:^(NSString * _Nullable newText) {
            weakSelf.font = [weakSelf.font fontWithSize:[newText doubleValue]];
        }];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%ld",(long)weakSelf.numberOfLines] handler:^(NSString * _Nullable newText) {
            weakSelf.numberOfLines = [newText integerValue];
        }];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Enabled" flag:self.isEnabled] noneInsets];
    model7.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:@"Highlighted" flag:self.isHighlighted];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.minimumScaleFactor)] handler:^(NSString * _Nullable newText) {
            weakSelf.minimumScaleFactor = [newText doubleValue];
        }];
    };
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Highlighted" detailTitle:[self LL_hierarchyColorDescription:self.highlightedTextColor]] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:self.shadowColor]] noneInsets];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.shadowOffset]];
    model14.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:NSStringFromCGSize(weakSelf.shadowOffset) handler:^(NSString * _Nullable newText) {
            weakSelf.shadowOffset = [weakSelf LL_sizeFromString:newText originalSize:weakSelf.shadowOffset];
        }];
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
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Select" flag:self.isSelected] noneInsets];
    model3.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.selected = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Enable" flag:self.isEnabled] noneInsets];
    model4.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.enabled = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:@"Highlight" flag:self.isHighlighted];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:weakSelf.currentTitle handler:^(NSString * _Nullable newText) {
            [weakSelf setTitle:newText forState:weakSelf.state];
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Text Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleColor]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Shadow Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleShadowColor]];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:NSStringFromCGSize(weakSelf.titleShadowOffset) handler:^(NSString * _Nullable newText) {
            weakSelf.titleShadowOffset = [self LL_sizeFromString:newText originalSize:weakSelf.titleShadowOffset];
        }];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:NSStringFromUIEdgeInsets(weakSelf.contentEdgeInsets) handler:^(NSString * _Nullable newText) {
            weakSelf.contentEdgeInsets = [weakSelf LL_insetsFromString:newText originalInsets:weakSelf.contentEdgeInsets];
        }];
    };
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.contentEdgeInsets]] noneInsets];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.titleEdgeInsets]] noneInsets];
    model18.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:NSStringFromUIEdgeInsets(weakSelf.titleEdgeInsets) handler:^(NSString * _Nullable newText) {
            weakSelf.titleEdgeInsets = [weakSelf LL_insetsFromString:newText originalInsets:weakSelf.titleEdgeInsets];
        }];
    };
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.titleEdgeInsets]] noneInsets];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:@"Image Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.imageEdgeInsets]] noneInsets];
    model20.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:NSStringFromUIEdgeInsets(weakSelf.imageEdgeInsets) handler:^(NSString * _Nullable newText) {
            weakSelf.imageEdgeInsets = [weakSelf LL_insetsFromString:newText originalInsets:weakSelf.imageEdgeInsets];
        }];
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
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Highlight" flag:self.isHighlighted];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:weakSelf.text handler:^(NSString * _Nullable newText) {
            weakSelf.text = newText;
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:weakSelf.attributedText.string handler:^(NSString * _Nullable newText) {
            [weakSelf LL_replaceAttributeString:newText key:@"attributedText"];
        }];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Allows Editing Attributes %@", [self LL_hierarchyBoolDescription:self.allowsEditingTextAttributes]]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    model5.block = ^{
      [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%@",[LLFormatterTool formatNumber:@(weakSelf.font.pointSize)]] handler:^(NSString * _Nullable newText) {
          weakSelf.font = [weakSelf.font fontWithSize:[newText doubleValue]];
      }];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:(weakSelf.placeholder ?: weakSelf.attributedPlaceholder.string) handler:^(NSString * _Nullable newText) {
            if (weakSelf.placeholder) {
                weakSelf.placeholder = newText;
            } else {
                [weakSelf LL_replaceAttributeString:newText key:@"attributedPlaceholder"];
            }
        }];
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
    
    LLTitleCellModel *model12 = [[LLTitleCellModel alloc] initWithTitle:@"Clear on edit" flag:self.clearsOnBeginEditing];
    model12.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.clearsOnBeginEditing = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Font Size" detailTitle:[LLFormatterTool formatNumber:@(self.minimumFontSize)]] noneInsets];
    model13.block = ^{
      [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.minimumFontSize)] handler:^(NSString * _Nullable newText) {
            weakSelf.minimumFontSize = [newText doubleValue];
        }];
    };
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:@"Adjust font size" flag:self.adjustsFontSizeToFitWidth];
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
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Auto-enable Return Key %@", [self LL_hierarchyBoolDescription:self.enablesReturnKeyAutomatically]]] noneInsets];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [[LLTitleCellModel alloc] initWithTitle:@"Secure Entry" flag:self.isSecureTextEntry];
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
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Momentary" flag:self.isMomentary] noneInsets];
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
            [weakSelf LL_showHierarchyChangeAlertWithText:weakSelf.largeContentTitle handler:^(NSString * _Nullable newText) {
                weakSelf.largeContentTitle = newText;
            }];
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
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Apportions segment width" flag:self.apportionsSegmentWidthsByContent] noneInsets];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.value)] handler:^(NSString * _Nullable newText) {
            weakSelf.value = [newText floatValue];
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(self.minimumValue)] handler:^(NSString * _Nullable newText) {
            weakSelf.minimumValue = [newText floatValue];
        }];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    model3.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(self.maximumValue)] handler:^(NSString * _Nullable newText) {
            weakSelf.maximumValue = [newText floatValue];
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Image" detailTitle: [self LL_hierarchyImageDescription:self.minimumValueImage]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:@"Max Image" detailTitle: [self LL_hierarchyImageDescription:self.maximumValueImage]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.minimumTrackTintColor]] noneInsets];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Max Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.maximumTrackTintColor]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Continuous" flag:self.isContinuous];
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
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.thumbTintColor]];
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
            if (index <= UIActivityIndicatorViewStyleGray) {
                weakSelf.activityIndicatorViewStyle = index;
            } else {
                if (@available(iOS 13.0, *)) {
                    weakSelf.activityIndicatorViewStyle = index + (UIActivityIndicatorViewStyleMedium - UIActivityIndicatorViewStyleGray - 1);
                }
            }
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.color]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Animating" flag:self.isAnimating] noneInsets];
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
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Hides When Stopped" flag:self.hidesWhenStopped];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.progress)] handler:^(NSString * _Nullable newText) {
            weakSelf.progress = [newText floatValue];
        }];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Progress Tint" detailTitle:[self LL_hierarchyColorDescription:self.progressTintColor]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.trackTintColor]];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%ld",(long)weakSelf.numberOfPages] handler:^(NSString * _Nullable newText) {
            weakSelf.numberOfPages = [newText integerValue];
        }];
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
            [weakSelf LL_showHierarchyChangeAlertWithText:[NSString stringWithFormat:@"%ld",(long)weakSelf.currentPage] handler:^(NSString * _Nullable newText) {
                weakSelf.currentPage = [newText integerValue];
            }];
        }
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Hides for Single Page %@",[self LL_hierarchyBoolDescription:self.hidesForSinglePage]]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Defers Page Display %@", [self LL_hierarchyBoolDescription:self.defersCurrentPageDisplay]]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Tint Color" detailTitle:[self LL_hierarchyColorDescription:self.pageIndicatorTintColor]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Current Page" detailTitle:[self LL_hierarchyColorDescription:self.currentPageIndicatorTintColor]];
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
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.value)] handler:^(NSString * _Nullable newText) {
            weakSelf.value = [newText doubleValue];
        }];
    };
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]] noneInsets];
    model2.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.minimumValue)] handler:^(NSString * _Nullable newText) {
            weakSelf.minimumValue = [newText doubleValue];
        }];
    };
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.maximumValue)] handler:^(NSString * _Nullable newText) {
            weakSelf.maximumValue = [newText doubleValue];
        }];
    };
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:@"Step" detailTitle:[LLFormatterTool formatNumber:@(self.stepValue)]];
    model4.block = ^{
        [weakSelf LL_showHierarchyChangeAlertWithText:[LLFormatterTool formatNumber:@(weakSelf.stepValue)] handler:^(NSString * _Nullable newText) {
            weakSelf.stepValue = [newText doubleValue];
        }];
    };
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Autorepeat" flag:self.autorepeat] noneInsets];
    model5.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.autorepeat = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Continuous" flag:self.isContinuous] noneInsets];
    model6.changePropertyBlock = ^(id  _Nullable obj) {
        weakSelf.continuous = [obj boolValue];
        [weakSelf LL_postHierarchyChangeNotification];
    };
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Wrap" flag:self.wraps];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Indicators" detailTitle:[NSString stringWithFormat:@"Shows Horizontal Indicator %@",[self LL_hierarchyBoolDescription:self.showsHorizontalScrollIndicator]]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Vertical Indicator %@",[self LL_hierarchyBoolDescription:self.showsVerticalScrollIndicator]]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Scrolling" detailTitle:[NSString stringWithFormat:@"Scrolling %@", self.scrollEnabled ? @"Enabled" : @"Not Enabled"]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Paging %@", self.pagingEnabled ? @"Enabled" : @"Disabled"]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Direction Lock %@",self.isDirectionalLockEnabled ? @"Enabled" : @"Disabled"]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Bounce" detailTitle:[NSString stringWithFormat:@"Bounces %@",[self LL_hierarchyBoolDescription:self.bounces]]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Bounce Horizontal %@",[self LL_hierarchyBoolDescription:self.alwaysBounceHorizontal]]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Bounce Vertical %@",[self LL_hierarchyBoolDescription:self.alwaysBounceVertical]]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Zoom Min" detailTitle:[LLFormatterTool formatNumber:@(self.minimumZoomScale)]] noneInsets];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:@"Max" detailTitle:[LLFormatterTool formatNumber:@(self.maximumZoomScale)]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@",[self LL_hierarchyBoolDescription:self.isZoomBouncing]]] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Delays Content Touches %@",[self LL_hierarchyBoolDescription:self.delaysContentTouches]]] noneInsets];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Cancellable Content Touches %@",[self LL_hierarchyBoolDescription:self.canCancelContentTouches]]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfSections]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription tableViewStyleDescription:self.style]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator" detailTitle:[LLEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.separatorColor]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]] noneInsets];
    [settings addObject:model8];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        [settings addObject:model9];
    }
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled"] noneInsets];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"]] noneInsets];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled"] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.sectionIndexMinimumDisplayRowCount]] noneInsets];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexColor]] noneInsets];
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexBackgroundColor]] noneInsets];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[LLTitleCellModel alloc] initWithTitle:@"Tracking" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexTrackingBackgroundColor]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Row Height" detailTitle:[LLFormatterTool formatNumber:@(self.rowHeight)]] noneInsets];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:@"Section Header" detailTitle:[LLFormatterTool formatNumber:@(self.sectionHeaderHeight)]] noneInsets];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[LLTitleCellModel alloc] initWithTitle:@"Section Footer" detailTitle:[LLFormatterTool formatNumber:@(self.sectionFooterHeight)]];
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
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.imageView.image]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[LLTitleCellModel alloc] initWithTitle:@"Identifier" detailTitle:[self LL_hierarchyTextDescription:self.reuseIdentifier]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:[LLEnumDescription tableViewCellSelectionStyleDescription:self.selectionStyle]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Accessory" detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.accessoryType]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[LLTitleCellModel alloc] initWithTitle:@"Editing Acc." detailTitle:[LLEnumDescription tableViewCellAccessoryTypeDescription:self.editingAccessoryType]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Indentation" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.indentationLevel]] noneInsets];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[LLFormatterTool formatNumber:@(self.indentationWidth)]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Indent While Editing %@",[self LL_hierarchyBoolDescription:self.shouldIndentWhileEditing]]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Re-order Controls %@",[self LL_hierarchyBoolDescription:self.showsReorderControl]]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]] noneInsets];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Allows Editing Attributes %@",[self LL_hierarchyBoolDescription:self.allowsEditingTextAttributes]]] noneInsets];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Editable %@",[self LL_hierarchyBoolDescription:self.isEditable]]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Selectable %@",[self LL_hierarchyBoolDescription:self.isSelectable]]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[[LLTitleCellModel alloc] initWithTitle:@"Data Detectors" detailTitle:[NSString stringWithFormat:@"Phone Number %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypePhoneNumber]]] noneInsets];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Link %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeLink]]] noneInsets];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Address %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeAddress]]] noneInsets];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Calendar Event %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeCalendarEvent]]] noneInsets];
    [settings addObject:model12];
    
    if (@available(iOS 10.0, *)) {
        LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shipment Tracking Number %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeShipmentTrackingNumber]]] noneInsets];
        [settings addObject:model13];
        
        LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Flight Number %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeFlightNumber]]] noneInsets];
        [settings addObject:model14];
        
        LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Lookup Suggestion %@",[self LL_hierarchyBoolDescription:self.dataDetectorTypes & UIDataDetectorTypeLookupSuggestion]]];
        [settings addObject:model15];
    } else {
        model12.separatorInsets = UIEdgeInsetsMake(0, kLLGeneralMargin, 0, 0);
    }
    
    LLTitleCellModel *model16 = [[[LLTitleCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]] noneInsets];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[[LLTitleCellModel alloc] initWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]] noneInsets];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [[[LLTitleCellModel alloc] initWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]] noneInsets];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Auto-enable Return Key %@",[self LL_hierarchyBoolDescription:self.enablesReturnKeyAutomatically]]] noneInsets];
    [settings addObject:model21];
    
    LLTitleCellModel *model22 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Secure Entry %@",[self LL_hierarchyBoolDescription:self.isSecureTextEntry]]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Mode" detailTitle:[LLEnumDescription datePickerModeDescription:self.datePickerMode]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Locale Identifier" detailTitle:self.locale.localeIdentifier] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Interval" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.minuteInterval]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Date" detailTitle:[self LL_hierarchyObjectDescription:self.date]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Min Date" detailTitle:[self LL_hierarchyObjectDescription:self.minimumDate]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Max Date" detailTitle:[self LL_hierarchyObjectDescription:self.maximumDate]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Count Down" detailTitle:[LLFormatterTool formatNumber:@(self.countDownDuration)]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:@"Count Down in Seconds"];
    [settings addObject:model8];
    
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Translucent %@",[self LL_hierarchyBoolDescription:self.isTranslucent]]] noneInsets];
    [settings addObject:model2];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model3 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Prefers Large Titles %@",[self LL_hierarchyBoolDescription:self.prefersLargeTitles]]] noneInsets];
        [settings addObject:model3];
    }
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow Image" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:@"Back Image" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorImage]] noneInsets];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:@"Back Mask" detailTitle:[self LL_hierarchyImageDescription:self.backIndicatorTransitionMaskImage]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Attr." detailTitle:nil] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[[LLTitleCellModel alloc] initWithTitle:@"Title Font" detailTitle:[self LL_hierarchyColorDescription:self.titleTextAttributes[NSFontAttributeName]]] noneInsets];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Translucent %@",[self LL_hierarchyBoolDescription:self.isTranslucent]]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:[self LL_hierarchyImageDescription:self.shadowImage]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Selection" detailTitle:[self LL_hierarchyImageDescription:self.selectionIndicatorImage]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Translucent %@",[self LL_hierarchyBoolDescription:self.isTranslucent]]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[LLTitleCellModel alloc] initWithTitle:@"Bar Tint" detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[[LLTitleCellModel alloc] initWithTitle:@"Style" detailTitle:[LLEnumDescription tabBarItemPositioningDescription:self.itemPositioning]] noneInsets];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Item Width" detailTitle:[LLFormatterTool formatNumber:@(self.itemWidth)]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Item Spacing" detailTitle:[LLFormatterTool formatNumber:@(self.itemSpacing)]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self LL_hierarchyTextDescription:self.text]] noneInsets];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [[[LLTitleCellModel alloc] initWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyTextDescription:self.placeholder]] noneInsets];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [[LLTitleCellModel alloc] initWithTitle:@"Prompt" detailTitle:[self LL_hierarchyTextDescription:self.prompt]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [[[LLTitleCellModel alloc] initWithTitle:@"Search Style" detailTitle:[LLEnumDescription searchBarStyleDescription:self.searchBarStyle]] noneInsets];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [[[LLTitleCellModel alloc] initWithTitle:@"Bar Style" detailTitle:[LLEnumDescription barStyleDescription:self.barStyle]] noneInsets];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Translucent %@",[self LL_hierarchyBoolDescription:self.isTranslucent]]] noneInsets];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.barTintColor]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self LL_hierarchyImageDescription:self.backgroundImage]] noneInsets];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [[LLTitleCellModel alloc] initWithTitle:@"Scope Bar" detailTitle:[self LL_hierarchyImageDescription:self.scopeBarBackgroundImage]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [[[LLTitleCellModel alloc] initWithTitle:@"Text Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchTextPositionAdjustment]] noneInsets];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [[LLTitleCellModel alloc] initWithTitle:@"BG Offset" detailTitle:[self LL_hierarchyOffsetDescription:self.searchFieldBackgroundPositionAdjustment]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [[[LLTitleCellModel alloc] initWithTitle:@"Options" detailTitle:[NSString stringWithFormat:@"Shows Search Results Button %@",[self LL_hierarchyBoolDescription:self.showsSearchResultsButton]]] noneInsets];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Bookmarks Button %@",[self LL_hierarchyBoolDescription:self.showsBookmarkButton]]] noneInsets];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Cancel Button %@",[self LL_hierarchyBoolDescription:self.showsCancelButton]]] noneInsets];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Scope Bar %@",[self LL_hierarchyBoolDescription:self.showsScopeBar]]];
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [[LLTitleCellModel alloc] initWithTitle:@"Scope Titles" detailTitle:[self LL_hierarchyObjectDescription:self.scopeButtonTitles]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [[[LLTitleCellModel alloc] initWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]] noneInsets];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [[[LLTitleCellModel alloc] initWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]] noneInsets];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [[LLTitleCellModel alloc] initWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]];
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
