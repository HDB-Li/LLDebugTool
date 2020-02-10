//
//  LLTitleSwitchCell.m
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

#import "LLTitleSwitchCell.h"

#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

@interface LLTitleSwitchCell ()

@property (nonatomic, strong) UISwitch *swit;

@end

@implementation LLTitleSwitchCell

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.swit];
    
    [self.contentView removeConstraint:self.detailLabelRightCons];
    
    [self addSwitConstraints];
}

- (void)addSwitConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.detailLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:31];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin / 2.0];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.swit.translatesAutoresizingMaskIntoConstraints = NO;
    [self.swit.superview addConstraints:@[left, right, width, height, top, bottom]];
}

- (void)themeColorChanged {
    [super themeColorChanged];
    _swit.onTintColor = [LLThemeManager shared].primaryColor;
}

#pragma mark - Event responses
- (void)switchValueChanged:(UISwitch *)sender {
    self.model.flag = sender.isOn;
    if (self.model.changePropertyBlock) {
        self.model.changePropertyBlock(@(sender.isOn));
    }
}

#pragma mark - Getters and settings
- (void)setModel:(LLTitleCellModel *)model {
    [super setModel:model];
    _swit.on = model.flag;
}

- (UISwitch *)swit {
    if (!_swit) {
        _swit = [LLFactory getSwitch];
        _swit.onTintColor = [LLThemeManager shared].primaryColor;
        [_swit addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

@end
