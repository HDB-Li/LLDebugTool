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
#import "LLFactory.h"
#import "Masonry.h"
#import "LLThemeManager.h"
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
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kLLGeneralMargin);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.valueLabel.mas_left).offset(-kLLGeneralMargin);
        make.left.equalTo(self.titleLabel.mas_right).offset(kLLGeneralMargin);
        make.top.mas_equalTo(kLLGeneralMargin / 2.0);
        make.bottom.mas_equalTo(-kLLGeneralMargin / 2.0);
    }];
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
