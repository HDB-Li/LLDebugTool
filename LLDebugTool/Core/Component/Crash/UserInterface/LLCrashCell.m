//
//  LLCrashCell.m
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

#import "LLCrashCell.h"

#import "LLCrashModel.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

@interface LLCrashCell ()

@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) LLCrashModel *model;

@end

@implementation LLCrashCell

- (void)confirmWithModel:(LLCrashModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    _reasonLabel.text = model.reason;
    _dateLabel.text = [NSString stringWithFormat:@"[ %@ ]",model.date];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.reasonLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self addReasonLabelConstraints];
    [self addNameLabelConstraints];
    [self addDateLabelConstraints];
}

- (void)addReasonLabelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.reasonLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.reasonLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.reasonLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    self.reasonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.reasonLabel.superview addConstraints:@[top, left, right]];
}

- (void)addNameLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel.superview addConstraints:@[left, right, top]];
}

- (void)addDateLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.reasonLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.dateLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateLabel.superview addConstraints:@[left, right, top, bottom]];
}

#pragma mark - Getters and setters
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [LLFactory getLabel];
        _reasonLabel.font = [UIFont boldSystemFontOfSize:17];
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _reasonLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [LLFactory getLabel];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [LLFactory getLabel];
        _dateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dateLabel;
}

@end
