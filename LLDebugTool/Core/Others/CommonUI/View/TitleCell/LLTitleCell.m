//
//  LLTitleCell.m
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

#import "LLTitleCell.h"
#import "LLFactory.h"
#import "LLThemeManager.h"
#import "Masonry.h"
#import "LLConst.h"

@interface LLTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) MASConstraint *titleLabelBottomCons;

@end

@implementation LLTitleCell

#pragma mark - Public
- (void)initUI {
    [super initUI];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLLGeneralMargin);
        make.top.mas_equalTo(kLLGeneralMargin);
        self.titleLabelBottomCons = make.bottom.mas_equalTo(-kLLGeneralMargin);
        make.width.mas_equalTo(120);
    }];
}

#pragma mark - Over write
- (void)primaryColorChanged {
    [super primaryColorChanged];
    _titleLabel.textColor = [LLThemeManager shared].primaryColor;
}

#pragma mark - Getters and setters
- (void)setModel:(LLTitleCellModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:16 textColor:[LLThemeManager shared].primaryColor];
    }
    return _titleLabel;
}

@end
