//
//  LLFilterLabelCell.m
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

#import "LLFilterLabelCell.h"
#import "LLConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "Masonry.h"
#import "LLConst.h"
#import "UIView+LL_Utils.h"

@interface LLFilterLabelCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) LLFilterLabelModel *model;

@end

@implementation LLFilterLabelCell

#pragma mark - Public
- (void)confirmWithModel:(LLFilterLabelModel *)model {
    _model = model;
    _label.text = model.message;
    if (_model.isSelected) {
        _label.textColor = [LLThemeManager shared].backgroundColor;
        _bgView.backgroundColor = [LLThemeManager shared].primaryColor;
    } else {
        _label.textColor = [LLThemeManager shared].primaryColor;
        _bgView.backgroundColor = [LLThemeManager shared].backgroundColor;
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.label];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kLLGeneralMargin / 2.0);
        make.right.bottom.mas_equalTo(-kLLGeneralMargin / 2.0);
    }];
}

#pragma mark - Getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [LLFactory getView];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView LL_setCornerRadius:5];
        [_bgView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:0.5];
    }
    return _bgView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [LLFactory getLabel];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _label;
}

@end
