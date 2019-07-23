//
//  LLFunctionFooterView.m
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

#import "LLFunctionFooterView.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLConfig.h"
#import "UIButton+LL_Utils.h"

@interface LLFunctionFooterView ()

@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation LLFunctionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.settingButton.frame = CGRectMake(10, 10, self.LL_width - 10 * 2, 40);
}

#pragma mark - Primary
- (void)initial {
    self.settingButton = [LLFactory getButton:self frame:CGRectZero target:self action:@selector(settingButtonClicked:)];
    [self.settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    [self.settingButton setTitleColor:LLCONFIG_TEXT_COLOR forState:UIControlStateNormal];
    [self.settingButton LL_setBackgroundColor:LLCONFIG_BACKGROUND_COLOR forState:UIControlStateNormal];
    [self.settingButton setCornerRadius:5];
    self.settingButton.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.settingButton.layer.borderWidth = 1;
}

- (void)settingButtonClicked:(UIButton *)sender {
    
}

@end
