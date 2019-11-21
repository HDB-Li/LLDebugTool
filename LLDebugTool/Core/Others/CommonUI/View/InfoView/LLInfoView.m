//
//  LLInfoView.m
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

#import "LLInfoView.h"

#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLInfoView ()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation LLInfoView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    [self LL_setCornerRadius:5];
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    
    self.closeButton = [LLFactory getButton:self frame:CGRectMake(self.LL_width - kLLGeneralMargin - 30, kLLGeneralMargin, 30, 30) target:self action:@selector(closeButtonClicked:)];
    [self.closeButton setImage:[UIImage LL_imageNamed:kCloseImageName color:[LLThemeManager shared].primaryColor] forState:UIControlStateNormal];
}

#pragma mark - Primary
- (void)closeButtonClicked:(UIButton *)sender {
    [self.delegate LLInfoViewDidSelectCloseButton:self];
}

@end
