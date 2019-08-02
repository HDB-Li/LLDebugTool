//
//  LLScreenshotViewController.m
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

#import "LLScreenshotViewController.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLConst.h"
#import "LLConfig.h"

@interface LLScreenshotViewController ()

@property (nonatomic, strong) UIButton *captureButton;

@end

@implementation LLScreenshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Primary
- (void)initial {
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat width = 60;
    self.captureButton = [LLFactory getButton:self.view frame:CGRectMake((self.view.LL_width - 60) / 2.0, self.view.LL_bottom - kGeneralMargin * 2 - width, width, width) target:self action:@selector(captureButtonClicked:)];
    self.captureButton.layer.cornerRadius = width / 2.0;
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.borderWidth = 1;
    self.captureButton.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.captureButton.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
}

- (void)captureButtonClicked:(UIButton *)sender {
    
}

@end
