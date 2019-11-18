//
//  LLDetailTitleSelectorCellView.m
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

#import "LLDetailTitleSelectorCellView.h"

#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLDetailTitleSelectorCellView ()

@property (nonatomic, strong) UIImageView *accessoryView;

@end

@implementation LLDetailTitleSelectorCellView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self addSubview:self.accessoryView];
    
    self.detailLabelRightCons.constant = -(kLLGeneralMargin - 2) - 14 - kLLGeneralMargin;
    
    [self addAccessoryViewConstraints];
    
    [self LL_addClickListener:self action:@selector(tapAction:)];
}

#pragma mark - Primary
- (void)addAccessoryViewConstraints {
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:14];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:14];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.accessoryView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-(kLLGeneralMargin - 2)];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.accessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.accessoryView.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accessoryView.superview addConstraints:@[width, height, right, centerY]];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_block) {
        _block();
    }
}

#pragma mark - Getters and setters
- (UIImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [LLFactory getImageView];
        _accessoryView.image = [[UIImage LL_imageNamed:kRightImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _accessoryView.tintColor = [LLThemeManager shared].primaryColor;
    }
    return _accessoryView;
}

@end
