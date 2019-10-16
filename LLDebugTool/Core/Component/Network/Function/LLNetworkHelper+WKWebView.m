//
//  LLNetworkHelper+WKWebView.m
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

#import "LLNetworkHelper+WKWebView.h"
#import "NSObject+LL_Runtime.h"
#import "LLNetworkModel.h"
#import "LLFormatterTool.h"
#import "NSData+LL_Utils.h"
#import "NSInputStream+LL_Utils.h"
#import "NSHTTPURLResponse+LL_Utils.h"
#import "LLStorageManager.h"
#import "LLAppInfoHelper.h"
#import "LLTool.h"

@implementation LLNetworkHelper (WKWebView)

//+ (void)load {
//    Protocol *proto = @protocol(WKNavigationDelegate); //objc_getProtocol("WKNavigationDelegate");
//    unsigned int count;
//    struct objc_method_description *methods = protocol_copyMethodDescriptionList(proto, NO, YES, &count);
//    for(unsigned int i = 0; i < count; i++) {
//        SEL sel = methods[i].name;
//        if (!class_respondsToSelector([self class], sel)) {
//            [LLTool log:[NSString stringWithFormat:@"LLNetworkHelper didn't implementation selector : %@",NSStringFromSelector(sel)]];
//        }
//    }
//    if (methods) {
//        free(methods);
//    }
//}
//
////#pragma mark - WKNavigationDelegate
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
//    } else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences * _Nonnull))decisionHandler API_AVAILABLE(ios(13.0)){
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction preferences:preferences decisionHandler:decisionHandler];
//    } else if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
//        [webView.navigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
//            decisionHandler(policy, preferences);
//        }];
//    } else {
//        decisionHandler(WKNavigationActionPolicyAllow, preferences);
//    }
//}
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
//    } else {
//        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
//}
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    self.webViews[[NSString stringWithFormat:@"%p",webView]] = [NSDate date];
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didStartProvisionalNavigation:navigation];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    [self saveNetworkModel:webView error:error];
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didCommitNavigation:navigation];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self saveNetworkModel:webView error:nil];
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didFinishNavigation:navigation];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    [self saveNetworkModel:webView error:error];
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didFailNavigation:navigation withError:error];
//    }
//}
//
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
//    } else {
//        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
//    }
//}
//
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(ios(9.0)) {
//    if (webView.navigationDelegate != self && [webView.navigationDelegate respondsToSelector:_cmd]) {
//        [webView.navigationDelegate webViewWebContentProcessDidTerminate:webView];
//    }
//}
//
//#pragma mark - Primary
//- (void)saveNetworkModel:(WKWebView *)webView error:(NSError *)error {
//    
//}
//
//#pragma mark - Getters and setters
//- (NSMutableDictionary<NSString *,NSDate *> *)webViews {
//    if (!objc_getAssociatedObject(self, _cmd)) {
//        objc_setAssociatedObject(self, _cmd, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return objc_getAssociatedObject(self, _cmd);
//}


@end
