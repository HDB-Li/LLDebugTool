//
//  LLScreenshotWindow.m
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

#import "LLScreenshotWindow.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLConst.h"
#import "LLConfig.h"

@interface LLScreenshotWindow ()

@property (nonatomic, strong) UIButton *captureButton;

@end

@implementation LLScreenshotWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
- (void)initial {
    if (!self.rootViewController) {
        self.rootViewController = [[UIViewController alloc] init];
    }
    
    self.captureButton = [LLFactory getButton:self frame:CGRectMake((self.LL_width - 60) / 2.0, self.LL_height - kGeneralMargin * 2 - 60, 60, 60) target:self action:@selector(captureButtonClicked:)];
    self.captureButton.layer.cornerRadius = 30;
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.borderWidth = 1;
    self.captureButton.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.captureButton.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
}

- (void)captureButtonClicked:(UIButton *)sender {
    
}

@end
