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

#import "LLLogModel.h"
#import "LLFactory.h"
#import "LLConfig.h"
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
    
    [self addFileDesLabelConstraints];
    [self addFileLabelConstraints];
    [self addFuncDesLabelConstraints];
    [self addFuncLabelConstraints];
    [self addDateDesLabelConstraints];
    [self addDateLabelConstraints];
    [self addMessageLabelConstraints];
}

- (void)addFileDesLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.fileDesLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.fileDesLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.fileDesLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:45];
    self.fileDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fileDesLabel.superview addConstraints:@[top, left, width]];
}

- (void)addFileLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.fileLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fileLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.fileLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.fileLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.fileLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    self.fileLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fileLabel.superview addConstraints:@[top, left, right]];
}

- (void)addFuncDesLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.funcDesLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.funcLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.funcDesLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.funcDesLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    self.funcDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.funcDesLabel.superview addConstraints:@[top, left, width]];
}

- (void)addFuncLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.funcLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.funcLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.funcLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    self.funcLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.funcLabel.superview addConstraints:@[left, right, top]];
}

- (void)addDateDesLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.dateDesLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.dateDesLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.dateDesLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    self.dateDesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateDesLabel.superview addConstraints:@[top, left, width]];
}

- (void)addDateLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.funcLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateLabel.superview addConstraints:@[left, right, top]];
}

- (void)addMessageLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.fileDesLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.fileLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dateLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.messageLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.messageLabel.superview addConstraints:@[left, right, top, bottom]];
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
