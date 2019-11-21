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
        case LLDebugToolActionLocation: {
            component = @"LLLocationComponent";
        }
    }
    if (component) {
        return [[NSClassFromString(component) alloc] init];
    }
    return nil;
}

- (NSString *)titleFromAction:(LLDebugToolAction)action {
    NSString *title = @"";
    switch (action) {
        case LLDebugToolActionFunction: {
            title = @"Function";
        }
            break;
        case LLDebugToolActionSetting: {
            title = @"Setting";
        }
            break;
        case LLDebugToolActionNetwork: {
            title = @"Net";
        }
            break;
        case LLDebugToolActionLog: {
            title = @"Log";
        }
            break;
        case LLDebugToolActionCrash: {
            title = @"Crash";
        }
            break;
        case LLDebugToolActionAppInfo: {
            title = @"App Info";
        }
            break;
        case LLDebugToolActionSandbox: {
            title = @"Sandbox";
        }
            break;
        case LLDebugToolActionScreenshot: {
            title = @"Screenshot";
        }
            break;
        case LLDebugToolActionConvenientScreenshot: {
            title = @"Convenient Screenshot";
        }
            break;
        case LLDebugToolActionHierarchy: {
            title = @"Hierarchy";
        }
            break;
        case LLDebugToolActionMagnifier: {
            title = @"Magnifier";
        }
            break;
        case LLDebugToolActionRuler: {
            title = @"Ruler";
        }
            break;
        case LLDebugToolActionWidgetBorder: {
            title = @"Widget Border";
        }
            break;
        case LLDebugToolActionHtml: {
            title = @"Html5";
        }
            break;
        case LLDebugToolActionLocation: {
            title = @"Location";
        }
            break;
    }
    return title;
}

- (NSString *)imageNameFromAction:(LLDebugToolAction)action {
    NSString *imageName = @"";
    switch (action) {
        case LLDebugToolActionFunction:
        case LLDebugToolActionSetting: {
            imageName = @"";
        }
            break;
        case LLDebugToolActionNetwork: {
            imageName = kNetworkImageName;
        }
            break;
        case LLDebugToolActionLog: {
            imageName = kLogImageName;
        }
            break;
        case LLDebugToolActionCrash: {
            imageName = kCrashImageName;
        }
            break;
        case LLDebugToolActionAppInfo: {
            imageName = kAppImageName;
        }
            break;
        case LLDebugToolActionSandbox: {
            imageName = kSandboxImageName;
        }
            break;
        case LLDebugToolActionScreenshot:
        case LLDebugToolActionConvenientScreenshot: {
            imageName = kScreenshotImageName;
        }
            break;
        case LLDebugToolActionHierarchy: {
            imageName = kHierarchyImageName;
        }
            break;
        case LLDebugToolActionMagnifier: {
            imageName = kMagnifierImageName;
        }
            break;
        case LLDebugToolActionRuler: {
            imageName = kRulerImageName;
        }
            break;
        case LLDebugToolActionWidgetBorder: {
            imageName = kWidgetBorderImageName;
        }
            break;
        case LLDebugToolActionHtml: {
            imageName = kHtml5ImageName;
        }
            break;
        case LLDebugToolActionLocation: {
            imageName = kLocationImageName;
        }
            break;
    }
    return imageName;
}

@end
