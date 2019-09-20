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

#pragma mark - Primary
- (void)loadData {
    [self.objectDatas removeAllObjects];
    Class cls = self.selectView.class;
    while (cls) {
        LLTitleCellCategoryModel *model = [self sectionModelWithClass:cls];
        if (model) {
            [self.objectDatas addObject:model];
        }
        cls = [cls superclass];
    }
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
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Class Name" detailTitle:NSStringFromClass(object.class)]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Address" detailTitle:[NSString stringWithFormat:@"%p",object]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Description" detailTitle:object.description]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Object" items:section];
}

- (LLTitleCellCategoryModel *)sectionModelWithView:(UIView *)view {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Layer" detailTitle:view.layer.description]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Layer Class" detailTitle:NSStringFromClass(view.layer.class)]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Content Model" detailTitle:view.LL_contentModeDescription]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld",(long)view.tag]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Interaction" detailTitle:[NSString stringWithFormat:@"User Interaction Enabled %@", view.isUserInteractionEnabled ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Multiple Touch %@", view.isMultipleTouchEnabled ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Alpha" detailTitle:[[LLFormatterTool shared] formatNumber:@(view.alpha)]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Background" detailTitle:[self colorDescription:view.backgroundColor]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Tint" detailTitle:[self colorDescription:view.tintColor]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Drawing" detailTitle:[NSString stringWithFormat:@"Opaque %@", view.isOpaque ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Hidden %@", view.isHidden ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clears Graphics Context %@", view.clearsContextBeforeDrawing ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Clip To Bounds %@", view.clipsToBounds ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Autoresizes Subviews %@", view.autoresizesSubviews ? @"On" : @"Off"]]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"View" items:section];
}

- (LLTitleCellCategoryModel *)sectionModelWithLabel:(UILabel *)label {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:label.text]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:label.attributedText == nil ? @"Attributed Text" : @"Plain Text"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Text" detailTitle:[self colorDescription:label.textColor]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:label.font.description]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Aligned %@", label.LL_textAlignmentDescription]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Lines" detailTitle:[NSString stringWithFormat:@"%ld",(long)label.numberOfLines]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Behavior" detailTitle:[NSString stringWithFormat:@"Enabled %@",label.isEnabled ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"Highlighted %@",label.isHighlighted ? @"On" : @"Off"]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Baseline" detailTitle:[NSString stringWithFormat:@"Align %@",label.LL_baselineAdjustmentDescription]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Line Break" detailTitle:label.LL_lineBreakModeDescription]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Min Font Scale" detailTitle:[[LLFormatterTool shared] formatNumber:@(label.minimumScaleFactor)]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Highlighted" detailTitle:label.highlightedTextColor.LL_description]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Shadow" detailTitle:label.shadowColor.LL_description]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Shadow Offset" detailTitle:[NSString stringWithFormat:@"w %@   h %@",[[LLFormatterTool shared] formatNumber:@(label.shadowOffset.width)], [[LLFormatterTool shared] formatNumber:@(label.shadowOffset.height)]]]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Label" items:section];
}

- (LLTitleCellCategoryModel *)sectionModelWithControl:(UIControl *)control {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Alignment" detailTitle:[NSString stringWithFormat:@"%@ Horizonally", [control LL_contentHorizontalAlignmentDescription]]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:[NSString stringWithFormat:@"%@ Vertically", [control LL_contentVerticalAlignmentDescription]]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Content" detailTitle:control.isSelected ? @"Selected" : @"Not Selected"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:control.isEnabled ? @"Enabled" : @"Not Enabled"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:nil detailTitle:control.isHighlighted ? @"Highlighted" : @"Not Highlighted"]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Control" items:section];
}

- (LLTitleCellCategoryModel *)sectionModelWithButton:(UIButton *)button {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Type" detailTitle:[button LL_typeDescription]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"State" detailTitle:[button LL_stateDescription]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Title" detailTitle:button.currentTitle]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Title" detailTitle:button.currentAttributedTitle == nil ? @"Plain Text" : @"Attributed Text"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Text Color" detailTitle:[self colorDescription:button.currentTitleColor]]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Shadow Color" detailTitle:[self colorDescription:button.currentTitleShadowColor]]];
//    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Target" detailTitle:button.allTargets.description]];
//    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Action" detailTitle:button.allTargets.description]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:button.currentImage ? nil : @"No image"]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Button" items:section];
}

- (LLTitleCellCategoryModel *)sectionModelWithImageView:(UIImageView *)imageView {
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:imageView.image ? nil : @"No image"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Highlighted" detailTitle:imageView.highlightedImage ? nil : @"No image"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Image" detailTitle:imageView.animationImages ? nil : @"No image"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Animation Image" detailTitle:imageView.animationImages ? imageView.animationImages.description : @"No image"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"Animation Highlighted" detailTitle:imageView.highlightedAnimationImages ? imageView.highlightedAnimationImages.description : @"No image"]];
    [section addObject:[[LLTitleCellModel alloc] initWithTitle:@"State" detailTitle:imageView.isHighlighted ? @"Highlighted" : @"Not Highlighted"]];
    return [[LLTitleCellCategoryModel alloc] initWithTitle:@"Image View" items:section];
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
        if (@available(iOS 13.0, *)) {
            _segmentedControl.selectedSegmentTintColor = [LLThemeManager shared].primaryColor;
        }
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

@end
