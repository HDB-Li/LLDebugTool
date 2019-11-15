//
//  LLNetworkImageCell.m
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

#import "LLNetworkImageCell.h"

#import "LLInternalMacros.h"
#import "LLFactory.h"
#import "LLConst.h"

@interface LLNetworkImageCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSLayoutConstraint *imgViewHeightCons;

@end

@implementation LLNetworkImageCell

- (void)setUpImage:(UIImage *)image {
    self.imgView.image = image;
    if (image) {
        CGSize size = image.size;
        CGFloat height = LL_SCREEN_WIDTH * size.height / size.width;
        self.imgViewHeightCons.constant = height;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imgView];

    [self addTitleLabelConstraints];
    [self addImgViewConstraints];
}

- (void)addTitleLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel.superview addConstraints:@[left, top, height]];
}

- (void)addImgViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:45];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imgView.superview addConstraints:@[top, height, left, right, bottom]];
    
    self.imgViewHeightCons = height;
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel];
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _titleLabel.text = @"Response Body";
    }
    return _titleLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [LLFactory getImageView];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

@end
