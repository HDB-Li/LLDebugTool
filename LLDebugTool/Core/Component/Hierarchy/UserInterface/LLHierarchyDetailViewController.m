//
//  LLHierarchyDetailViewController.m
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

#import "LLHierarchyDetailViewController.h"
#import "LLConst.h"
#import "UIView+LL_Utils.h"
#import "LLFactory.h"
#import "LLMacros.h"
#import "LLConfig.h"
#import "UIColor+LL_Utils.h"
#import "UIButton+LL_Utils.h"
#import "LLFormatterTool.h"
#import "LLThemeManager.h"
#import "LLDetailTitleCell.h"
#import "UIImage+LL_Utils.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"

@interface LLHierarchyDetailViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *objectDatas;

@property (nonatomic, strong) NSMutableArray *sizeDatas;

@end

@implementation LLHierarchyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.selectView, @"SelectView can't be nil");
    
    self.navigationItem.title = @"Hierarchy Detail";
    self.objectDatas = [[NSMutableArray alloc] init];
    self.sizeDatas = [[NSMutableArray alloc] init];
    
    UIView *headerView = ({
        UIView *view = [LLFactory getView];
        view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 30 + kLLGeneralMargin * 2);
        view;
    });
    
    [headerView addSubview:self.segmentedControl];
    
    self.tableView.tableHeaderView = headerView;
    
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[LLDetailTitleCell class]]) {
        LLDetailTitleCell *detailCell = (LLDetailTitleCell *)cell;
        detailCell.detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    LLTitleCellModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    cell.separatorInset = model.separatorInsets;
    return cell;
}

#pragma mark - Primary
- (void)loadData {
    [self.objectDatas removeAllObjects];
    Class cls = self.selectView.class;
    while (cls && cls != [NSObject class]) {
        LLTitleCellCategoryModel *model = [self sectionModelWithClass:cls];
        if (model) {
            [self.objectDatas addObject:model];
        }
        cls = [cls superclass];
    }
    [self.objectDatas insertObject:[self sectionModelWithClass:[NSObject class]] atIndex:0];
    [self.dataArray removeAllObjects];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.dataArray addObjectsFromArray:self.objectDatas];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.dataArray addObjectsFromArray:self.sizeDatas];
    }
    [self.tableView reloadData];
}

- (LLTitleCellCategoryModel *)sectionModelWithClass:(Class)cls {
    if (cls == [NSObject class]) {
        return [self sectionModelWithObject:self.selectView];
    } else if (cls == [UIView class]) {
        return [self sectionModelWithView:self.selectView];
    } else if (cls == [UILabel class]) {
        UILabel *label = (UILabel *)self.selectView;
        return [self sectionModelWithLabel:label];
    } else if (cls == [UIControl class]) {
        UIControl *control = (UIControl *)self.selectView;
        return [self sectionModelWithControl:control];
    } else if (cls == [UIButton class]) {
        UIButton *button = (UIButton *)self.selectView;
        return [self sectionModelWithButton:button];
    } else if (cls == [UIImageView class]) {
        UIImageView *imageView = (UIImageView *)self.selectView;
        return [self sectionModelWithImageView:imageView];
    }
    return nil;
}


- (LLTitleCellCategoryModel *)sectionModelWithObject:(NSObject *)object {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Class Name" detailTitle:NSStringFromClass(object.class)];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self submodelWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p",object]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Description" detailTitle:object.description];
    [settings addObject:model3];
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Object" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithView:(UIView *)view {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Layer" detailTitle:view.layer.description];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self modelWithTitle:@"Layer Class" detailTitle:NSStringFromClass(view.layer.class)];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Content Model" detailTitle:[LLEnumDescription viewContentModeDescription:view.contentMode]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self modelWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)view.tag]];
    [settings addObject:model4];
        
    LLTitleCellModel *model5 = [self submodelWithTitle:@"Interaction" detailTitle:[NSString stringWithFormat:@"User Interaction Enabled %@", view.isUserInteractionEnabled ? @"On" : @"Off"]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Touch %@", view.isMultipleTouchEnabled ? @"On" : @"Off"]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self submodelWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(view.alpha)]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self submodelWithTitle:@"Background" detailTitle:[self colorDescription:view.backgroundColor]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self modelWithTitle:@"Tint" detailTitle:[self colorDescription:view.tintColor]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self submodelWithTitle:@"Drawing" detailTitle:[NSString stringWithFormat:@"Opaque %@", view.isOpaque ? @"On" : @"Off"]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Hidden %@", view.isHidden ? @"On" : @"Off"]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clears Graphics Context %@", view.clearsContextBeforeDrawing ? @"On" : @"Off"]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clip To Bounds %@", view.clipsToBounds ? @"On" : @"Off"]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Autoresizes Subviews %@", view.autoresizesSubviews ? @"On" : @"Off"]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self submodelWithTitle:@"Trait Collection" detailTitle:nil];
    [settings addObject:model15];
    
    if (@available(iOS 12.0, *)) {
        LLTitleCellModel *model16 = [self submodelWithTitle:nil detailTitle:[LLEnumDescription userInterfaceStyleDescription:view.traitCollection.userInterfaceStyle]];
        [settings addObject:model16];
    }
    
    LLTitleCellModel *model17 = [self submodelWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:view.traitCollection.verticalSizeClass]]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self submodelWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@",[LLEnumDescription userInterfaceSizeClassDescription:view.traitCollection.horizontalSizeClass]]];
    [settings addObject:model18];
    
    if (@available(iOS 10.0, *)) {
        LLTitleCellModel *model19 = [self modelWithTitle:nil detailTitle:[LLEnumDescription traitEnvironmentLayoutDirectionDescription:view.traitCollection.layoutDirection]];
        [settings addObject:model19];
    }

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"View" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithLabel:(UILabel *)label {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Text" detailTitle:label.text ?: @"<nil>"];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self submodelWithTitle:nil detailTitle:label.attributedText == nil ? @"Attributed Text" : @"Plain Text"];
    [settings addObject:model2];

    LLTitleCellModel *model3 = [self submodelWithTitle:@"Text" detailTitle:[self colorDescription:label.textColor]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self submodelWithTitle:nil detailTitle:label.font.description ?: @"<nil>"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", [LLEnumDescription textAlignmentDescription:label.textAlignment]]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self submodelWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)label.numberOfLines]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self submodelWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Enabled %@",label.isEnabled ? @"On" : @"Off"]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Highlighted %@",label.isHighlighted ? @"On" : @"Off"]];
    [settings addObject:model8];

    LLTitleCellModel *model9 = [self submodelWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",[LLEnumDescription baselineAdjustmentDescription:label.baselineAdjustment]]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self submodelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:label.lineBreakMode]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self modelWithTitle:@"Min Font Scale" detailTitle:[LLFormatterTool formatNumber:@(label.minimumScaleFactor)]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self submodelWithTitle:@"Highlighted" detailTitle:[self colorDescription:label.highlightedTextColor]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self submodelWithTitle:@"Shadow" detailTitle:[self colorDescription:label.shadowColor]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self modelWithTitle:@"Shadow Offset" detailTitle:[NSString stringWithFormat:@"w %@   h %@",[LLFormatterTool formatNumber:@(label.shadowOffset.width)], [LLFormatterTool formatNumber:@(label.shadowOffset.height)]]];
    [settings addObject:model14];

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Label" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithControl:(UIControl *)control {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [LLEnumDescription controlContentHorizontalAlignmentDescription:control.contentHorizontalAlignment]]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [LLEnumDescription controlContentVerticalAlignmentDescription:control.contentVerticalAlignment]]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Content" detailTitle:control.isSelected ? @"Selected" : @"Not Selected"];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self submodelWithTitle:nil detailTitle:control.isEnabled ? @"Enabled" : @"Not Enabled"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self modelWithTitle:nil detailTitle:control.isHighlighted ? @"Highlighted" : @"Not Highlighted"];
    [settings addObject:model5];

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Control" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithButton:(UIButton *)button {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self modelWithTitle:@"Type" detailTitle:[LLEnumDescription buttonTypeDescription:button.buttonType]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self submodelWithTitle:@"State" detailTitle:[LLEnumDescription controlStateDescription:button.state]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Title" detailTitle:button.currentTitle ?: @"<nil>"];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self submodelWithTitle:nil detailTitle:button.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self submodelWithTitle:@"Text Color" detailTitle:[self colorDescription:button.currentTitleColor]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self modelWithTitle:@"Shadow Color" detailTitle:[self colorDescription:button.currentTitleShadowColor]];
    [settings addObject:model6];
    
    id target = button.allTargets.allObjects.firstObject;
    LLTitleCellModel *model7 = [self submodelWithTitle:@"Target" detailTitle:target ? [NSString stringWithFormat:@"%@",target] : @"<nil>"];
    [settings addObject:model7];

    LLTitleCellModel *model8 = [self modelWithTitle:@"Action" detailTitle:[button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject ?: @"<null>"];;
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self modelWithTitle:@"Image" detailTitle:button.currentImage ? button.currentImage.description : @"No image"];
    [settings addObject:model9];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model10 = [self submodelWithTitle:@"Shadow Offset" detailTitle:[NSString stringWithFormat:@"w %@   h %@",[LLFormatterTool formatNumber:@(button.titleShadowOffset.width)], [LLFormatterTool formatNumber:@(button.titleShadowOffset.height)]]];
    [settings addObject:model10];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model11 = [self submodelWithTitle:@"On Highlight" detailTitle:button.reversesTitleShadowWhenHighlighted ? @"Shadow Reverses" : @"Normal Shadow"];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self submodelWithTitle:nil detailTitle:button.showsTouchWhenHighlighted ? @"Shows Touch" : @"Doesn't Show Touch"];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self submodelWithTitle:nil detailTitle:button.adjustsImageWhenHighlighted ? @"Adjusts Image" : @"No Image Adjustment"];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self submodelWithTitle:@"When Disabled" detailTitle:button.adjustsImageWhenDisabled ? @"Adjusts Image" : @"No Image Adjustment"];
    [settings addObject:model14];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    LLTitleCellModel *model15 = [self modelWithTitle:@"Line Break" detailTitle:[LLEnumDescription lineBreakModeDescription:button.lineBreakMode]];
    [settings addObject:model15];
#pragma clang diagnostic pop
    
    LLTitleCellModel *model16 = [self submodelWithTitle:@"Content Insets" detailTitle:[NSString stringWithFormat:@"top %@    bottom %@", [LLFormatterTool formatNumber:@(button.contentEdgeInsets.top)], [LLFormatterTool formatNumber:@(button.contentEdgeInsets.bottom)]]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"left %@    right %@",[LLFormatterTool formatNumber:@(button.contentEdgeInsets.left)],[LLFormatterTool formatNumber:@(button.contentEdgeInsets.right)]]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self submodelWithTitle:@"Title Insets" detailTitle:[NSString stringWithFormat:@"top %@    bottom %@", [LLFormatterTool formatNumber:@(button.titleEdgeInsets.top)], [LLFormatterTool formatNumber:@(button.titleEdgeInsets.bottom)]]];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"left %@    right %@",[LLFormatterTool formatNumber:@(button.titleEdgeInsets.left)],[LLFormatterTool formatNumber:@(button.titleEdgeInsets.right)]]];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [self submodelWithTitle:@"Image Insets" detailTitle:[NSString stringWithFormat:@"top %@    bottom %@", [LLFormatterTool formatNumber:@(button.imageEdgeInsets.top)], [LLFormatterTool formatNumber:@(button.imageEdgeInsets.bottom)]]];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"left %@    right %@",[LLFormatterTool formatNumber:@(button.imageEdgeInsets.left)],[LLFormatterTool formatNumber:@(button.imageEdgeInsets.right)]]];
    [settings addObject:model21];
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Button" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithImageView:(UIImageView *)imageView {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self modelWithTitle:@"Image" detailTitle:imageView.image ? imageView.image.description : @"No image"];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self modelWithTitle:@"Highlighted" detailTitle:imageView.highlightedImage ? imageView.highlightedImage.description : @"No image"];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self modelWithTitle:@"State" detailTitle:imageView.isHighlighted ? @"Highlighted" : @"Not Highlighted"];
    [settings addObject:model3];
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Image View" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithTextField:(UITextField *)textField {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Plain Text" detailTitle:textField.text ?: @"<empty string>"];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self submodelWithTitle:@"Attributed Text" detailTitle:textField.attributedText ? textField.attributedText.string : @"<empty string>"];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Allows Editing Attributes %@",textField.allowsEditingTextAttributes ? @"On" : @"Off"]];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self submodelWithTitle:@"Color" detailTitle:[self colorDescription:textField.textColor]];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self submodelWithTitle:@"Font" detailTitle:textField.font.description];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self submodelWithTitle:@"Alignment" detailTitle:[LLEnumDescription textAlignmentDescription:textField.textAlignment]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self modelWithTitle:@"Placeholder" detailTitle:textField.placeholder ?: (textField.attributedPlaceholder ? textField.attributedPlaceholder.string : @"<empty string>")];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self submodelWithTitle:@"Background" detailTitle:textField.background ? textField.background.description : @"No image"];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self modelWithTitle:@"Disabled" detailTitle:textField.disabledBackground ? textField.disabledBackground.description : @"No image"];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self modelWithTitle:@"Border Style" detailTitle:[LLEnumDescription textBorderStyleDescription:textField.borderStyle]];
    [settings addObject:model10];
    
    LLTitleCellModel *model11 = [self submodelWithTitle:@"Clear Button" detailTitle:[LLEnumDescription textFieldViewModeDescription:textField.clearButtonMode]];
    [settings addObject:model11];
    
    LLTitleCellModel *model12 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clear when editing begins %@",textField.clearsOnBeginEditing ? @"On" : @"Off"]];
    [settings addObject:model12];
    
    LLTitleCellModel *model13 = [self submodelWithTitle:@"Min Font Size" detailTitle:[LLFormatterTool formatNumber:@(textField.minimumFontSize)]];
    [settings addObject:model13];
    
    LLTitleCellModel *model14 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Adjusts to Fit %@",textField.adjustsFontSizeToFitWidth ? @"On" : @"Off"]];
    [settings addObject:model14];
    
    LLTitleCellModel *model15 = [self submodelWithTitle:@"Capitalization" detailTitle:[LLEnumDescription textAutocapitalizationTypeDescription:textField.autocapitalizationType]];
    [settings addObject:model15];
    
    LLTitleCellModel *model16 = [self submodelWithTitle:@"Correction" detailTitle:[LLEnumDescription textAutocorrectionTypeDescription:textField.autocorrectionType]];
    [settings addObject:model16];
    
    LLTitleCellModel *model17 = [self submodelWithTitle:@"Keyboard" detailTitle:[LLEnumDescription keyboardTypeDescription:textField.keyboardType]];
    [settings addObject:model17];
    
    LLTitleCellModel *model18 = [self submodelWithTitle:@"Appearance" detailTitle:[LLEnumDescription keyboardAppearanceDescription:textField.keyboardAppearance]];
    [settings addObject:model18];
    
    LLTitleCellModel *model19 = [self submodelWithTitle:@"Return Key" detailTitle:[LLEnumDescription returnKeyTypeDescription:textField.returnKeyType]];
    [settings addObject:model19];
    
    LLTitleCellModel *model20 = [self submodelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Auto-enable Return Key %@", textField.enablesReturnKeyAutomatically ? @"On" : @"Off"]];
    [settings addObject:model20];
    
    LLTitleCellModel *model21 = [self modelWithTitle:nil detailTitle:[NSString stringWithFormat:@"Secure Entry %@",textField.secureTextEntry ? @"On" : @"Off"]];
    [settings addObject:model21];
    
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Text Field" items:settings];
}

- (LLTitleCellModel *)modelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    return [self modelWithTitle:title detailTitle:detailTitle insets:UIEdgeInsetsMake(0, kLLGeneralMargin, 0, 0)];
}

- (LLTitleCellModel *)submodelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle {
    return [self modelWithTitle:title detailTitle:detailTitle insets:UIEdgeInsetsMake(0, LL_SCREEN_WIDTH, 0, 0)];
}

- (LLTitleCellModel *)modelWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle insets:(UIEdgeInsets)insets {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:title detailTitle:detailTitle];
    model.separatorInsets = insets;
    return model;
}

- (NSString *)colorDescription:(UIColor *_Nullable)color {
    if (!color) {
        return @"<nil color>";
    }
    
    NSString *colorName = [color LL_systemColorName];
    if (colorName) {
        return colorName;
    }
    
    NSArray *rgba = [color LL_RGBA];
    return [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [LLFormatterTool formatNumber:rgba[0]], [LLFormatterTool formatNumber:rgba[1]], [LLFormatterTool formatNumber:rgba[2]], [LLFormatterTool formatNumber:rgba[3]]];
}

#pragma mark - Getters and setters
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [LLFactory getSegmentedControl:nil frame:CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.view.LL_width - kLLGeneralMargin * 2, 30) items:@[@"Object", @"Size"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].primaryColor} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].backgroundColor} forState:UIControlStateSelected];
        _segmentedControl.backgroundColor = [LLThemeManager shared].containerColor;
        _segmentedControl.tintColor = [LLThemeManager shared].primaryColor;
#ifdef __IPHONE_13_0
        if (@available(iOS 13.0, *)) {
            _segmentedControl.selectedSegmentTintColor = [LLThemeManager shared].primaryColor;
        }
#endif
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

@end
