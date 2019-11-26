//
//  LLHtmlConfigViewController.m
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

#import "LLHtmlConfigViewController.h"

#import <WebKit/WebKit.h>

#import "LLHtmlUIWebViewController.h"
#import "LLHtmlWkWebViewController.h"
#import "LLTitleCellCategoryModel.h"
#import "LLHtmlViewController.h"
#import "LLSettingManager.h"
#import "LLTitleCellModel.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLToastUtils.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLHtmlConfigViewController () <UITextFieldDelegate>

@property (nonatomic, copy) NSString *webViewClass;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITextField *headerTextField;

@end

@implementation LLHtmlConfigViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.headerTextField isFirstResponder]) {
        [self.headerTextField resignFirstResponder];
    }
}

#pragma mark - Over write
- (void)rightItemClick:(UIButton *)sender {
    NSString *urlString = [self currentUrlString];
    if (!urlString) {
        [[LLToastUtils shared] toastMessage:@"Empty URL"];
        return;
    }
    if (![urlString.lowercaseString hasPrefix:@"https://"] && ![urlString.lowercaseString hasPrefix:@"http://"]) {
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"html.url.check")];
        return;
    }
    Class cls = NSClassFromString(self.webViewClass);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (cls != [UIWebView class] && cls != [WKWebView class]) {
#pragma clang diagnostic pop
        if ([LLConfig shared].htmlViewControllerProvider != nil) {
            UIViewController *customViewController = [LLConfig shared].htmlViewControllerProvider(urlString);
            if (customViewController && cls == [customViewController class]) {
                [LLSettingManager shared].lastWebViewUrl = urlString;
                [self.navigationController pushViewController:customViewController animated:YES];
                return;
            }
            [[LLToastUtils shared] toastMessage:LLLocalizedString(@"html.provider.fail")];
            return;
        }
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"html.invalid.class")];
        return;
    }
    
    [LLSettingManager shared].lastWebViewUrl = urlString;
    
    LLHtmlViewController *vc = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (cls == [UIWebView class]) {
#pragma clang diagnostic pop
        vc = [[LLHtmlUIWebViewController alloc] init];
    } else {
        vc = [[LLHtmlWkWebViewController alloc] init];
    }
    vc.webViewClass = self.webViewClass;
    vc.urlString = [self currentUrlString];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Primary
- (void)setUpUI {
    self.title = LLLocalizedString(@"function.html");
    [self initNavigationItemWithTitle:@"Go" imageName:nil isLeft:NO];
    
    self.webViewClass = [LLSettingManager shared].webViewClass ?: NSStringFromClass([WKWebView class]);
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    // Short Cut
    [settings addObject:[self getWebViewStyleModel]];
    LLTitleCellCategoryModel *category0 = [[LLTitleCellCategoryModel alloc] initWithTitle:nil items:settings];
    [settings removeAllObjects];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:@[category0]];
    [self.tableView reloadData];
}

- (LLTitleCellModel *)getWebViewStyleModel {
    LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"style") detailTitle:self.webViewClass];
    __weak typeof(self) weakSelf = self;
    model.block = ^{
        [weakSelf showWebViewClassAlert];
    };
    return model;
}

- (void)showWebViewClassAlert {
    __block NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:NSStringFromClass([WKWebView class])];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [actions addObject:NSStringFromClass([UIWebView class])];
#pragma clang diagnostic pop
    if ([LLConfig shared].htmlViewControllerProvider != nil) {
        UIViewController *vc = [LLConfig shared].htmlViewControllerProvider(nil);
        if (vc) {
            [actions addObject:NSStringFromClass([vc class])];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"style") actions:actions currentAction:self.webViewClass completion:^(NSInteger index) {
        [weakSelf setNewWebViewClass:actions[index]];
    }];
}

- (void)setNewWebViewClass:(NSString *)aClass {
    self.webViewClass = aClass;
    [LLSettingManager shared].webViewClass = aClass;
    [self loadData];
}

- (NSString *)currentUrlString {
    NSString *text = self.headerTextField.text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!text || text.length == 0) {
        return nil;
    }
    return text;
}

#pragma mark - Getters and setters
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [LLFactory getView];
        _headerView.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, 60);
        [_headerView addSubview:self.headerTextField];
        self.headerTextField.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, _headerView.LL_width - kLLGeneralMargin * 2, _headerView.LL_height - kLLGeneralMargin * 2);
    }
    return _headerView;
}

- (UITextField *)headerTextField {
    if (!_headerTextField) {
        _headerTextField = [LLFactory getTextField];
        _headerTextField.tintColor = [LLThemeManager shared].primaryColor;
        _headerTextField.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_headerTextField LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
        [_headerTextField LL_setCornerRadius:5];
        _headerTextField.font = [UIFont systemFontOfSize:14];
        _headerTextField.textColor = [LLThemeManager shared].primaryColor;
        _headerTextField.delegate = self;
        _headerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _headerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LLLocalizedString(@"html.input.url") attributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].placeHolderColor}];
        _headerTextField.text = [LLSettingManager shared].lastWebViewUrl ?: ([LLConfig shared].defaultHtmlUrl ?: @"https://");
        UIView *leftView = [LLFactory getView];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _headerTextField.leftView = leftView;
        _headerTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _headerTextField;
}

@end
