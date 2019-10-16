//
//  LLNetworkHelper+UIWebView.m
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

#import "LLNetworkHelper+UIWebView.h"
#import "NSObject+LL_Runtime.h"
#import "LLNetworkModel.h"
#import "LLFormatterTool.h"
#import "NSData+LL_Utils.h"
#import "NSInputStream+LL_Utils.h"
#import "NSHTTPURLResponse+LL_Utils.h"
#import "LLStorageManager.h"
#import "LLAppInfoHelper.h"

@implementation LLNetworkHelper (UIWebView)

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.webViews[[NSString stringWithFormat:@"%p",webView]] = [NSDate date];
    if (webView.delegate != self && [webView.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [webView.delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self saveNetworkModel:webView error:nil];
    if (webView.delegate != self && [webView.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [webView.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self saveNetworkModel:webView error:error];
    if (webView.delegate != self && [webView.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [webView.delegate webViewDidFinishLoad:webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView.delegate != self && [webView.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [webView.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

#pragma mark - Primary
- (void)saveNetworkModel:(UIWebView *)webView error:(NSError *)error {
    LLNetworkModel *model = [[LLNetworkModel alloc] init];
    NSDate *startDate = self.webViews[[NSString stringWithFormat:@"%p",webView]];
    model.startDate = [LLFormatterTool stringFromDate:startDate style:FormatterToolDateStyle1];
    // Request
    NSURLRequest *request = webView.request;
    model.url = request.URL;
    model.method = request.HTTPMethod;
    model.headerFields = [request.allHTTPHeaderFields mutableCopy];
    
    NSData *data = [request.HTTPBody copy];
    if (data == nil) {
        NSInputStream *stream = request.HTTPBodyStream;
        if (stream) {
            data = [stream LL_toData];
        }
    }
    if (data && [data length] > 0) {
        model.requestBody = [data LL_toJsonString];
    }
    // Response
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)resp.response;
    model.stateLine = httpResponse.LL_stateLine;
    model.mimeType = httpResponse.MIMEType;
    if (model.mimeType.length == 0) {
        NSString *absoluteString = request.URL.absoluteString.lowercaseString;
        if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"]) {
            model.isImage = YES;
        } else if ([absoluteString hasSuffix:@".gif"]) {
            model.isGif = YES;
        }
    }
    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseHeaderFields = [httpResponse.allHeaderFields mutableCopy];
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:startDate]];
    model.error = error;
    [[LLStorageManager shared] saveModel:model complete:nil];
    [[LLAppInfoHelper shared] updateRequestDataTraffic:model.requestDataTrafficValue responseDataTraffic:model.responseDataTrafficValue];
    [self.webViews removeObjectForKey:[NSString stringWithFormat:@"%p",webView]];
}

#pragma mark - Getters and setters
- (NSMutableDictionary<NSString *,NSDate *> *)webViews {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [[NSMutableDictionary alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

@end
