//
//  LLHierarchyInfoSwitchView.m
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

#import "LLHierarchyInfoSwitchView.h"

#import "LLConst.h"
#import "LLFactory.h"
#import "LLHierarchyInfoSwitchModel.h"
#import "LLThemeManager.h"

#import "UIView+LL_Utils.h"

@interface LLHierarchyInfoSwitchView () <LLHierarchyInfoSwitchModelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISwitch *swit;

@end

@implementation LLHierarchyInfoSwitchView

- (void)initUI {
    [super initUI];

    [self addSubview:self.titleLabel];
    [self addSubview:self.swit];
}

#pragma mark - Over write
- (void)layoutSubviews {
    [super layoutSubviews];
    self.LL_height = self.swit.LL_height;
    self.swit.frame = CGRectMake(self.LL_width - self.swit.LL_width, (self.LL_height - self.swit.LL_height) / 2.0, self.swit.LL_width, self.swit.LL_height);
    self.titleLabel.frame = CGRectMake(0, 0, self.swit.LL_left - kLLGeneralMargin, self.LL_height);
}

#pragma mark - LLHierarchyInfoSwitchModelDelegate
- (void)hierarchyInfoSwitchModel:(LLHierarchyInfoSwitchModel *)model didUpdateStatus:(BOOL)isOn {
    if (self.swit.isOn != isOn) {
        [self.swit setOn:isOn animated:YES];
    }
}

#pragma mark - Actions
- (void)switchValueChanged:(UISwitch *)swit {
    self.model.on = swit.isOn;
    if (_model.changePropertyBlock) {
        _model.changePropertyBlock(swit.isOn);
    }
}

#pragma mark - Primary
- (void)updateUI {
    self.titleLabel.attributedText = self.model.title;
    self.swit.on = self.model.on;
}

#pragma mark - Getters and setters
- (void)setModel:(LLHierarchyInfoSwitchModel *)model {
    if (_model != model) {
        _model.delegate = nil;
        _model = model;
        _model.delegate = self;
        [self updateUI];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

- (UISwitch *)swit {
    if (!_swit) {
        _swit = [LLFactory getSwitch];
        [_swit sizeToFit];
        [_swit addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _swit;
}

@end
