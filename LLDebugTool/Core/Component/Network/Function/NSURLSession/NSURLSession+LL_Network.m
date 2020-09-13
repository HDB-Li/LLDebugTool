//
//  NSURLSession+LL_Network.m
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

#import "NSURLSession+LL_Network.h"

#import "LLDebugToolMacros.h"
#import "LLNetworkHelper.h"
#import "LLURLProtocol.h"

#import "NSObject+LL_Runtime.h"

@implementation NSURLSession (LL_Network)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSURLSession class] LL_swizzleClassSelector:@selector(sessionWithConfiguration:delegate:delegateQueue:) anotherSelector:@selector(LL_sessionWithConfiguration:delegate:delegateQueue:)];
    });
}

+ (NSURLSession *)LL_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    if (LLDT_CC_Network.isEnabled) {
        NSMutableArray *protocols = [[NSMutableArray alloc] initWithArray:configuration.protocolClasses];
        if (![protocols containsObject:[LLURLProtocol class]]) {
            [protocols insertObject:[LLURLProtocol class] atIndex:0];
        }
        configuration.protocolClasses = protocols;
    }
    return [self LL_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

@end
