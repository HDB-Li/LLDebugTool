//
//  LLEntryTitleView.m
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

#import "LLEntryTitleView.h"

#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLConfig.h"
#import "LLFactory.h"

#import "UIView+LL_Utils.h"

@interface LLEntryTitleView ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *label;

@end

@implementation LLEntryTitleView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.contentView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    
    self.icon = [LLFactory getImageView:self.contentView frame:CGRectMake(5, (self.LL_height - 14) / 2.0, 14, 14) image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
    self.label = [LLFactory getLabel:self.contentView frame:CGRectMake(self.icon.LL_right + 5, 0, 100, self.LL_height) text:@"LLDebugTool" font:12 textColor:[LLThemeManager shared].primaryColor];
    [self.label sizeToFit];
    self.label.LL_height = self.LL_height;
    self.LL_width = self.label.LL_right + 5;
}

- (void)themeColorChanged {
    [super themeColorChanged];
    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.contentView.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    self.icon.image = [UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor];
    self.label.textColor = [LLThemeManager shared].primaryColor;
}

@end
