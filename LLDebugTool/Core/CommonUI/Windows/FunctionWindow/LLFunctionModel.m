//
//  LLFunctionModel.m
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

#import "LLFunctionModel.h"
#import "LLNetworkComponent.h"
#import "LLLogComponent.h"
#import "LLNetworkComponent.h"
#import "LLAppInfoComponent.h"
#import "LLSandboxComponent.h"
#import "LLScreenshotComponent.h"
#import "LLHierarchyComponent.h"
#import "LLMagnifierComponent.h"

@implementation LLFunctionModel

- (instancetype _Nonnull )initWithImageName:(NSString *)imageName title:(NSString *)title action:(LLFunctionAction)action {
    if (self = [super init]) {
        self.imageName = imageName;
        self.title = title;
        self.action = action;
    }
    return self;
}

- (LLComponent *)componentFromAction:(LLFunctionAction)action {
    switch (action) {
        case LLFunctionActionNetwork:
            return [[LLNetworkComponent alloc] init];
        case LLFunctionActionLog:
            return [[LLLogComponent alloc] init];
        case LLFunctionActionCrash:
            return [[LLNetworkComponent alloc] init];
        case LLFunctionActionAppInfo:
            return [[LLAppInfoComponent alloc] init];
        case LLFunctionActionSandbox:
            return [[LLSandboxComponent alloc] init];
        case LLFunctionActionScreenshot:
            return [[LLScreenshotComponent alloc] init];
        case LLFunctionActionHierarchy:
            return [[LLHierarchyComponent alloc] init];
        case LLFunctionActionMagnifier:
            return [[LLMagnifierComponent alloc] init];
        default:
            break;
    }
}

@end
