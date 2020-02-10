//
//  LLEntryBallView.m
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

#import "LLEntryBallView.h"

#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

#import "UIView+LL_Utils.h"

@interface LLEntryBallView ()

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation LLEntryBallView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.contentView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    [self.contentView LL_setCornerRadius:self.contentView.LL_width / 2];
    
    self.logoImageView = [LLFactory getImageView:self.contentView frame:CGRectMake(self.LL_width / 4.0, self.LL_height / 4.0, self.LL_width / 2.0, self.LL_height / 2.0) image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
}

- (void)themeColorChanged {
    [super themeColorChanged];
    
    self.contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.contentView.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    
    self.logoImageView.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.logoImageView.image = [UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor];
}

@end
