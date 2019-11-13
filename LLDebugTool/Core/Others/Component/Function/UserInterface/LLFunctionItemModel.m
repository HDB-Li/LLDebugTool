//
//  LLFunctionItemModel.m
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

#import "LLFunctionItemModel.h"

#import "LLImageNameConfig.h"

@implementation LLFunctionItemModel

- (instancetype _Nullable)initWithAction:(LLDebugToolAction)action {
    if (self = [super init]) {
        _action = action;
        LLComponent *component = [self componentFromAction:action];
        if (!component) {
            return nil;
        }
        _component = component;
        _imageName = [self imageNameFromAction:action];
        _title = [self titleFromAction:action];
    }
    return self;
}

- (LLComponent *_Nullable)componentFromAction:(LLDebugToolAction)action {
    NSString *component = nil;
    switch (action) {
        case LLDebugToolActionFunction: {
            component = @"LLFunctionComponent";
        }
            break;
        case LLDebugToolActionSetting: {
            component = @"LLSettingComponent";
        }
            break;
        case LLDebugToolActionNetwork: {
            component = @"LLNetworkComponent";
        }
            break;
        case LLDebugToolActionLog: {
            component = @"LLLogComponent";
        }
            break;
        case LLDebugToolActionCrash: {
            component = @"LLCrashComponent";
        }
            break;
        case LLDebugToolActionAppInfo: {
            component = @"LLAppInfoComponent";
        }
            break;
        case LLDebugToolActionSandbox: {
            component = @"LLSandboxComponent";
        }
            break;
        case LLDebugToolActionScreenshot: {
            component = @"LLScreenshotComponent";
        }
            break;
        case LLDebugToolActionConvenientScreenshot: {
            component = @"LLConvenientScreenshotComponent";
        }
            break;
        case LLDebugToolActionHierarchy: {
            component = @"LLHierarchyComponent";
        }
            break;
        case LLDebugToolActionMagnifier: {
            component = @"LLMagnifierComponent";
        }
            break;
        case LLDebugToolActionRuler: {
            component = @"LLRulerComponent";
        }
            break;
        case LLDebugToolActionWidgetBorder: {
            component = @"LLWidgetBorderComponent";
        }
            break;
        case LLDebugToolActionHtml: {
            component = @"LLHtmlComponent";
        }
            break;
    }
    if (component) {
        return [[NSClassFromString(component) alloc] init];
    }
    return nil;
}

- (NSString *)titleFromAction:(LLDebugToolAction)action {
    switch (action) {
        case LLDebugToolActionFunction:
            return @"Function";
        case LLDebugToolActionSetting:
            return @"Setting";
        case LLDebugToolActionNetwork:
            return @"Net";
        case LLDebugToolActionLog:
            return @"Log";
        case LLDebugToolActionCrash:
            return @"Crash";
        case LLDebugToolActionAppInfo:
            return @"App Info";
        case LLDebugToolActionSandbox:
            return @"Sandbox";
        case LLDebugToolActionScreenshot:
            return @"Screenshot";
        case LLDebugToolActionConvenientScreenshot:
            return @"Convenient Screenshot";
        case LLDebugToolActionHierarchy:
            return @"Hierarchy";
        case LLDebugToolActionMagnifier:
            return @"Magnifier";
        case LLDebugToolActionRuler:
            return @"Ruler";
        case LLDebugToolActionWidgetBorder:
            return @"Widget Border";
        case LLDebugToolActionHtml:
            return @"Html5";
    }
}

- (NSString *)imageNameFromAction:(LLDebugToolAction)action {
    switch (action) {
        case LLDebugToolActionFunction:
        case LLDebugToolActionSetting:
            return @"";
        case LLDebugToolActionNetwork:
            return kNetworkImageName;
        case LLDebugToolActionLog:
            return kLogImageName;
        case LLDebugToolActionCrash:
            return kCrashImageName;
        case LLDebugToolActionAppInfo:
            return kAppImageName;
        case LLDebugToolActionSandbox:
            return kSandboxImageName;
        case LLDebugToolActionScreenshot:
        case LLDebugToolActionConvenientScreenshot:
            return kScreenshotImageName;
        case LLDebugToolActionHierarchy:
            return kHierarchyImageName;
        case LLDebugToolActionMagnifier:
            return kMagnifierImageName;
        case LLDebugToolActionRuler:
            return kRulerImageName;
        case LLDebugToolActionWidgetBorder:
            return kWidgetBorderImageName;
        case LLDebugToolActionHtml:
            return kHtml5ImageName;
    }
}

@end
