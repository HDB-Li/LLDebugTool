//
//  LLEntryRectView.m
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

#import "LLEntryRectView.h"
#import "LLThemeManager.h"
#import "LLConfig.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "UIView+LL_Utils.h"

@interface LLEntryRectView ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *label;

@end

@implementation LLEntryRectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
- (void)initial {
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    
    self.icon = [LLFactory getImageView:self frame:CGRectMake(5, 3, 14, 14) image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
    self.label = [LLFactory getLabel:self frame:CGRectMake(self.icon.LL_right + 5, 0, 100, 20) text:@"LLDebugTool" font:12 textColor:[LLThemeManager shared].primaryColor];
    [self.label sizeToFit];
    self.label.LL_height = 20;
    self.LL_width = self.label.LL_right + 5;
}

@end
