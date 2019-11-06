//
//  LLComponentNavigationController.m
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

#import "LLComponentNavigationController.h"

#import "LLBaseViewController.h"
#import "LLImageNameConfig.h"
#import "LLComponentWindow.h"
#import "LLThemeManager.h"

#import "UIViewController+LL_Utils.h"

@interface LLComponentNavigationController ()

@end

@implementation LLComponentNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        if (![rootViewController isKindOfClass:[LLBaseViewController class]]) {
            UIButton *btn = [self LL_navigationButtonWithTitle:nil imageName:kCloseImageName target:self action:@selector(leftItemClick:)];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
}

- (void)leftItemClick:(UIButton *)sender {
    if ([self.view.window isKindOfClass:[LLComponentWindow class]]) {
        LLComponentWindow *window = (LLComponentWindow *)self.view.window;
        [window componentDidFinish];
    }
}

@end
