//
//  LLRulerPickerInfoView.m
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

#import "LLRulerPickerInfoView.h"
#import "LLFactory.h"
#import "LLThemeManager.h"
#import "UIView+LL_Utils.h"
#import "LLConst.h"

@interface LLRulerPickerInfoView ()

@property (nonatomic, strong) UILabel *leftContentLabel;

@property (nonatomic, strong) UILabel *rightContentLabel;

@end

@implementation LLRulerPickerInfoView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Public
- (void)updateTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom {
    self.leftContentLabel.text = [NSString stringWithFormat:@"Top: %0.2f\nBottom: %0.2f",top,bottom];
    self.rightContentLabel.text = [NSString stringWithFormat:@"Left: %0.2f\nRight: %0.2f",left,right];
}

#pragma mark - Over write
- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftContentLabel.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, (self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin) / 2.0, self.LL_height - kLLGeneralMargin - kLLGeneralMargin);
    self.rightContentLabel.frame = CGRectMake(self.closeButton.LL_x / 2.0, kLLGeneralMargin, (self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin) / 2.0, self.LL_height - kLLGeneralMargin - kLLGeneralMargin);
}

#pragma mark - Primary
- (void)initial {
    [self addSubview:self.leftContentLabel];
    [self addSubview:self.rightContentLabel];
}

#pragma mark - Getters and setters
- (UILabel *)leftContentLabel {
    if (!_leftContentLabel) {
        _leftContentLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _leftContentLabel.numberOfLines = 0;
        _leftContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _leftContentLabel;
}

- (UILabel *)rightContentLabel {
    if (!_rightContentLabel) {
        _rightContentLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _rightContentLabel.numberOfLines = 0;
        _rightContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _rightContentLabel;
}

@end
