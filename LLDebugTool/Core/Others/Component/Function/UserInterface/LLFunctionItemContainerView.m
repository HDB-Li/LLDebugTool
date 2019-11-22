//
//  LLFunctionItemContainerView.m
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

#import "LLFunctionItemContainerView.h"

#import "LLFunctionItemView.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"

#import "UIView+LL_Utils.h"

@interface LLFunctionItemContainerView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *itemViews;

@end

@implementation LLFunctionItemContainerView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.backgroundColor = [LLThemeManager shared].containerColor;
    self.itemViews = [[NSMutableArray alloc] init];
    [self LL_setCornerRadius:5];
    self.titleLabel = [LLFactory getLabel:self frame:CGRectMake(20, 0, self.LL_width - 20, 40) text:nil font:18 textColor:[LLThemeManager shared].primaryColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.lineView = [LLFactory getLineView:CGRectMake(10, self.titleLabel.LL_bottom - 1, self.LL_width - 10 * 2, 1) superView:self];
}

- (void)themeColorChanged {
    [super themeColorChanged];
    self.titleLabel.textColor = [LLThemeManager shared].primaryColor;
    self.lineView.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.backgroundColor = [LLThemeManager shared].containerColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(20, 0, self.titleLabel.LL_width + 20, self.titleLabel.LL_height + 20);
    self.lineView.frame = CGRectMake(self.titleLabel.LL_x, self.titleLabel.LL_bottom - 1, self.titleLabel.LL_width, 1);
    NSInteger count = 3;
    CGFloat itemWidth = self.LL_width / count;
    CGFloat itemHeight = 90;
    for (int i = 0; i < self.itemViews.count; i++) {
        NSInteger section = i / count;
        NSInteger row = i % count;
        LLFunctionItemView *view = self.itemViews[i];
        view.frame = CGRectMake(row * itemWidth, section * itemHeight + self.titleLabel.LL_bottom, itemWidth, itemHeight);
    }
    self.LL_size = CGSizeMake(self.LL_width, [self LL_bottomView].LL_bottom);
}

#pragma mark - Primary
- (void)updateUI:(NSArray<LLFunctionItemModel *> *)dataArray {
    for (UIView *view in self.itemViews) {
        [view removeFromSuperview];
    }
    [self.itemViews removeAllObjects];
    for (int i = 0; i < dataArray.count; i++) {
        LLFunctionItemModel *model = dataArray[i];
        LLFunctionItemView *itemView = [[LLFunctionItemView alloc] initWithFrame:CGRectZero];
        [itemView LL_addClickListener:self action:@selector(itemViewClicked:)];
        itemView.model = model;
        [self addSubview:itemView];
        [self.itemViews addObject:itemView];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Event responses
- (void)itemViewClicked:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    if ([view isKindOfClass:[LLFunctionItemView class]]) {
        LLFunctionItemView *itemView = (LLFunctionItemView *)view;
        [self.delegate LLFunctionContainerView:self didSelectAt:itemView.model];
    }
}

#pragma mark - Getters and setters
- (void)setDataArray:(NSArray<LLFunctionItemModel *> *)dataArray {
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        [self updateUI:dataArray];
    }
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = [title copy];
        self.titleLabel.text = title;
    }
}

@end
