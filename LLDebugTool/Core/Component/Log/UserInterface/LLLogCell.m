//
//  LLLogCell.m
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

#import "LLLogCell.h"
#import "LLConfig.h"
#import "LLFactory.h"
#import "Masonry.h"
#import "LLConst.h"

@interface LLLogCell ()

@property (nonatomic, strong) UILabel *fileDesLabel;
@property (nonatomic, strong) UILabel *fileLabel;
@property (nonatomic, strong) UILabel *funcDesLabel;
@property (nonatomic, strong) UILabel *funcLabel;
@property (nonatomic, strong) UILabel *dateDesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (strong, nonatomic) LLLogModel *model;

@end

@implementation LLLogCell

- (void)confirmWithModel:(LLLogModel *)model {
    _model = model;
    _fileLabel.text = model.file ?: @" ";
    _funcLabel.text = model.function ?: @" ";
    _dateLabel.text = model.date ?: @" ";
    _messageLabel.text = model.message ? model.message : @"None Message";
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.fileDesLabel];
    [self.contentView addSubview:self.fileLabel];
    [self.contentView addSubview:self.funcDesLabel];
    [self.contentView addSubview:self.funcLabel];
    [self.contentView addSubview:self.dateDesLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.messageLabel];
    
    [self.fileDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileLabel.mas_top);
        make.left.mas_equalTo(kLLGeneralMargin);
        make.width.mas_equalTo(45);
    }];
    
    [self.fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLLGeneralMargin);
        make.left.equalTo(self.fileDesLabel.mas_right).offset(kLLGeneralMargin / 2.0);
        make.right.mas_equalTo(-kLLGeneralMargin);
    }];
    
    [self.funcDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funcLabel.mas_top);
        make.left.width.equalTo(self.fileDesLabel);
    }];
    
    [self.funcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fileLabel);
        make.top.equalTo(self.fileLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
    }];
    
    [self.dateDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_top);
        make.left.width.equalTo(self.fileDesLabel);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fileLabel);
        make.top.equalTo(self.funcLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileDesLabel);
        make.right.equalTo(self.fileLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
        make.bottom.mas_equalTo(-kLLGeneralMargin).priorityHigh();
    }];
}

#pragma mark - Getters and setters
- (UILabel *)fileDesLabel {
    if (!_fileDesLabel) {
        _fileDesLabel = [LLFactory getLabel];
        _fileDesLabel.text = @"File";
        _fileDesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fileDesLabel;
}

- (UILabel *)fileLabel {
    if (!_fileLabel) {
        _fileLabel = [LLFactory getLabel];
        _fileLabel.numberOfLines = 0;
        _fileLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _fileLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _fileLabel;
}

- (UILabel *)funcDesLabel {
    if (!_funcDesLabel) {
        _funcDesLabel = [LLFactory getLabel];
        _funcDesLabel.text = @"Func";
        _funcDesLabel.numberOfLines = 0;
        _funcDesLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _funcDesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _funcDesLabel;
}

- (UILabel *)funcLabel {
    if (!_funcLabel) {
        _funcLabel = [LLFactory getLabel];
        _funcLabel.numberOfLines = 0;
        _funcLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _funcLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _funcLabel;
}

- (UILabel *)dateDesLabel {
    if (!_dateDesLabel) {
        _dateDesLabel = [LLFactory getLabel];
        _dateDesLabel.text = @"Date";
        _dateDesLabel.numberOfLines = 0;
        _dateDesLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _dateDesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateDesLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [LLFactory getLabel];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _dateLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [LLFactory getLabel];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _messageLabel;
}

@end
