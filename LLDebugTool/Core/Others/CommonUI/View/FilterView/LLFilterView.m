//
//  LLFilterView.m
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

#import "LLFilterView.h"

#import "LLThemeManager.h"
#import "LLFactory.h"

#import "UIButton+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLFilterView ()

@property (nonatomic, assign) CGFloat normalHeight;

@property (nonatomic, strong) UIView *lineView;

// Buttons
@property (nonatomic, strong) UIView *btnsBgView;

@property (nonatomic, strong) NSMutableArray *filterBtns;

@end

@implementation LLFilterView

#pragma mark - Public
- (BOOL)isFiltering {
    BOOL ret = NO;
    for (UIButton *btn in self.filterBtns) {
        if (btn.isSelected) {
            ret = YES;
            break;
        }
    }
    return ret;
}

- (void)cancelFiltering {
    for (UIButton *btn in self.filterBtns) {
        if (btn.selected == YES) {
            [self filterButtonClick:btn];
        }
    }
}

- (void)updateFilterButton:(UIView *)filterView count:(NSInteger)count {
    NSInteger index = [self.filterViews indexOfObject:filterView];
    if (index != NSNotFound) {
        UIButton *sender = self.filterBtns[index];
        NSString *title = self.titles[index];
        if (count == 0) {
            [sender setTitle:title forState:UIControlStateNormal];
        } else {
            [sender setTitle:[NSString stringWithFormat:@"%@ (%ld)",title,(long)count] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self addSubview:self.btnsBgView];
    [self addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.btnsBgView.frame = CGRectMake(0, 0, self.LL_width, self.normalHeight);
    CGFloat gap = 20;
    CGFloat itemHeight = 25;
    NSInteger count = self.titles.count;
    CGFloat itemWidth = (self.frame.size.width - gap * (count + 1)) / count;
    for (NSInteger i = 0; i < self.filterBtns.count; i++) {
        UIButton *button = self.filterBtns[i];
        button.frame = CGRectMake(i * (itemWidth + gap) + gap, (self.btnsBgView.LL_height - itemHeight) / 2.0, itemWidth, itemHeight);
    }
    self.lineView.frame = CGRectMake(0, self.normalHeight - 1, self.LL_width, 1);
}

#pragma mark - Event responses
- (void)filterButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        [self hideDetailView:sender.tag];
    } else {
        for (UIButton *btn in self.filterBtns) {
            if (btn != sender && btn.selected) {
                btn.selected = NO;
                [self hideDetailView:btn.tag];
            }
        }
        [self showDetailView:sender.tag];
    }
    [self endEditing:YES];
}

#pragma mark - Primary
- (void)showDetailView:(NSInteger)index {
    UIView *view = self.filterViews[index];
    view.hidden = NO;
    //    view.alpha = 0;
    view.LL_y = self.normalHeight;
    __block CGFloat height = view.LL_height;
    view.LL_height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        view.LL_height = height;
        self.LL_height = self.normalHeight + height;
        self.superview.LL_height = self.superview.LL_height + height;
    } completion:^(BOOL finished) {
        if (self.filterChangeStateBlock) {
            self.filterChangeStateBlock();
        }
    }];
}

- (void)hideDetailView:(NSInteger)index {
    UIView *view = self.filterViews[index];
    __block CGFloat height = view.LL_height;
    [UIView animateWithDuration:0.1 animations:^{
        view.LL_height = 0;
        self.LL_height = self.normalHeight;
        self.superview.LL_height = self.superview.LL_height - height;
        //        view.alpha = 0;
    } completion:^(BOOL finished) {
        view.LL_height = height;
        view.hidden = YES;
        if (self.filterChangeStateBlock) {
            self.filterChangeStateBlock();
        }
    }];
}

#pragma mark - Primary
- (void)updateUI:(NSArray *)titles {
    [self.filterBtns removeAllObjects];
    [self.btnsBgView LL_removeAllSubviews];
    
    CGFloat gap = 20;
    CGFloat itemHeight = 25;
    NSInteger count = self.titles.count;
    CGFloat itemWidth = (self.frame.size.width - gap * (count + 1)) / count;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [LLFactory getButton:self.btnsBgView frame:CGRectMake(i * (itemWidth + gap) + gap, (self.frame.size.height - itemHeight) / 2.0, itemWidth, itemHeight) target:self action:@selector(filterButtonClick:)];
        [btn setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        [btn setTitleColor:[LLThemeManager shared].backgroundColor forState:UIControlStateSelected];
        [btn LL_setBackgroundColor:[LLThemeManager shared].backgroundColor forState:UIControlStateNormal];
        [btn LL_setBackgroundColor:[LLThemeManager shared].primaryColor forState:UIControlStateSelected];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn LL_setCornerRadius:5];
        [btn LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:0.5];
        [self.filterBtns addObject:btn];
    }
}

#pragma mark - Getters and setters
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self updateUI:titles];
}

- (UIView *)btnsBgView {
    if (!_btnsBgView) {
        _btnsBgView = [LLFactory getView];
        _btnsBgView.backgroundColor = [LLThemeManager shared].backgroundColor;
    }
    return _btnsBgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [LLFactory getLineView:CGRectZero superView:nil];
    }
    return _lineView;
}

- (NSMutableArray *)filterBtns {
    if (!_filterBtns) {
        _filterBtns = [[NSMutableArray alloc] init];
    }
    return _filterBtns;
}

- (CGFloat)normalHeight {
    if (!_normalHeight) {
        _normalHeight = 40;
    }
    return _normalHeight;
}

@end
