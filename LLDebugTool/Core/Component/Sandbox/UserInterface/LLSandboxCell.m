//
//  LLSandboxCell.m
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

#import "LLSandboxCell.h"

#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLFormatterTool.h"
#import "LLSandboxModel.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"


@interface LLSandboxCell ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (strong, nonatomic) LLSandboxModel *model;

@end

@implementation LLSandboxCell

- (void)confirmWithModel:(LLSandboxModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [LLFormatterTool stringFromDate:model.modifiDate style:FormatterToolDateStyle1]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@",model.totalFileSizeString];
    if (model.isDirectory && model.subModels.count) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    if (model.isHidden) {
        self.contentView.alpha = 0.6;
    } else {
        self.contentView.alpha = 1.0;
    }
    if ([model.iconName isEqualToString:kFolderImageName] || [model.iconName isEqualToString:kEmptyFolderImageName]) {
        self.icon.image = [[UIImage LL_imageNamed:model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        self.icon.image = [UIImage LL_imageNamed:model.iconName];
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [self.contentView addGestureRecognizer:longPG];
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.sizeLabel];
    
    [self addIconConstraints];
    [self addNameLabelConstraints];
    [self addSizeLabelConstraints];
    [self addDateLabelConstraints];
}

- (void)addIconConstraints {
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.icon.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.icon.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.icon.superview addConstraints:@[width, height, left, centerY]];
}

- (void)addNameLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.icon attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.nameLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin / 2.0];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel.superview addConstraints:@[left, top, right]];
}

- (void)addDateLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sizeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.dateLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-kLLGeneralMargin];
    bottom.priority = UILayoutPriorityDefaultHigh;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dateLabel.superview addConstraints:@[left, top, bottom]];
}

- (void)addSizeLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.sizeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.sizeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.sizeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin / 2.0];
    self.sizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sizeLabel.superview addConstraints:@[left, right, top]];
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(LL_tableViewCellDidLongPress:)]) {
            [_delegate LL_tableViewCellDidLongPress:self];
        }
    }
}

#pragma mark - Getters and setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [LLFactory getLabel];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _nameLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [LLFactory getImageView];
        _icon.tintColor = [LLThemeManager shared].primaryColor;
    }
    return _icon;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [LLFactory getLabel];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sizeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [LLFactory getLabel];
        _dateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateLabel;
}

@end
