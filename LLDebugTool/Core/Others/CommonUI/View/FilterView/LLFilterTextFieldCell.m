//
//  LLFilterTextFieldCell.m
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

#import "LLFilterTextFieldCell.h"

#import "LLFilterFilePickerView.h"
#import "LLFilterDatePickerView.h"
#import "LLFilterTextFieldModel.h"
#import "LLNoneCopyTextField.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

@interface LLFilterTextFieldCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthConstraint;

@property (nonatomic, strong) LLNoneCopyTextField *textField;

@property (strong, nonatomic) LLFilterTextFieldModel *model;

@property (strong, nonatomic) LLFilterFilePickerView *pickerView;

@property (strong, nonatomic) LLFilterDatePickerView *datePicker;

@property (strong, nonatomic) UIView *accessoryView;

@end

@implementation LLFilterTextFieldCell

- (void)confirmWithModel:(LLFilterTextFieldModel *)model {
    if (_model != model) {
        _model = model;
        _titleLabel.text = model.title;
        if (model.autoAdjustWidthToTitle) {
            [_titleLabel sizeToFit];
            _titleLabelWidthConstraint.constant = _titleLabel.frame.size.width + 4;
        } else {
            _titleLabelWidthConstraint.constant = model.titleWidth ?: 60;
        }
        _textField.text = model.currentFilter;
        _accessoryView = nil;
        _pickerView = nil;
        _datePicker = nil;
        self.textField.inputAccessoryView = self.accessoryView;
        if (model.useDatePicker) {
            self.textField.inputView = self.datePicker;
        } else {
            self.textField.inputView = self.pickerView;
        }
    }
    if (_model == nil || (_model.filters.count == 0 && !_model.useDatePicker)) {
        self.textField.enabled = NO;
    } else {
        self.textField.enabled = YES;
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    
    [self addTitleLabelConstraints];
    [self addTextFieldConstraints];
}

- (void)addTitleLabelConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel.superview addConstraints:@[left, width, top, bottom]];
}

- (void)addTextFieldConstraints {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:kLLGeneralMargin / 2.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textField.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textField.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textField.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kLLGeneralMargin];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textField.superview addConstraints:@[left, top, bottom, right]];
}

#pragma mark - Event responses
- (void)cancelButtonClick:(UIButton *)sender {
    [self.textField resignFirstResponder];
}

- (void)confirmButtonClick:(UIButton *)sender {
    [self.textField resignFirstResponder];
    if (self.model.useDatePicker) {
        NSString *filter = [self.datePicker currentDateString];
        self.model.currentFilter = filter;
        self.textField.text = filter;
    } else {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        NSString *filter = nil;
        if (row > 0) {
            filter = self.model.filters[row - 1];
        }
        self.model.currentFilter = filter;
        self.textField.text = filter;
    }
    if (_confirmBlock) {
        _confirmBlock();
    }
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [LLThemeManager shared].primaryColor;
    }
    return _titleLabel;
}

- (LLNoneCopyTextField *)textField {
    if (!_textField) {
        _textField = [[LLNoneCopyTextField alloc] initWithFrame:CGRectZero];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.tintColor = [LLThemeManager shared].primaryColor;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.textColor = [LLThemeManager shared].primaryColor;
        _textField.backgroundColor = [LLThemeManager shared].containerColor;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Please Select" attributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].primaryColor}];
        
    }
    return _textField;
}

- (LLFilterFilePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[LLFilterFilePickerView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 220) model:self.model];
    }
    return _pickerView;
}

- (LLFilterDatePickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[LLFilterDatePickerView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 220) fromDate:_model.fromDate endDate:_model.endDate];
    }
    return _datePicker;
}

- (UIView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [LLFactory getView];
        _accessoryView.backgroundColor = [UIColor whiteColor];
        _accessoryView.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 40);
        UIButton *cancel = [LLFactory getButton:_accessoryView frame:CGRectMake(12, 0, 60, _accessoryView.frame.size.height) target:self action:@selector(cancelButtonClick:)];
        [cancel setTitle:LLLocalizedString(@"cancel") forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *confirm = [LLFactory getButton:_accessoryView frame:CGRectMake(_accessoryView.frame.size.width - 60 - 12, 0, 60, _accessoryView.frame.size.height) target:self action:@selector(confirmButtonClick:)];
        [confirm setTitle:LLLocalizedString(@"confirm") forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [LLFactory getLineView:CGRectMake(0, 0, _accessoryView.frame.size.width, 1) superView:_accessoryView];
    }
    return _accessoryView;
}


@end
