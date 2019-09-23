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
#import "UILabel+LL_Utils.h"
#import "UIControl+LL_Utils.h"
#import "UIButton+LL_Utils.h"
#import "LLFormatterTool.h"
#import "LLThemeManager.h"
#import "LLDetailTitleCell.h"
#import "UIImage+LL_Utils.h"

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
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Content Model" detailTitle:view.LL_contentModeDescription];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self modelWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)view.tag]];
    [settings addObject:model4];
    
    NSString *userInterface = [NSString stringWithFormat:@"User Interaction Enabled %@", view.isUserInteractionEnabled ? @"On" : @"Off"];
    NSString *multipleTouch = [NSString stringWithFormat:@"Multiple Touch %@", view.isMultipleTouchEnabled ? @"On" : @"Off"];
    LLTitleCellModel *model5 = [self modelWithTitle:@"Interaction" detailTitle:[@[userInterface, multipleTouch] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self submodelWithTitle:@"Alpha" detailTitle:[[LLFormatterTool shared] formatNumber:@(view.alpha)]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self submodelWithTitle:@"Background" detailTitle:[self colorDescription:view.backgroundColor]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self modelWithTitle:@"Tint" detailTitle:[self colorDescription:view.tintColor]];
    [settings addObject:model8];
    
    NSString *opaque = [NSString stringWithFormat:@"Opaque %@", view.isOpaque ? @"On" : @"Off"];
    NSString *hidden = [NSString stringWithFormat:@"Hidden %@", view.isHidden ? @"On" : @"Off"];
    NSString *context = [NSString stringWithFormat:@"Clears Graphics Context %@", view.clearsContextBeforeDrawing ? @"On" : @"Off"];
    NSString *clipToBounds = [NSString stringWithFormat:@"Clip To Bounds %@", view.clipsToBounds ? @"On" : @"Off"];
    NSString *autoresizes = [NSString stringWithFormat:@"Autoresizes Subviews %@", view.autoresizesSubviews ? @"On" : @"Off"];
    LLTitleCellModel *model9 = [self modelWithTitle:@"Drawing" detailTitle:[@[opaque, hidden, context, clipToBounds, autoresizes] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model9];

#ifdef __IPHONE_13_0
    
    LLTitleCellModel *model10 = [self modelWithTitle:@"Trait Collection" detailTitle:nil];
    [settings addObject:model10];
    
    NSString *userInterfaceStyle = nil;
    if (@available(iOS 12.0, *)) {
        switch (view.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleUnspecified: {
                userInterfaceStyle = @"Unspecified User Interface Style";
            }
                break;
            case UIUserInterfaceStyleLight: {
                userInterfaceStyle = @"Light User Interface Style";
            }
                break;
            case UIUserInterfaceStyleDark:{
                userInterfaceStyle = @"Dark User Interface Style";
            }
                break;
        }
    }
    LLTitleCellModel *model11 = [self modelWithTitle:nil detailTitle:userInterfaceStyle];
    [settings addObject:model11];
    
    NSString *verticalSizeClass = nil;
    switch (view.traitCollection.verticalSizeClass) {
        case UIUserInterfaceSizeClassUnspecified: {
            verticalSizeClass = @"Unspecified";
        }
            break;
        case UIUserInterfaceSizeClassCompact: {
            verticalSizeClass = @"Compact Vertical Size Class";
        }
            break;
        case UIUserInterfaceSizeClassRegular: {
            verticalSizeClass = @"Regular Vertical Size Class";
        }
            break;
    }
    
    LLTitleCellModel *model12 = [self modelWithTitle:nil detailTitle:verticalSizeClass];
    [settings addObject:model12];
    
    
    NSString *horizontalSizeClass = nil;
    switch (view.traitCollection.horizontalSizeClass) {
        case UIUserInterfaceSizeClassUnspecified: {
            horizontalSizeClass = @"Unspecified";
        }
            break;
        case UIUserInterfaceSizeClassCompact: {
            horizontalSizeClass = @"Compact Horizontal Size Class";
        }
            break;
        case UIUserInterfaceSizeClassRegular: {
            horizontalSizeClass = @"Regular Horizontal Size Class";
        }
            break;
    }
    
    LLTitleCellModel *model13 = [self modelWithTitle:nil detailTitle:horizontalSizeClass];
    [settings addObject:model13];
    
    NSString *layoutDirection = nil;
    if (@available(iOS 10.0, *)) {
        switch (view.traitCollection.layoutDirection) {
            case UITraitEnvironmentLayoutDirectionUnspecified:{
                layoutDirection = @"Unspecified";
            }
                break;
            case UITraitEnvironmentLayoutDirectionLeftToRight: {
                layoutDirection = @"Left To Right Layout";
            }
                break;
            case UITraitEnvironmentLayoutDirectionRightToLeft: {
                layoutDirection = @"Right To Left Layout";
            }
                break;
        }
    }
    LLTitleCellModel *model14 = [self modelWithTitle:nil detailTitle:layoutDirection];
    [settings addObject:model14];
    
#endif

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"View" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithLabel:(UILabel *)label {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    NSString *text = label.text ?: @"<nil>";
    NSString *attributedText = label.attributedText == nil ? @"Attributed Text" : @"Plain Text";
    LLTitleCellModel *model1 = [self submodelWithTitle:@"Text" detailTitle:[@[text, attributedText] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model1];

    NSString *textColor = [self colorDescription:label.textColor];
    NSString *font = label.font.description ?: @"<nil>";
    NSString *aligned = [NSString stringWithFormat:@"Aligned %@", label.LL_textAlignmentDescription];
    LLTitleCellModel *model2 = [self submodelWithTitle:@"Text" detailTitle:[@[textColor, font, aligned] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self submodelWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)label.numberOfLines]];
    [settings addObject:model3];
    
    NSString *behavior = [NSString stringWithFormat:@"Enabled %@",label.isEnabled ? @"On" : @"Off"];
    NSString *highlighted = [NSString stringWithFormat:@"Highlighted %@",label.isHighlighted ? @"On" : @"Off"];
    LLTitleCellModel *model4 = [self modelWithTitle:@"Behavior" detailTitle:[@[behavior, highlighted] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model4];

    LLTitleCellModel *model5 = [self submodelWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",label.LL_baselineAdjustmentDescription]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self submodelWithTitle:@"Line Break" detailTitle:label.LL_lineBreakModeDescription];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self modelWithTitle:@"Min Font Scale" detailTitle:[[LLFormatterTool shared] formatNumber:@(label.minimumScaleFactor)]];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self submodelWithTitle:@"Highlighted" detailTitle:[self colorDescription:label.highlightedTextColor]];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self submodelWithTitle:@"Shadow" detailTitle:[self colorDescription:label.shadowColor]];
    [settings addObject:model9];
    
    LLTitleCellModel *model10 = [self modelWithTitle:@"Shadow Offset" detailTitle:[NSString stringWithFormat:@"w %@   h %@",[[LLFormatterTool shared] formatNumber:@(label.shadowOffset.width)], [[LLFormatterTool shared] formatNumber:@(label.shadowOffset.height)]]];
    [settings addObject:model10];

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Label" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithControl:(UIControl *)control {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    NSString *alignment = [NSString stringWithFormat:@"%@ Horizonally", [control LL_contentHorizontalAlignmentDescription]];
    NSString *vertically = [NSString stringWithFormat:@"%@ Vertically", [control LL_contentVerticalAlignmentDescription]];
    LLTitleCellModel *model1 = [self modelWithTitle:@"Alignment" detailTitle:[@[alignment, vertically] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model1];
    
    NSString *selected = control.isSelected ? @"Selected" : @"Not Selected";
    NSString *enabled = control.isEnabled ? @"Enabled" : @"Not Enabled";
    NSString *highlighted = control.isHighlighted ? @"Highlighted" : @"Not Highlighted";
    
    LLTitleCellModel *model2 = [self modelWithTitle:@"Content" detailTitle:[@[selected, enabled, highlighted] componentsJoinedByString:@"\n\n"]];
    [settings addObject:model2];

    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Control" items:settings];
}

- (LLTitleCellCategoryModel *)sectionModelWithButton:(UIButton *)button {
    
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    LLTitleCellModel *model1 = [self modelWithTitle:@"Type" detailTitle:[button LL_typeDescription]];
    [settings addObject:model1];
    
    LLTitleCellModel *model2 = [self modelWithTitle:@"State" detailTitle:[button LL_stateDescription]];
    [settings addObject:model2];
    
    LLTitleCellModel *model3 = [self modelWithTitle:@"Title" detailTitle:button.currentTitle];
    [settings addObject:model3];
    
    LLTitleCellModel *model4 = [self modelWithTitle:@"Title" detailTitle:button.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"];
    [settings addObject:model4];
    
    LLTitleCellModel *model5 = [self modelWithTitle:@"Text Color" detailTitle:[self colorDescription:button.currentTitleColor]];
    [settings addObject:model5];
    
    LLTitleCellModel *model6 = [self modelWithTitle:@"Shadow Color" detailTitle:[self colorDescription:button.currentTitleShadowColor]];
    [settings addObject:model6];
    
    LLTitleCellModel *model7 = [self modelWithTitle:@"Target" detailTitle:button.allTargets.description];
    [settings addObject:model7];
    
    LLTitleCellModel *model8 = [self modelWithTitle:@"Action" detailTitle:button.allTargets.description];
    [settings addObject:model8];
    
    LLTitleCellModel *model9 = [self modelWithTitle:@"Image" detailTitle:button.currentImage ? button.currentImage.description : @"No image"];
    [settings addObject:model9];
    
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

    NSArray *rgba = [color LL_RGBA];
    return [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [[LLFormatterTool shared] formatNumber:rgba[0]], [[LLFormatterTool shared] formatNumber:rgba[1]], [[LLFormatterTool shared] formatNumber:rgba[2]], [[LLFormatterTool shared] formatNumber:rgba[3]]];
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
