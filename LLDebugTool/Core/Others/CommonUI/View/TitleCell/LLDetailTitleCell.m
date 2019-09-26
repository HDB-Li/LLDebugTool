//
//  LLDetailTitleCell.m
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

#import "LLDetailTitleCell.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "Masonry.h"
#import "LLConst.h"

@interface LLDetailTitleCell ()

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation LLDetailTitleCell

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self.contentView addSubview:self.detailLabel];
    
    [self.titleLabelBottomCons uninstall];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kLLGeneralMargin);
        make.top.mas_equalTo(kLLGeneralMargin);
        make.bottom.mas_equalTo(-kLLGeneralMargin);
        make.left.equalTo(self.titleLabel.mas_right).offset(kLLGeneralMargin / 2.0);
    }];
}

- (void)primaryColorChanged {
    [super primaryColorChanged];
    _detailLabel.textColor = [LLThemeManager shared].primaryColor;
}

#pragma mark - Getters and setters
- (void)setModel:(LLTitleCellModel *)model {
    [super setModel:model];
    if (model.detailTitle == nil || model.detailTitle.length == 0) {
        self.detailLabel.text = @" ";
    } else {
        self.detailLabel.text = model.detailTitle;
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
