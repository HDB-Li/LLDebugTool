//
//  NSURLSessionConfiguration+LL_Swizzling.m
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

#import "NSURLSessionConfiguration+LL_Swizzling.h"
#import <objc/runtime.h>
#import "LLURLProtocol.h"
#import "LLNetworkHelper.h"


@implementation NSURLSessionConfiguration (LL_Swizzling)

+ (void)load {
    Method method1 = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method method2 = class_getClassMethod([NSURLSessionConfiguration class], @selector(LL_defaultSessionConfiguration));
    method_exchangeImplementations(method1, method2);
    
    Method method3 = class_getClassMethod([NSURLSessionConfiguration class], @selector(ephemeralSessionConfiguration));
    Method method4 = class_getClassMethod([NSURLSessionConfiguration class], @selector(LL_ephemeralSessionConfiguration));
    method_exchangeImplementations(method3, method4);
}

+ (NSURLSessionConfiguration *)LL_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration LL_defaultSessionConfiguration];
    if ([LLNetworkHelper sharedHelper].isEnabled) {
        NSMutableArray *protocols = [[NSMutableArray alloc] initWithArray:config.protocolClasses];
        if (![protocols containsObject:[LLURLProtocol class]]) {
            [protocols insertObject:[LLURLProtocol class] atIndex:0];
        }
        config.protocolClasses = protocols;
    }
    return config;
}

+ (NSURLSessionConfiguration *)LL_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration LL_ephemeralSessionConfiguration];
    if ([LLNetworkHelper sharedHelper].isEnabled) {
        NSMutableArray *protocols = [[NSMutableArray alloc] init];
        [protocols addObjectsFromArray:config.protocolClasses];
        if (![protocols containsObject:[LLURLProtocol class]]) {
            [protocols insertObject:[LLURLProtocol class] atIndex:0];
        }
        config.protocolClasses = protocols;
    }
    return config;
}

@end
