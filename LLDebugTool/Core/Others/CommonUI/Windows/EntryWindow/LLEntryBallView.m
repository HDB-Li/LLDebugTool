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
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"

@interface LLEntryBallView ()

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation LLEntryBallView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect logoImageViewRect = self.bounds;
    if (!CGRectEqualToRect(self.logoImageView.frame, logoImageViewRect)) {
        self.logoImageView.frame = logoImageViewRect;
    }
}

#pragma mark - Primary
- (void)initial {
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    [self LL_setCornerRadius:self.LL_width / 2];
    self.logoImageView = [LLFactory getImageView:self frame:CGRectZero image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
}

@end
