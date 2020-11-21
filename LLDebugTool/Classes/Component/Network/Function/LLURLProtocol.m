//
//  LLURLProtocol.m
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

#import "LLURLProtocol.h"

#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLFormatterTool.h"
#import "LLNetworkModel.h"
#import "LLStorageManager.h"
#import "LLTool.h"

#import "NSData+LL_Network.h"
#import "NSHTTPURLResponse+LL_Network.h"
#import "NSInputStream+LL_Network.h"

static NSString *const kLLURLProtocolIdentifier = @"kLLURLProtocolIdentifier";

@interface LLURLProtocol () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSError *error;

@end

@implementation LLURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *scheme = request.URL.scheme;
    if ([scheme caseInsensitiveCompare:@"http"] != NSOrderedSame && [scheme caseInsensitiveCompare:@"https"] != NSOrderedSame) {
        return NO;
    }

    if ([NSURLProtocol propertyForKey:kLLURLProtocolIdentifier inRequest:request]) {
        return NO;
    }

    if ([LLDebugConfig shared].observerdHosts.count > 0) {
        NSString *host = request.URL.host;
        for (NSString *observerdHost in [LLDebugConfig shared].observerdHosts) {
            if ([host caseInsensitiveCompare:observerdHost] == NSOrderedSame) {
                return YES;
            }
        }
        return NO;
    }

    if ([LLDebugConfig shared].ignoredHosts.count > 0) {
        NSString *host = request.URL.host;
        for (NSString *ignoredHost in [LLDebugConfig shared].ignoredHosts) {
            if ([host caseInsensitiveCompare:ignoredHost] == NSOrderedSame) {
                return NO;
            }
        }
    }

    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:kLLURLProtocolIdentifier
                     inRequest:mutableReqeust];
    //    return [mutableReqeust copy];
    return mutableReqeust;
}

- (void)startLoading {
    self.startDate = [NSDate date];
    self.data = [NSMutableData data];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.dataTask = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)stopLoading {
    [self.dataTask cancel];
    self.dataTask = nil;
    LLNetworkModel *model = [[LLNetworkModel alloc] init];
    model.startDate = [LLFormatterTool stringFromDate:self.startDate style:FormatterToolDateStyle1];
    // Request
    model.url = self.request.URL;
    model.method = self.request.HTTPMethod;
    model.headerFields = [self.request.allHTTPHeaderFields mutableCopy];

    NSData *data = [self.request.HTTPBody copy];
    if (data == nil) {
        NSInputStream *stream = self.request.HTTPBodyStream;
        if (stream) {
            data = [stream LL_data];
        }
    }
    if ([data length] > 0) {
        model.requestBody = [data LL_jsonString];
    }

    // Response
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)self.response;
    model.stateLine = httpResponse.LL_stateLine;
    model.mimeType = self.response.MIMEType;
    if (model.mimeType.length == 0) {
        NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
        model.isImage = [self isImageWithUrl:absoluteString];
        model.isGif = [self isGifWithUrl:absoluteString];
    }
    model.statusCode = [NSString stringWithFormat:@"%d", (int)httpResponse.statusCode];
    model.responseData = self.data;
    model.responseHeaderFields = [httpResponse.allHeaderFields mutableCopy];
    model.totalDuration = [NSString stringWithFormat:@"%fs", [[NSDate date] timeIntervalSinceDate:self.startDate]];
    model.error = self.error;
    [[LLStorageManager shared] saveModel:model complete:nil];
    [LLDT_CC_AppInfo updateRequestDataTraffic:model.requestDataTrafficValue responseDataTraffic:model.responseDataTrafficValue];
}

#pragma mark - NSURLSessionDelegate
// This method ignores certificate validation to resolve some untrusted HTTP requests that fail, and is recommended only in debug mode.
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error && ![error.domain isEqualToString:NSURLErrorDomain] && error.code != NSURLErrorCancelled) {
        [self.client URLProtocol:self didFailWithError:error];
    } else if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    }

    self.error = error;
    self.dataTask = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    if (response != nil) {
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}

#pragma mark - Primary
- (BOOL)isImageWithUrl:(NSString *)absoluteString {
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isGifWithUrl:(NSString *)absoluteString {
    if ([absoluteString hasSuffix:@".gif"]) {
        return YES;
    }
    return NO;
}

@end
