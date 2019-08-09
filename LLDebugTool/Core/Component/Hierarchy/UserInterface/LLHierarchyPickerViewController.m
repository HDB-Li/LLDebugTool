//
//  LLHierarchyPickerViewController.m
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

#import "LLHierarchyPickerViewController.h"
#import "LLHierarchyPickerView.h"
#import "LLHierarchyPickerInfoView.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "UIView+LL_Utils.h"
#import "LLConst.h"
#import "LLMacros.h"

@interface LLHierarchyPickerViewController ()<LLHierarchyPickerViewDelegate>

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) LLHierarchyPickerView *pickerView;

@property (nonatomic, strong) LLHierarchyPickerInfoView *infoView;

@end

@implementation LLHierarchyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Primary
- (void)initial {
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat height = 100;
    self.infoView = [[LLHierarchyPickerInfoView alloc] initWithFrame:CGRectMake(kGeneralMargin, LL_SCREEN_HEIGHT - kGeneralMargin * 2 - height, LL_SCREEN_WIDTH - kGeneralMargin * 2, height)];
    [self.view addSubview:self.infoView];
    
    self.borderView = [LLFactory getView:self.view frame:CGRectZero backgroundColor:[UIColor clearColor]];
    self.borderView.layer.borderWidth = 2;
    self.borderView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    
    self.pickerView = [[LLHierarchyPickerView alloc] initWithFrame:CGRectMake((self.view.LL_width - 60) / 2.0, (self.view.LL_height - 60) / 2.0, 60, 60)];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}

#pragma mark - LLHierarchyPickerViewDelegate
- (void)LLHierarchyPickerView:(LLHierarchyPickerView *)view didMoveTo:(UIView *)selectedView {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect rect = [selectedView convertRect:selectedView.bounds toView:window];
    rect = [self.view convertRect:rect fromView:window];
    self.borderView.frame = rect;
    
    [self.infoView updateView:selectedView];
}

@end
