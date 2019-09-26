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
#import "LLConfig.h"
#import "LLMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"
#import "Masonry.h"
#import "UIView+LL_Utils.h"

@interface LLSubTitleTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, assign) NSInteger maxTextViewHeight;

@end

@implementation LLSubTitleTableViewCell

- (void)setContentText:(NSString *)contentText {
    if (![_contentText isEqualToString:contentText]) {
        _contentText = [contentText copy];
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.text = _contentText;
        CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(LL_SCREEN_WIDTH - kLLGeneralMargin * 2, CGFLOAT_MAX)];
        if (size.height >= self.maxTextViewHeight) {
            [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.maxTextViewHeight);
            }];
            self.contentTextView.scrollEnabled = YES;
        } else {
            [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(size.height);
            }];
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLLGeneralMargin);
        make.left.mas_equalTo(kLLGeneralMargin);
        make.right.mas_equalTo(kLLGeneralMargin);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
        make.left.right.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-kLLGeneralMargin).priorityHigh();
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
        make.height.mas_equalTo(20);
    }];
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
