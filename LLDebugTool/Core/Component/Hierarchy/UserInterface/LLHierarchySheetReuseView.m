//
//  LLHierarchySheetReuseView.m
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

#import "LLHierarchySheetReuseView.h"

#import "LLConst.h"
#import "LLFactory.h"
#import "LLThemeManager.h"

#import "UIView+LL_Utils.h"

@interface LLHierarchySheetReuseView ()

@property (nonatomic, strong) UIView *icon;

@property (nonatomic, strong) UILabel *label;

@end

@implementation LLHierarchySheetReuseView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self addSubview:self.icon];
    [self addSubview:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.icon.frame = CGRectMake(kLLGeneralMargin, (self.LL_height - 20) / 2.0, 20, 20);
    self.label.frame = CGRectMake(self.icon.LL_right + kLLGeneralMargin, 0, self.LL_width - self.icon.LL_right - kLLGeneralMargin * 2, self.LL_height);
}

#pragma mark - Getters and setters
- (UIView *)icon {
    if (!_icon) {
        _icon = [LLFactory getView];
        [_icon LL_setCornerRadius:10];
        [_icon LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:0.5];
    }
    return _icon;
}

- (UILabel *)label {
    if (!_label) {
        _label = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _label.adjustsFontSizeToFitWidth = YES;
    }
    return _label;
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        self.icon.backgroundColor = color;
    }
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = [title copy];
        self.label.text = title;
    }
}

@end
