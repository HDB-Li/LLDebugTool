//
//  LLHtmlUIWebViewController.m
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

#import "LLHtmlUIWebViewController.h"
#import "LLTool.h"

@interface LLHtmlUIWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LLHtmlUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [LLTool log:[NSString stringWithFormat:@"Log UIWebView failed in %@, with error %@", self.urlString, error.debugDescription]];
}

#pragma mark - Primary
- (void)setUpUI {
    if (![self webViewClassIsValid]) {
        self.webViewClass = NSStringFromClass([UIWebView class]);
    }
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (BOOL)webViewClassIsValid {
    if (!self.webViewClass || self.webViewClass.length == 0) {
        return NO;
    }
    Class cls = NSClassFromString(self.webViewClass);
    if (cls != [UIWebView class]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getters and setters
- (UIWebView *)webView {
    if (!_webView) {
        _webView = (UIWebView *)[[NSClassFromString(self.webViewClass) alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

@end
