//
//  LLTitleHeaderView.m
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

#import "LLTitleHeaderView.h"

#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLTitleHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LLTitleHeaderView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.backgroundColor = [LLThemeManager shared].containerColor;
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(kLLGeneralMargin, 0, self.LL_width - kLLGeneralMargin * 2, self.LL_height);
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:18 textColor:[LLThemeManager shared].primaryColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}

@end
