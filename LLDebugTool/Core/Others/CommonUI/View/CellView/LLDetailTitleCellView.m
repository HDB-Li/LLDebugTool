//
//  LLDetailTitleCellView.m
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

#import "LLDetailTitleCellView.h"

#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

@interface LLDetailTitleCellView ()

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) NSLayoutConstraint *detailLabelRightCons;

@end

@implementation LLDetailTitleCellView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self addSubview:self.detailLabel];
    
    [self addDetailLabelConstraints];
    
    self.detailTitle = @"";
}

- (void)addDetailLabelConstraints {
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.detailLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detailLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.detailLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin / 2.0];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.detailLabel.superview addConstraints:@[right, top, bottom, left]];
    
    self.detailLabelRightCons = right;
}

- (void)themeColorChanged {
    [super themeColorChanged];
    _detailLabel.textColor = [LLThemeManager shared].primaryColor;
}

#pragma mark - Getters and setters
- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = [detailTitle copy];
    if (detailTitle == nil || detailTitle.length == 0) {
        self.detailLabel.text = @" ";
    } else {
        self.detailLabel.text = detailTitle;
    }
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

@end
