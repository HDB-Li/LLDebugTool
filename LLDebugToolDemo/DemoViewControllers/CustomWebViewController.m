//
//  CustomWebViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2019/10/15.
//  Copyright © 2019 li. All rights reserved.
//

#import "CustomWebViewController.h"
#import <WebKit/WebKit.h>

@interface CustomWebViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation CustomWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url ?:  @"https://github.com/HDB-Li/LLDebugTool"]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    self.titleLabel.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, 100);
    self.webView.frame = CGRectMake(0, navigationBarHeight + 100, self.view.frame.size.width, self.view.frame.size.height - 100 - navigationBarHeight);
}

#pragma mark - Getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSLocalizedString(@"custom.html.view.controller", nil);
    }
    return _titleLabel;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
    }
    return _webView;
}

@end
