//
//  LLNetworkHelper.m
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

#import "LLNetworkHelper.h"
#import "LLURLProtocol.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"

static LLNetworkHelper *_instance = nil;

@implementation LLNetworkHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLNetworkHelper alloc] init];
    });
    return _instance;
}

- (void)setEnable:(BOOL)enable {
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self registerLLURLProtocol];
        } else {
            [self unregisterLLURLProtocol];
        }
    }
}

#pragma mark - Primary
- (void)registerLLURLProtocol {
    if (![NSURLProtocol registerClass:[LLURLProtocol class]]) {
        LLog_Alert_Event(kLLLogHelperDebugToolEvent, @"LLNetworkHelper reigsiter URLProtocol fail.");
    }
}

- (void)unregisterLLURLProtocol {
    [NSURLProtocol unregisterClass:[LLURLProtocol class]];
}

@end
