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

#import "LLComponent.h"
#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLFactory.h"
#import "LLFunctionItemContainerView.h"
#import "LLFunctionItemModel.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLWindowManager.h"

#import "NSMutableArray+LL_Utils.h"
#import "UIView+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

@interface LLFunctionViewController () <LLFunctionContainerViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LLFunctionItemContainerView *toolContainerView;

@property (nonatomic, strong) LLFunctionItemContainerView *shortCutContainerView;

@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIButton *stopButton;

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
    [self.scrollView addSubview:self.stopButton];

    [self loadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.bounds;

    self.toolContainerView.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.view.LL_width - kLLGeneralMargin * 2, self.toolContainerView.LL_height);

    self.shortCutContainerView.frame = CGRectMake(self.toolContainerView.LL_left, self.toolContainerView.LL_bottom + kLLGeneralMargin, self.toolContainerView.LL_width, self.shortCutContainerView.LL_height);

    self.settingButton.frame = CGRectMake(self.toolContainerView.LL_left, self.shortCutContainerView.LL_bottom + kLLGeneralMargin * 3, self.toolContainerView.LL_width, 40);

    self.stopButton.frame = CGRectMake(self.settingButton.LL_left, self.settingButton.LL_bottom + kLLGeneralMargin, self.settingButton.LL_width, 40);

    self.scrollView.contentSize = CGSizeMake(0, self.stopButton.LL_bottom + kLLGeneralMargin * 3);
}

#pragma mark - Over write
- (void)themeColorChanged {
    [super themeColorChanged];
    [self.settingButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
    self.settingButton.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    self.stopButton.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
}

#pragma mark - Primary
- (void)loadData {
    NSMutableArray *items = [[NSMutableArray alloc] init];

    [items addObjectsFromArray:[self loadToolContainerData]];

    self.toolContainerView.dataArray = [items copy];
    self.toolContainerView.title = LLLocalizedString(@"function.function");
    self.toolContainerView.hidden = items.count == 0;

    [items removeAllObjects];

    [items addObjectsFromArray:[self loadShortCutContainerDate]];

    self.shortCutContainerView.dataArray = [items copy];
    self.shortCutContainerView.title = LLLocalizedString(@"function.short");
    self.shortCutContainerView.hidden = items.count == 0;

    [items removeAllObjects];
}

- (NSArray *)loadToolContainerData {
    NSMutableArray *items = [[NSMutableArray alloc] init];

    LLFunctionItemModel *network = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionNetwork];
    [items LL_addObject:network];

    LLFunctionItemModel *log = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionLog];
    [items LL_addObject:log];

    LLFunctionItemModel *crash = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionCrash];
    [items LL_addObject:crash];

    LLFunctionItemModel *appInfo = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionAppInfo];
    [items LL_addObject:appInfo];

    LLFunctionItemModel *sandbox = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionSandbox];
    [items LL_addObject:sandbox];

    LLFunctionItemModel *location = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionLocation];
    [items LL_addObject:location];

    return [items copy];
}

- (NSArray *)loadShortCutContainerDate {
    NSMutableArray *items = [[NSMutableArray alloc] init];

    LLFunctionItemModel *screenshot = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionScreenshot];
    [items LL_addObject:screenshot];

    LLFunctionItemModel *hierarchy = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionHierarchy];
    [items LL_addObject:hierarchy];

    LLFunctionItemModel *magnifier = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionMagnifier];
    [items LL_addObject:magnifier];

    LLFunctionItemModel *ruler = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionRuler];
    [items LL_addObject:ruler];

    LLFunctionItemModel *widgetBorder = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionWidgetBorder];
    [items LL_addObject:widgetBorder];

    LLFunctionItemModel *html = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionHtml];
    [items LL_addObject:html];

    LLFunctionItemModel *shortCut = [[LLFunctionItemModel alloc] initWithAction:LLDebugToolActionShortCut];
    [items LL_addObject:shortCut];

    return [items copy];
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

- (void)stopButtonClicked:(UIButton *)sender {
    [self LL_showAlertControllerWithMessage:LLLocalizedString(@"function.alert.stop")
                                    handler:^(NSInteger action) {
                                        [[LLDebugTool sharedTool] stopWorking];
                                    }];
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

- (UIButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(stopButtonClicked:)];
        [_stopButton LL_setCornerRadius:5];
        [_stopButton setTitle:LLLocalizedString(@"function.stop") forState:UIControlStateNormal];
        [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopButton setBackgroundColor:[UIColor redColor]];
        [_stopButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    }
    return _stopButton;
}

@end
