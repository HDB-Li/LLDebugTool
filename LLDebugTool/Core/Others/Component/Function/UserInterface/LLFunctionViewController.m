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

#import "LLFunctionItemContainerView.h"
#import "LLFunctionItemModel.h"
#import "LLInternalMacros.h"
#import "LLWindowManager.h"
#import "LLThemeManager.h"
#import "LLComponent.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLFunctionViewController ()<LLFunctionContainerViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LLFunctionItemContainerView *toolContainerView;

@property (nonatomic, strong) LLFunctionItemContainerView *shortCutContainerView;

@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation LLFunctionViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LLDebugTool";
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.toolContainerView];
    [self.scrollView addSubview:self.shortCutContainerView];
    [self.scrollView addSubview:self.settingButton];
    
    [self loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
        
    self.toolContainerView.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.view.LL_width - kLLGeneralMargin * 2, self.toolContainerView.LL_height);

    self.shortCutContainerView.frame = CGRectMake(self.toolContainerView.LL_left, self.toolContainerView.LL_bottom + kLLGeneralMargin, self.toolContainerView.LL_width , self.shortCutContainerView.LL_height);
    
    self.settingButton.frame = CGRectMake(self.toolContainerView.LL_left, self.shortCutContainerView.LL_bottom + 30, self.toolContainerView.LL_width, 40);
    
    
    self.scrollView.contentSize = CGSizeMake(0, self.settingButton.LL_bottom + 30);
}

#pragma mark - Over write
- (void)themeColorChanged {
    [super themeColorChanged];
    [self.settingButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
    self.settingButton.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
}

#pragma mark - Primary
- (void)loadData {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    LLFunctionItemModel *network = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionNetwork];
    if (network) {
        [items addObject:network];
    }
    LLFunctionItemModel *log = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionLog];
    if (log) {
        [items addObject:log];
    }
    LLFunctionItemModel *crash = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionCrash];
    if (crash) {
        [items addObject:crash];
    }
    LLFunctionItemModel *appInfo = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionAppInfo];
    if (appInfo) {
        [items addObject:appInfo];
    }
    LLFunctionItemModel *sandbox = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionSandbox];
    if (sandbox) {
        [items addObject:sandbox];
    }
    LLFunctionItemModel *location = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionLocation];
    if (location) {
        [items addObject:location];
    }
        
    self.toolContainerView.dataArray = [items copy];
    self.toolContainerView.title = LLLocalizedString(@"function.function");
    self.toolContainerView.hidden = items.count == 0;
    
    [items removeAllObjects];
    
    LLFunctionItemModel *screenshot = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionScreenshot];
    if (screenshot) {
        [items addObject:screenshot];
    }
    
    LLFunctionItemModel *hierarchy = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionHierarchy];
    if (hierarchy) {
        [items addObject:hierarchy];
    }
    
    LLFunctionItemModel *magnifier = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionMagnifier];
    if (magnifier) {
        [items addObject:magnifier];
    }
    
    LLFunctionItemModel *ruler = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionRuler];
    if (ruler) {
        [items addObject:ruler];
    }
    
    LLFunctionItemModel *widgetBorder = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionWidgetBorder];
    if (widgetBorder) {
        [items addObject:widgetBorder];
    }
    
    LLFunctionItemModel *html = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionHtml];
    if (html) {
        [items addObject:html];
    }
    
    LLFunctionItemModel *shortCut = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionShortCut];
    if (shortCut) {
        [items addObject:shortCut];
    }
    
    self.shortCutContainerView.dataArray = [items copy];
    self.shortCutContainerView.title = LLLocalizedString(@"function.short");
    self.shortCutContainerView.hidden = items.count == 0;
    
    [items removeAllObjects];
}

#pragma mark - LLFunctionContainerViewDelegate
- (void)LLFunctionContainerView:(LLFunctionItemContainerView *)view didSelectAt:(LLFunctionItemModel *)model {
    LLComponent *component = model.component;
    [component componentDidLoad:nil];
}

#pragma mark - Event response
- (void)settingButtonClicked:(UIButton *)sender {
    [[[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionSetting].component componentDidLoad:nil];
}

#pragma mark - Getters and setters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [LLFactory getScrollView];
    }
    return _scrollView;
}

- (LLFunctionItemContainerView *)toolContainerView {
    if (!_toolContainerView) {
        _toolContainerView = [[LLFunctionItemContainerView alloc] initWithFrame:CGRectZero];
        _toolContainerView.delegate = self;
    }
    return _toolContainerView;
}

- (LLFunctionItemContainerView *)shortCutContainerView {
    if (!_shortCutContainerView) {
        _shortCutContainerView = [[LLFunctionItemContainerView alloc] initWithFrame:CGRectZero];
        _shortCutContainerView.delegate = self;
    }
    return _shortCutContainerView;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(settingButtonClicked:)];
        [_settingButton LL_setCornerRadius:5];
        [_settingButton setTitle:LLLocalizedString(@"function.setting") forState:UIControlStateNormal];
        [_settingButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        [_settingButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    }
    return _settingButton;
}

@end
