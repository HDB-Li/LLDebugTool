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

@implementation NSObject (LL_Hierarchy)

- (NSArray <LLTitleCellCategoryModel *>*)LL_hierarchyCategoryModels {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Class Name" detailTitle:NSStringFromClass(self.class)];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p",self]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Description" detailTitle:self.description];
    [settings addObject:model3];
    
    return @[[[LLTitleCellCategoryModel alloc] initWithTitle:@"Object" items:settings]];
}

- (LLTitleCellModel *)LL_normalInsetsCellModelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    return [self LL_cellModelWithTitle:title detailTitle:detailTitle insets:UIEdgeInsetsMake(0, kLLGeneralMargin, 0, 0)];
}

- (LLTitleCellModel *)LL_noneInsetsCellModelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    return [self LL_cellModelWithTitle:title detailTitle:detailTitle insets:UIEdgeInsetsMake(0, LL_SCREEN_WIDTH, 0, 0)];
}

- (LLTitleCellModel *)LL_cellModelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle insets:(UIEdgeInsets)insets {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:title detailTitle:detailTitle];
    model.separatorInsets = insets;
    return model;
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
    NSString *text = @"<nil>";
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            text = (NSString *)obj;
        } else {
            text = [NSString stringWithFormat:@"%@",obj];
        }
    }
    return text;
}

- (NSString *)LL_hierarchySizeDescription:(CGSize)size {
    return [NSString stringWithFormat:@"w %@   h %@",[LLFormatterTool formatNumber:@(size.width)], [LLFormatterTool formatNumber:@(size.height)]];
}

- (NSString *)LL_hierarchyInsetsTopBottomDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"top %@    bottom %@",[LLFormatterTool formatNumber:@(insets.top)], [LLFormatterTool formatNumber:@(insets.bottom)]];
}

- (NSString *)LL_hierarchyInsetsLeftRightDescription:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"left %@    right %@",[LLFormatterTool formatNumber:@(insets.left)], [LLFormatterTool formatNumber:@(insets.right)]];
}

@end

@implementation UIView (LL_Hierarchy)

- (NSArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Layer" detailTitle:self.layer.description];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_normalInsetsCellModelWithTitle:@"Layer Class" detailTitle:NSStringFromClass(self.layer.class)];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Content Model" detailTitle:[LLEnumDescription viewContentModeDescription:self.contentMode]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Interaction" detailTitle:[NSString stringWithFormat:@"User Interaction Enabled %@",[self LL_hierarchyBoolDescription:self.isUserInteractionEnabled]]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Touch %@", [self LL_hierarchyBoolDescription:self.isMultipleTouchEnabled]]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(self.alpha)]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_noneInsetsCellModelWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.backgroundColor]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:@"Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self LL_noneInsetsCellModelWithTitle:@"Drawing" detailTitle:[NSString stringWithFormat:@"Opaque %@",[self LL_hierarchyBoolDescription:self.isOpaque]]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Hidden %@",[self LL_hierarchyBoolDescription:self.isHidden]]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clears Graphics Context %@",[self LL_hierarchyBoolDescription:self.clearsContextBeforeDrawing]]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clip To Bounds %@",[self LL_hierarchyBoolDescription:self.clipsToBounds]]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Autoresizes Subviews %@", [self LL_hierarchyBoolDescription:self.autoresizesSubviews]]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self LL_noneInsetsCellModelWithTitle:@"Trait Collection" detailTitle:nil];
    [settings addObject:model15];
    
    if (@available(iOS 12.0, *)) {
        LLTitleCellModel *model16 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[LLEnumDescription userInterfaceStyleDescription:self.traitCollection.userInterfaceStyle]];
        [settings addObject:model16];
    }
    
    LLTitleCellModel *model17 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.verticalSizeClass]]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.horizontalSizeClass]]];
    [settings addObject:model18];
    
    if (@available(iOS 10.0, *)) {
        LLTitleCellModel *model19 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[LLEnumDescription traitEnvironmentLayoutDirectionDescription:self.traitCollection.layoutDirection]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Text" detailTitle:[self LL_hierarchyObjectDescription:self.text]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:self.attributedText == nil ? @"Plain Text" : @"Attributed Text"];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.textColor]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyObjectDescription:self.font.description]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [LLEnumDescription textAlignmentDescription:self.textAlignment]]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_noneInsetsCellModelWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)self.numberOfLines]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Enabled %@",[self LL_hierarchyBoolDescription:self.isEnabled]]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Highlighted %@", [self LL_hierarchyBoolDescription:self.isHighlighted]]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_noneInsetsCellModelWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",[LLEnumDescription baselineAdjustmentDescription:self.baselineAdjustment]]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self LL_noneInsetsCellModelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self LL_normalInsetsCellModelWithTitle:@"Min Font Scale" detailTitle:[LLFormatterTool formatNumber:@(self.minimumScaleFactor)]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_noneInsetsCellModelWithTitle:@"Highlighted" detailTitle:[self LL_hierarchyColorDescription:self.highlightedTextColor]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_noneInsetsCellModelWithTitle:@"Shadow" detailTitle:[self LL_hierarchyColorDescription:self.shadowColor]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_normalInsetsCellModelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.shadowOffset]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [LLEnumDescription controlContentHorizontalAlignmentDescription:self.contentHorizontalAlignment]]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [LLEnumDescription controlContentVerticalAlignmentDescription:self.contentVerticalAlignment]]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Content" detailTitle:self.isSelected ? @"Selected" : @"Not Selected"];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:self.isEnabled ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted"];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_normalInsetsCellModelWithTitle:@"Type" detailTitle:[LLEnumDescription buttonTypeDescription:self.buttonType]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"State" detailTitle:[LLEnumDescription controlStateDescription:self.state]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Title" detailTitle:[self LL_hierarchyObjectDescription:self.currentTitle]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:self.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Text Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleColor]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:@"Shadow Color" detailTitle:[self LL_hierarchyColorDescription:self.currentTitleShadowColor]];
    [settings addObject:model6];
    
    id target = self.allTargets.allObjects.firstObject;
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@",target] : @"<nil>"];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_normalInsetsCellModelWithTitle:@"Action" detailTitle:[self LL_hierarchyObjectDescription:[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject]];;
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:@"Image" detailTitle:[self LL_hierarchyImageDescription:self.currentImage]];
    [settings addObject:model9];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model10 = [self LL_noneInsetsCellModelWithTitle:@"Shadow Offset" detailTitle:[self LL_hierarchySizeDescription:self.titleShadowOffset]];
    [settings addObject:model10];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model11 = [self LL_noneInsetsCellModelWithTitle:@"On Highlight" detailTitle:self.reversesTitleShadowWhenHighlighted ? @"Shadow Reverses" : @"Normal Shadow"];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:self.showsTouchWhenHighlighted ? @"Shows Touch" : @"Doesn't Show Touch"];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:self.adjustsImageWhenHighlighted ? @"Adjusts Image" : @"No Image Adjustment"];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_noneInsetsCellModelWithTitle:@"When Disabled" detailTitle:self.adjustsImageWhenDisabled ? @"Adjusts Image" : @"No Image Adjustment"];
    [settings addObject:model14];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model15 = [self LL_normalInsetsCellModelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:self.lineBreakMode]];
    [settings addObject:model15];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model16 = [self LL_noneInsetsCellModelWithTitle:@"Content Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.contentEdgeInsets]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.contentEdgeInsets]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self LL_noneInsetsCellModelWithTitle:@"Title Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.titleEdgeInsets]];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.titleEdgeInsets]];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [self LL_noneInsetsCellModelWithTitle:@"Image Insets" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.imageEdgeInsets]];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.imageEdgeInsets]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_normalInsetsCellModelWithTitle:@"Image" detailTitle: [self LL_hierarchyImageDescription:self.image]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_normalInsetsCellModelWithTitle:@"Highlighted" detailTitle: [self LL_hierarchyImageDescription:self.highlightedImage]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_normalInsetsCellModelWithTitle:@"State" detailTitle:self.isHighlighted ? @"Highlighted" : @"Not Highlighted"];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Plain Text" detailTitle:[self LL_hierarchyObjectDescription:self.text]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Attributed Text" detailTitle:[self LL_hierarchyObjectDescription:self.attributedText.string]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Allows Editing Attributes %@", [self LL_hierarchyBoolDescription:self.allowsEditingTextAttributes]]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.textColor]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Font" detailTitle:[self LL_hierarchyObjectDescription:self.font.description]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_noneInsetsCellModelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:self.textAlignment]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_normalInsetsCellModelWithTitle:@"Placeholder" detailTitle:[self LL_hierarchyObjectDescription:self.placeholder ?: self.attributedPlaceholder.string]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_noneInsetsCellModelWithTitle:@"Background" detailTitle: [self LL_hierarchyImageDescription:self.background]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:@"Disabled" detailTitle: [self LL_hierarchyImageDescription:self.disabledBackground]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self LL_normalInsetsCellModelWithTitle:@"Border Style" detailTitle:[LLEnumDescription textBorderStyleDescription:self.borderStyle]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self LL_noneInsetsCellModelWithTitle:@"Clear Button" detailTitle:[LLEnumDescription textFieldViewModeDescription:self.clearButtonMode]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clear when editing begins %@", [self LL_hierarchyBoolDescription:self.clearsOnBeginEditing]]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_noneInsetsCellModelWithTitle:@"Min Font Size" detailTitle:[LLFormatterTool formatNumber:@(self.minimumFontSize)]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Adjusts to Fit %@",[self LL_hierarchyBoolDescription:self.adjustsFontSizeToFitWidth]]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self LL_noneInsetsCellModelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:self.autocapitalizationType]];
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [self LL_noneInsetsCellModelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:self.autocorrectionType]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [self LL_noneInsetsCellModelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:self.keyboardType]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self LL_noneInsetsCellModelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:self.keyboardAppearance]];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [self LL_noneInsetsCellModelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:self.returnKeyType]];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Auto-enable Return Key %@", [self LL_hierarchyBoolDescription:self.enablesReturnKeyAutomatically]]];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Secure Entry %@",[self LL_hierarchyBoolDescription:self.secureTextEntry]]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Behavior" detailTitle:self.isMomentary ? @"Momentary" : @"Persistent Selection"];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_normalInsetsCellModelWithTitle:@"Segments" detailTitle:[NSString stringWithFormat:@"%ld",self.numberOfSegments]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Selected Index" detailTitle:[NSString stringWithFormat:@"%ld",self.selectedSegmentIndex]];
    [settings addObject:model3];
    
    if (@available(iOS 13.0, *)) {
        LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:@"Title" detailTitle:[self LL_hierarchyObjectDescription:self.largeContentTitle]];
        [settings addObject:model4];
        
        LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Image" detailTitle: [self LL_hierarchyImageDescription:self.largeContentImage]];
        [settings addObject:model5];
    }
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:@"Selected" detailTitle:[self isEnabledForSegmentAtIndex:self.selectedSegmentIndex] ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Offset" detailTitle:[self LL_hierarchySizeDescription:[self contentOffsetForSegmentAtIndex:self.selectedSegmentIndex]]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_noneInsetsCellModelWithTitle:@"Size Mode" detailTitle:self.apportionsSegmentWidthsByContent ? @"Proportional to Content" : @"Equal Widths"];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:@"Width" detailTitle:[LLFormatterTool formatNumber:@([self widthForSegmentAtIndex:self.selectedSegmentIndex])]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Current" detailTitle:[LLFormatterTool formatNumber:@(self.value)]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_normalInsetsCellModelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:@"Min Image" detailTitle: [self LL_hierarchyImageDescription:self.minimumValueImage]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_normalInsetsCellModelWithTitle:@"Max Image" detailTitle: [self LL_hierarchyImageDescription:self.maximumValueImage]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_noneInsetsCellModelWithTitle:@"Min Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.minimumTrackTintColor]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Max Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.maximumTrackTintColor]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_normalInsetsCellModelWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.tintColor]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:@"Events" detailTitle:[NSString stringWithFormat:@"Continuous Update %@", [self LL_hierarchyBoolDescription:self.continuous]]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"State" detailTitle:[self LL_hierarchyBoolDescription:self.isOn]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"On Tint" detailTitle:[self LL_hierarchyColorDescription:self.onTintColor]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_normalInsetsCellModelWithTitle:@"Thumb Tint" detailTitle:[self LL_hierarchyColorDescription:self.thumbTintColor]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Style" detailTitle:[LLEnumDescription activityIndicatorViewStyleDescription:self.activityIndicatorViewStyle]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Color" detailTitle:[self LL_hierarchyColorDescription:self.color]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Animating %@", [self LL_hierarchyBoolDescription:self.isAnimating]]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Hides When Stopped %@", [self LL_hierarchyBoolDescription:self.hidesWhenStopped]]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_normalInsetsCellModelWithTitle:@"Style" detailTitle:[LLEnumDescription progressViewStyleDescription:self.progressViewStyle]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_normalInsetsCellModelWithTitle:@"Progress" detailTitle:[LLFormatterTool formatNumber:@(self.progress)]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Progress Tint" detailTitle:[self LL_hierarchyColorDescription:self.progressTintColor]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:@"Track Tint" detailTitle:[self LL_hierarchyColorDescription:self.trackTintColor]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Progress Image" detailTitle:[self LL_hierarchyImageDescription:self.progressImage]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:@"Track Image" detailTitle:[self LL_hierarchyImageDescription:self.trackImage]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Pages" detailTitle:[NSString stringWithFormat:@"%ld",self.numberOfPages]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Current Page" detailTitle:[NSString stringWithFormat:@"%ld",self.currentPage]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Hides for Single Page %@",[self LL_hierarchyBoolDescription:self.hidesForSinglePage]]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Defers Page Display %@", [self LL_hierarchyBoolDescription:self.defersCurrentPageDisplay]]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Tint Color" detailTitle:[self LL_hierarchyColorDescription:self.pageIndicatorTintColor]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:@"Current Page" detailTitle:[self LL_hierarchyColorDescription:self.currentPageIndicatorTintColor]];
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
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Value" detailTitle:[LLFormatterTool formatNumber:@(self.value)]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Minimum" detailTitle:[LLFormatterTool formatNumber:@(self.minimumValue)]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Maximum" detailTitle:[LLFormatterTool formatNumber:@(self.maximumValue)]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:@"Step" detailTitle:[LLFormatterTool formatNumber:@(self.stepValue)]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Autorepeat %@",[self LL_hierarchyBoolDescription:self.autorepeat]]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Continuous %@",[self LL_hierarchyBoolDescription:self.continuous]]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Wrap %@",[self LL_hierarchyBoolDescription:self.wraps]]];
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
    
    LLTitleCellModel *model1 = [self LL_normalInsetsCellModelWithTitle:@"Style" detailTitle:[LLEnumDescription scrollViewIndicatorStyleDescription:self.indicatorStyle]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Indicators" detailTitle:[NSString stringWithFormat:@"Shows Horizontal Indicator %@",[self LL_hierarchyBoolDescription:self.showsHorizontalScrollIndicator]]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Shows Vertical Indicator %@",[self LL_hierarchyBoolDescription:self.showsVerticalScrollIndicator]]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_noneInsetsCellModelWithTitle:@"Scrolling" detailTitle:[NSString stringWithFormat:@"Scrolling %@", self.scrollEnabled ? @"Enabled" : @"Not Enabled"]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Paging %@", self.pagingEnabled ? @"Enabled" : @"Disabled"]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Direction Lock %@",self.isDirectionalLockEnabled ? @"Enabled" : @"Disabled"]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Bounce" detailTitle:[NSString stringWithFormat:@"Bounces %@",[self LL_hierarchyBoolDescription:self.bounces]]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Bounce Horizontal %@",[self LL_hierarchyBoolDescription:self.alwaysBounceHorizontal]]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Bounce Vertical %@",[self LL_hierarchyBoolDescription:self.alwaysBounceVertical]]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self LL_noneInsetsCellModelWithTitle:@"Zoom Min" detailTitle:[LLFormatterTool formatNumber:@(self.minimumZoomScale)]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self LL_normalInsetsCellModelWithTitle:@"Max" detailTitle:[LLFormatterTool formatNumber:@(self.maximumZoomScale)]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_noneInsetsCellModelWithTitle:@"Touch" detailTitle:[NSString stringWithFormat:@"Zoom Bounces %@",[self LL_hierarchyBoolDescription:self.isZoomBouncing]]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Delays Content Touches %@",[self LL_hierarchyBoolDescription:self.delaysContentTouches]]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Cancellable Content Touches %@",[self LL_hierarchyBoolDescription:self.canCancelContentTouches]]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self LL_normalInsetsCellModelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription scrollViewKeyboardDismissModeDescription:self.keyboardDismissMode]];
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
    
    LLTitleCellModel *model1 = [self LL_noneInsetsCellModelWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld",self.numberOfSections]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self LL_noneInsetsCellModelWithTitle:@"Style" detailTitle:[LLEnumDescription tableViewStyleDescription:self.style]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self LL_noneInsetsCellModelWithTitle:@"Separator" detailTitle:[LLEnumDescription tableViewCellSeparatorStyleDescription:self.separatorStyle]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyColorDescription:self.separatorColor]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self LL_noneInsetsCellModelWithTitle:@"Data Source" detailTitle:[self LL_hierarchyObjectDescription:self.dataSource]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self LL_normalInsetsCellModelWithTitle:@"Delegate" detailTitle:[self LL_hierarchyObjectDescription:self.delegate]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self LL_noneInsetsCellModelWithTitle:@"Separator Inset" detailTitle:[self LL_hierarchyInsetsTopBottomDescription:self.separatorInset]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[self LL_hierarchyInsetsLeftRightDescription:self.separatorInset]];
    [settings addObject:model8];
    
    if (@available(iOS 11.0, *)) {
        LLTitleCellModel *model9 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[LLEnumDescription tableViewSeparatorInsetReferenceDescription:self.separatorInsetReference]];
        [settings addObject:model9];
    }
    
    LLTitleCellModel *model10 = [self LL_noneInsetsCellModelWithTitle:@"Selection" detailTitle:self.allowsSelection ? @"Allowed" : @"Disabled"];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self LL_noneInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self LL_noneInsetsCellModelWithTitle:@"Edit Selection" detailTitle:self.allowsSelectionDuringEditing ? @"Allowed" : @"Disabled"];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self LL_normalInsetsCellModelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Selection %@",self.allowsMultipleSelection ? @"" : @"Disabled"]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self LL_noneInsetsCellModelWithTitle:@"Min Display" detailTitle:[NSString stringWithFormat:@"%ld",self.sectionIndexMinimumDisplayRowCount]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self LL_noneInsetsCellModelWithTitle:@"Text" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexColor]];
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [self LL_noneInsetsCellModelWithTitle:@"Background" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexBackgroundColor]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [self LL_normalInsetsCellModelWithTitle:@"Tracking" detailTitle:[self LL_hierarchyColorDescription:self.sectionIndexTrackingBackgroundColor]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self LL_noneInsetsCellModelWithTitle:@"Row Height" detailTitle:[LLFormatterTool formatNumber:@(self.rowHeight)]];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [self LL_noneInsetsCellModelWithTitle:@"Section Header" detailTitle:[LLFormatterTool formatNumber:@(self.sectionHeaderHeight)]];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [self LL_normalInsetsCellModelWithTitle:@"Section Footer" detailTitle:[LLFormatterTool formatNumber:@(self.sectionFooterHeight)]];
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
