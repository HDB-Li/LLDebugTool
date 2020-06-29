//
//  LLEntryBigTitleView.m
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

#import "LLEntryBigTitleView.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"

#import "UIView+LL_Utils.h"

@interface LLEntryBigTitleView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation LLEntryBigTitleView

#pragma mark - Public
- (void)setText:(NSString *)text {
    self.label.frame = CGRectMake(self.insets.left, self.insets.top, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    self.label.text = text;
    [self.label sizeToFit];
    self.LL_size = CGSizeMake(self.label.LL_right + self.insets.right, self.label.LL_bottom + self.insets.bottom);
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];

    self.insets = UIEdgeInsetsMake(kLLGeneralMargin / 2.0, kLLGeneralMargin / 2.0, kLLGeneralMargin / 2.0, kLLGeneralMargin / 2.0);

    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.contentView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];

    self.label = [LLFactory getLabel:self.contentView frame:CGRectMake(self.insets.left, self.insets.top, 100, self.LL_height) text:nil font:16 textColor:[LLThemeManager shared].primaryColor];
    [self setText:@"Debug"];
}

- (void)themeColorChanged {
    [super themeColorChanged];
    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.contentView.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    self.label.textColor = [LLThemeManager shared].primaryColor;
}

@end
