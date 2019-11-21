//
//  LLTitleSliderCell.m
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

#import "LLTitleSliderCell.h"

#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

@interface LLTitleSliderCell ()

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation LLTitleSliderCell

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.valueLabel];
    
    [self addValueLabelConstraints];
    [self addSliderConstraints];
}

- (void)addValueLabelConstraints {
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.valueLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.valueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.valueLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.valueLabel.superview addConstraints:@[right, centerY]];
}

- (void)addSliderConstraints {
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.valueLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.slider.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.slider.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin /2.0];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slider.superview addConstraints:@[right, left, top, height, bottom]];
}

#pragma mark - Primary
- (void)updateUI {
    self.model.value = (long)self.slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.value];
}

#pragma mark - Event responses
- (void)sliderTouchUpInside:(UISlider *)sender {
    [self updateUI];
    if (self.model.changePropertyBlock) {
        self.model.changePropertyBlock(@(self.model.value));
    }
}

- (void)sliderValueChanged:(UISlider *)sender {
    [self updateUI];
}

#pragma mark - Getters and setters
- (void)setModel:(LLTitleCellModel *)model {
    [super setModel:model];
    _slider.minimumValue = model.minValue;
    _slider.maximumValue = model.maxValue;
    _slider.value = model.value;
    _valueLabel.text = [NSString stringWithFormat:@"%ld",(long)model.value];
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [LLFactory getSlider];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
    }
    return _valueLabel;
}

@end
