//
//  LLSubTitleTableViewCell.m
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

#import "LLSubTitleTableViewCell.h"

#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLSubTitleTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, assign) NSInteger maxTextViewHeight;

@property (nonatomic, strong) NSLayoutConstraint *contentTextViewHeightCons;

@end

@implementation LLSubTitleTableViewCell

- (void)setContentText:(NSString *)contentText {
    if (![_contentText isEqualToString:contentText]) {
        _contentText = [contentText copy];
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.text = _contentText;
        CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(LL_SCREEN_WIDTH - kLLGeneralMargin * 2, CGFLOAT_MAX)];
        if (size.height >= self.maxTextViewHeight) {
            self.contentTextViewHeightCons.constant = self.maxTextViewHeight;
            self.contentTextView.scrollEnabled = YES;
        } else {
            self.contentTextViewHeightCons.constant = size.height;
            self.contentTextView.scrollEnabled = NO;
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    _maxTextViewHeight = (NSInteger)(LL_SCREEN_HEIGHT * 0.7);
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentTextView];
    
    [self addTitleLabelConstraints];
    [self addContentTextViewConstraints];
}

- (void)addTitleLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel.superview addConstraints:@[top, left, right, height]];
}

- (void)addContentTextViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentTextView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentTextView.superview addConstraints:@[top, left, right, height, bottom]];
    
    self.contentTextViewHeightCons = height;
}

#pragma mark - Event Responses
- (void)contentLabelTapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(LLSubTitleTableViewCell:didSelectedContentView:)]) {
        [self.delegate LLSubTitleTableViewCell:self didSelectedContentView:self.contentTextView];
    }
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel];
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    return _titleLabel;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [LLFactory getTextView];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = NO;
        // You must set UITextView selectable to YES under ios 8, otherwise, you can't set textColor.
        // See https://stackoverflow.com/questions/21221281/ios-7-cant-set-font-color-of-uitextview-in-custom-uitableview-cell
        _contentTextView.selectable = YES;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentTextView.backgroundColor = nil;
        _contentTextView.textColor = [LLThemeManager shared].primaryColor;
        _contentTextView.selectable = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelTapAction:)];
        [_contentTextView addGestureRecognizer:tap];
    }
    return _contentTextView;
}

@end
