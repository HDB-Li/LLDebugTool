//
//  LLTitleSwitchCellView.m
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

#import "LLTitleSwitchCellView.h"

#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

@interface LLTitleSwitchCellView ()

@property (nonatomic, strong) UISwitch *swit;

@end

@implementation LLTitleSwitchCellView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self addSubview:self.swit];
    
    [self removeConstraint:self.detailLabelRightCons];
    
    [self addSwitConstraints];
}

- (void)addSwitConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.detailLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.swit.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:31];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.swit attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.swit.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    top.priority = UILayoutPriorityDefaultHigh;
    self.swit.translatesAutoresizingMaskIntoConstraints = NO;
    [self.swit.superview addConstraints:@[left, right, centerY, width, height, top]];
}

- (void)themeColorChanged {
    [super themeColorChanged];
    _swit.onTintColor = [LLThemeManager shared].primaryColor;
}

#pragma mark - Event responses
- (void)switchValueChanged:(UISwitch *)sender {
    if (_changePropertyBlock) {
        _changePropertyBlock(self.isOn);
    }
}

#pragma mark - Getters and settings
- (void)setOn:(BOOL)on {
    _swit.on = on;
}

- (BOOL)isOn {
    return _swit.isOn;
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
