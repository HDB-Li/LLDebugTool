//
//  LLFactory.m
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

#import "LLFactory.h"

#import "LLDebugConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"

@implementation LLFactory

#pragma mark - UIView
+ (UIView *)getView {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

+ (UIView *)getLineView:(CGRect)frame
              superView:(UIView *)superView {
    UIView *view = [self getView];
    view.backgroundColor = [LLThemeManager shared].primaryColor;
    [superView addSubview:view];
    return view;
}

#pragma mark - UILabel
+ (UILabel *)getLabel {
    return [self getLabel:nil];
}

+ (UILabel *)getLabel:(UIView *)toView {
    return [self getLabel:toView
                    frame:CGRectZero];
}

+ (UILabel *)getLabel:(UIView *)toView
                frame:(CGRect)frame {
    return [self getLabel:toView frame:frame text:nil font:17 textColor:nil];
}

+ (UILabel *)getLabel:(UIView *)toView
                frame:(CGRect)frame
                 text:(NSString *)text
                 font:(CGFloat)fontSize
            textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [toView addSubview:label];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    if (textColor) {
        label.textColor = textColor;
    }
    return label;
}

#pragma mark - UITextField
+ (UITextField *)getTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    return textField;
}

#pragma mark - UITextView
+ (UITextView *)getTextView {
    return [self getTextView:nil];
}

+ (UITextView *)getTextView:(UITextView *)toView {
    return [self getTextView:toView frame:CGRectZero];
}

+ (UITextView *)getTextView:(UITextView *)toView
                      frame:(CGRect)frame {
    return [self getTextView:toView frame:frame delegate:nil];
}

+ (UITextView *)getTextView:(UITextView *)toView
                      frame:(CGRect)frame
                   delegate:(id<UITextViewDelegate>)delegate {
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    [toView addSubview:textView];
    textView.delegate = delegate;
    return textView;
}

#pragma mark - UIImageView
+ (UIImageView *)getImageView {
    return [self getImageView:nil];
}

+ (UIImageView *)getImageView:(UIView *)toView {
    return [self getImageView:toView frame:CGRectZero];
}

+ (UIImageView *)getImageView:(UIView *)toView
                        frame:(CGRect)frame {
    return [self getImageView:toView frame:frame image:nil];
}

+ (UIImageView *)getImageView:(UIView *)toView
                        frame:(CGRect)frame
                        image:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [toView addSubview:imageView];
    imageView.image = image;
    return imageView;
}

#pragma mark - UIButton
+ (UIButton *)getButton {
    return [self getButton:nil];
}

+ (UIButton *)getButton:(UIView *)toView {
    return [self getButton:toView frame:CGRectZero];
}

+ (UIButton *)getButton:(UIView *)toView frame:(CGRect)frame {
    return [self getButton:toView frame:frame target:nil action:nil];
}

+ (UIButton *)getButton:(UIView *)toView frame:(CGRect)frame target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [toView addSubview:button];
    button.frame = frame;
    button.adjustsImageWhenHighlighted = NO;
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

#pragma mark - UITableView
+ (UITableView *)getTableView {
    return [self getTableView:nil];
}

+ (UITableView *)getTableView:(UIView *)toView {
    return [self getTableView:toView frame:CGRectZero];
}

+ (UITableView *)getTableView:(UIView *)toView
                        frame:(CGRect)frame {
    return [self getTableView:toView frame:frame delegate:nil];
}

+ (UITableView *)getTableView:(UIView *)toView
                        frame:(CGRect)frame
                     delegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    return [self getTableView:toView frame:frame delegate:delegate style:UITableViewStylePlain];
}

+ (UITableView *)getTableView:(UIView *)toView
                        frame:(CGRect)frame
                     delegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate
                        style:(UITableViewStyle)style {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    [toView addSubview:tableView];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedRowHeight = 50;
    tableView.rowHeight = UITableViewAutomaticDimension;
    // To Control subviews.
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.tableHeaderView = ({
        UIView *view = [LLFactory getView];
        view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, CGFLOAT_MIN);
        view;
    });
    tableView.tableFooterView = ({
        UIView *view = [LLFactory getView];
        view.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, CGFLOAT_MIN);
        view;
    });
    return tableView;
}

#pragma mark - UICollectionView
+ (UICollectionView *)getCollectionViewWithLayout:(UICollectionViewFlowLayout *)layout {
    return [self getCollectionView:nil layout:layout];
}

+ (UICollectionView *)getCollectionView:(UIView *)toView
                                 layout:(UICollectionViewFlowLayout *)layout {
    return [self getCollectionView:toView frame:CGRectZero layout:layout];
}

+ (UICollectionView *)getCollectionView:(UIView *)toView
                                  frame:(CGRect)frame
                                 layout:(UICollectionViewFlowLayout *)layout {
    return [self getCollectionView:toView frame:frame delegate:nil layout:layout];
}

+ (UICollectionView *)getCollectionView:(UIView *)toView
                                  frame:(CGRect)frame
                               delegate:(id<UICollectionViewDelegate, UICollectionViewDataSource>)delegate
                                 layout:(UICollectionViewFlowLayout *)layout {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [toView addSubview:collectionView];
    collectionView.delegate = delegate;
    collectionView.dataSource = delegate;
    return collectionView;
}

#pragma mark - UISegmentedControl
+ (UISegmentedControl *)getSegmentedControl {
    return [self getSegmentedControl:nil];
}

+ (UISegmentedControl *)getSegmentedControl:(UIView *)toView {
    return [self getSegmentedControl:toView frame:CGRectZero];
}

+ (UISegmentedControl *)getSegmentedControl:(UIView *)toView frame:(CGRect)frame {
    return [self getSegmentedControl:toView frame:frame items:nil];
}

+ (UISegmentedControl *)getSegmentedControl:(UIView *)toView frame:(CGRect)frame items:(NSArray *)items {
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
    [toView addSubview:control];
    control.frame = frame;
    return control;
}

#pragma mark - UISwitch
+ (UISwitch *)getSwitch {
    UISwitch *swit = [[UISwitch alloc] initWithFrame:CGRectZero];
    return swit;
}

#pragma mark - UISlider
+ (UISlider *)getSlider {
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
    return slider;
}

#pragma mark - UIScrollView
+ (UIScrollView *)getScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return scrollView;
}

#pragma mark - UISearchBar
+ (UISearchBar *)getSearchBar {
    UISearchBar *bar = [[UISearchBar alloc] init];
    return bar;
}

#pragma mark - UIPickerView
+ (UIPickerView *)getPickerView {
    return [self getPickerView:nil frame:CGRectZero delegate:nil];
}

+ (UIPickerView *)getPickerView:(UIView *_Nullable)toView
                          frame:(CGRect)frame
                       delegate:(id<UIPickerViewDelegate, UIPickerViewDataSource> _Nullable)delegate {
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:frame];
    [toView addSubview:picker];
    picker.delegate = delegate;
    picker.dataSource = delegate;
    return picker;
}

@end
