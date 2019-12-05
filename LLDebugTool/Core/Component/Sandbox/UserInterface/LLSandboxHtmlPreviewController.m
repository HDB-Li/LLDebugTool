//
//  LLSandboxHtmlPreviewController.m
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

#import "LLSandboxHtmlPreviewController.h"

#import <WebKit/WebKit.h>

#import "LLImageNameConfig.h"
#import "LLTool.h"

#import "UIViewController+LL_Utils.h"
#import "NSDictionary+LL_Utils.h"
#import "NSArray+LL_Utils.h"

@interface LLSandboxHtmlPreviewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;

@property (nonatomic, strong) WKPreferences *preferences;

@end

@implementation LLSandboxHtmlPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark - Over write
- (void)rightItemClick:(UIButton *)sender {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:self.filePath]] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [self LL_showConfirmAlertControllerWithMessage:message handler:^{
        completionHandler();
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    [self LL_showAlertControllerWithMessage:message handler:^(NSInteger action) {
        completionHandler(action == 0 ? NO : YES);
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    [self LL_showTextFieldAlertControllerWithMessage:prompt text:defaultText handler:^(NSString * _Nullable newText) {
        completionHandler(newText);
    }];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - Primary
- (void)setUpUI {
    [self initNavigationItemWithTitle:nil imageName:kShareImageName isLeft:NO];
    
    [self.view addSubview:self.webView];
    
    if (!self.filePath) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    if (!url) {
        return;
    }
    
    self.title = [self.filePath lastPathComponent];
    
    if ([self.filePath.pathExtension caseInsensitiveCompare:@"plist"] == NSOrderedSame) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:url];
        NSArray *array = [[NSArray alloc] initWithContentsOfURL:url];
        NSString *htmlString = nil;
        if (dic != nil) {
            htmlString = [dic LL_toJsonString];
        } else if (array != nil) {
            htmlString = [array LL_toJsonString];
        }
        if (!htmlString) {
            [LLTool log:@"Load plist failed"];
            return;
        }
        htmlString = [NSString stringWithFormat:@"<div style=\"font-size: 35px;\">%@</div>",htmlString];
        [self loadHtmlString:htmlString];
    } else {
        if (@available(iOS 9.0, *)) {
            [self.webView loadFileURL:url allowingReadAccessToURL:url];
        } else {
            NSError *error = nil;
            NSString *string = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                [LLTool log:@"Load html string failed"];
                return;
            }
            [self loadHtmlString:string];
        }
    }
}

- (void)loadHtmlString:(NSString *)string {
    [self.webView loadHTMLString:string baseURL:[NSURL URLWithString:self.filePath.stringByDeletingLastPathComponent]];
}

#pragma mark - Getters and setters
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        _webViewConfiguration.preferences = self.preferences;
    }
    return _webViewConfiguration;
}

- (WKPreferences *)preferences {
    if (!_preferences) {
        _preferences = [[WKPreferences alloc] init];
        _preferences.javaScriptCanOpenWindowsAutomatically = YES;
    }
    return _preferences;
}

@end
