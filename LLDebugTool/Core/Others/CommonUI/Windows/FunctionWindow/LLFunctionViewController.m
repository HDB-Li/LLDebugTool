//
//  LLFunctionViewController.m
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

#import "LLFunctionViewController.h"
#import "LLFunctionItemModel.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"
#import "LLMacros.h"
#import "LLFactory.h"
#import "LLNetworkViewController.h"
#import "LLLogViewController.h"
#import "LLCrashViewController.h"
#import "LLAppInfoViewController.h"
#import "LLSandboxViewController.h"
#import "LLHierarchyViewController.h"
#import "LLFunctionItemContainerView.h"
#import "UIView+LL_Utils.h"
#import "LLWindowManager.h"

@interface LLFunctionViewController ()<LLHierarchyViewControllerDelegate, LLFunctionContainerViewControllerDelegate>

@property (nonatomic, strong) LLFunctionItemContainerView *toolContainerView;

@property (nonatomic, strong) LLFunctionItemContainerView *shortCutContainerView;

@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation LLFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect toolContainerRect = CGRectMake(10, LL_NAVIGATION_HEIGHT + 10, self.view.LL_width - 10 * 2, self.toolContainerView.LL_height);
    if (!CGRectEqualToRect(self.toolContainerView.frame, toolContainerRect)) {
        self.toolContainerView.frame = toolContainerRect;
    }
    
    CGRect shortCutContainerRect = CGRectMake(self.toolContainerView.LL_left, self.toolContainerView.LL_bottom + 10, self.toolContainerView.LL_width , self.shortCutContainerView.LL_height);
    if (!CGRectEqualToRect(self.shortCutContainerView.frame, shortCutContainerRect)) {
        self.shortCutContainerView.frame = shortCutContainerRect;
    }
    
    CGRect settingButtonRect = CGRectMake(self.toolContainerView.LL_left, self.shortCutContainerView.LL_bottom + 30, self.toolContainerView.LL_width, 40);
    if (!CGRectEqualToRect(self.settingButton.frame, settingButtonRect)) {
        self.settingButton.frame = settingButtonRect;
    }
}

- (void)leftItemClick {
    [[LLWindowManager shared] dismissWindow:self.view.window animated:YES completion:^{
        [[LLWindowManager shared] showWindow:[LLWindowManager shared].suspensionWindow animated:NO];
        [[LLWindowManager shared] reloadFunctionWindow];
    }];
}

#pragma mark - Primary
- (void)initial {
    self.title = @"LLDebugTool";
 
    self.toolContainerView = [[LLFunctionItemContainerView alloc] initWithFrame:CGRectZero];
    self.toolContainerView.delegate = self;
    [self.view addSubview:self.toolContainerView];
    
    self.shortCutContainerView = [[LLFunctionItemContainerView alloc] initWithFrame:CGRectZero];
    self.shortCutContainerView.delegate = self;
    [self.view addSubview:self.shortCutContainerView];
    
    self.settingButton = [LLFactory getButton:self.view frame:CGRectZero target:self action:@selector(settingButtonClicked:)];
    [self.settingButton LL_setCornerRadius:5];
    [self.settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    [self.settingButton setTitleColor:LLCONFIG_TEXT_COLOR forState:UIControlStateNormal];
    [self.settingButton LL_setBorderColor:LLCONFIG_TEXT_COLOR borderWidth:1];
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:kNetworkImageName title:@"Net" action:LLFunctionActionNetwork]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:kLogImageName title:@"Log" action:LLFunctionActionLog]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:kCrashImageName title:@"Crash" action:LLFunctionActionCrash]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:kAppImageName title:@"App Info" action:LLFunctionActionAppInfo]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:kSandboxImageName title:@"Sandbox" action:LLFunctionActionSandbox]];
    
    self.toolContainerView.dataArray = [items copy];
    
    [items removeAllObjects];
    
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:@"" title:@"Screenshot" action:LLFunctionActionScreenshot]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:@"" title:@"Hierarchy" action:LLFunctionActionHierarchy]];
    [items addObject:[[LLFunctionItemModel alloc] initWithImageName:@"" title:@"Magnifier" action:LLFunctionActionMagnifier]];
    
    self.shortCutContainerView.dataArray = [items copy];
}

- (void)settingButtonClicked:(UIButton *)sender {
    
}

#pragma mark - LLFunctionContainerViewDelegate
- (void)llFunctionContainerView:(LLFunctionItemContainerView *)view didSelectAt:(LLFunctionItemModel *)model {
    LLComponent *component = model.component;
    [component componentDidLoad:nil];
}

#pragma mark - LLHierarchyViewControllerDelegate
- (void)LLHierarchyViewController:(LLHierarchyViewController *)viewController didFinishWithSelectedModel:(LLHierarchyModel *)selectedModel {
    [self.delegate LLFunctionViewController:self didSelectedHierarchyModel:selectedModel];
}

@end
