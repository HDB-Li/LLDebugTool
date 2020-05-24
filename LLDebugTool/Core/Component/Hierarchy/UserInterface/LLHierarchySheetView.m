//
//  LLHierarchySheetView.m
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

#import "LLHierarchySheetView.h"

#import "LLConst.h"
#import "LLFactory.h"
#import "LLHierarchySheetReuseView.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"

#import "NSArray+LL_Utils.h"
#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLHierarchySheetView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) NSInteger index;

@end

@implementation LLHierarchySheetView

#pragma mark - Public
- (void)showWithData:(nullable NSArray<UIView *> *)data index:(NSInteger)index {
    self.data = [data copy];
    self.index = index;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    [self updateUI];
    [super show];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.showAnimateStyle = LLAnimateViewShowAnimateStylePresent;
    self.hideAnimateStyle = LLAnimateViewHideAnimateStyleDismiss;
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.pickerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = MAX(self.cancelButton.LL_width, self.confirmButton.LL_width);

    self.cancelButton.frame = CGRectMake(kLLGeneralMargin, 0, buttonWidth, self.buttonHeight);
    self.confirmButton.frame = CGRectMake(self.contentView.LL_width - kLLGeneralMargin - buttonWidth, 0, buttonWidth, self.buttonHeight);
    self.descLabel.frame = CGRectMake(self.cancelButton.LL_right + kLLGeneralMargin, 0, self.confirmButton.LL_left - self.cancelButton.LL_right - kLLGeneralMargin * 2, self.buttonHeight);
    self.line.frame = CGRectMake(0, self.cancelButton.LL_bottom, self.contentView.LL_width, 1);
    self.pickerView.frame = CGRectMake(0, self.buttonHeight, self.contentView.LL_width, self.pickerViewHeight);
}

- (CGRect)contentViewFrame {
    return CGRectMake(kLLGeneralMargin, self.LL_height - kLLGeneralMargin * 2 - self.buttonHeight - self.pickerViewHeight, self.LL_width - kLLGeneralMargin * 2, self.buttonHeight + self.pickerViewHeight);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _data.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *line1 = [pickerView.subviews LL_objectAtIndex:1];
    UIView *line2 = [pickerView.subviews LL_objectAtIndex:2];
    line1.backgroundColor = [LLThemeManager shared].primaryColor;
    line2.backgroundColor = [LLThemeManager shared].primaryColor;

    LLHierarchySheetReuseView *reuseView = nil;
    if ([view isKindOfClass:[LLHierarchySheetReuseView class]]) {
        reuseView = (LLHierarchySheetReuseView *)view;
    } else {
        reuseView = [[LLHierarchySheetReuseView alloc] init];
    }
    UIView *obj = self.data[row];
    NSString *title = [self titleForRow:row];
    UIColor *color = [obj LL_hashColor];
    reuseView.title = title;
    reuseView.color = color;
    return reuseView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index = row;
    [self updateUI];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - Actions
- (void)cancelButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(LLHierarchySheetViewDidSelectCancel:)]) {
        [self.delegate LLHierarchySheetViewDidSelectCancel:self];
    }
}

- (void)confirmButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(LLHierarchySheetView:didSelectAtView:)]) {
        [self.delegate LLHierarchySheetView:self didSelectAtView:[self.data LL_objectAtIndex:self.index]];
    }
}

#pragma mark - Primary
- (void)updateUI {
    UIView *view = [self.data LL_objectAtIndex:self.index];
    self.descLabel.text = NSStringFromCGRect(view.frame);
    if ([self.delegate respondsToSelector:@selector(LLhierarchySheetView:didPreviewAtView:)]) {
        [self.delegate LLhierarchySheetView:self didPreviewAtView:view];
    }
}

- (NSString *)titleForRow:(NSInteger)row {
    UIView *view = [self.data LL_objectAtIndex:row];
    NSString *title = NSStringFromClass(view.class);
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UISearchBar class]]) {
        NSString *text = [view valueForKey:@"text"];
        if ([text length]) {
            title = [title stringByAppendingFormat:@"(%@)", text];
        }
    }
    return title;
}

- (CGFloat)buttonHeight {
    return 40;
}

- (CGFloat)pickerViewHeight {
    return MIN(_data.count + 2, 5) * 40;
}

#pragma mark - Getters and setters
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(cancelButtonClick:)];
        [_cancelButton setTitle:LLLocalizedString(@"cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        [_cancelButton sizeToFit];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(confirmButtonClick:)];
        [_confirmButton setTitle:LLLocalizedString(@"confirm") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        [_confirmButton sizeToFit];
    }
    return _confirmButton;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _descLabel;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [LLFactory getPickerView:nil frame:CGRectZero delegate:self];
        _pickerView.tintColor = [LLThemeManager shared].primaryColor;
    }
    return _pickerView;
}

- (UIView *)line {
    if (!_line) {
        _line = [LLFactory getView];
        _line.backgroundColor = [LLThemeManager shared].primaryColor;
    }
    return _line;
}

@end
