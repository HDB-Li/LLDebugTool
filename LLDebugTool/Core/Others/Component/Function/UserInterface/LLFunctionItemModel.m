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
#import "LLInternalMacros.h"

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
            break;
        case LLDebugToolActionShortCut: {
            component = @"LLShortCutComponent";
        }
            break;
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
            title = LLLocalizedString(@"function.function");
        }
            break;
        case LLDebugToolActionSetting: {
            title = LLLocalizedString(@"function.setting");
        }
            break;
        case LLDebugToolActionNetwork: {
            title = LLLocalizedString(@"function.net");
        }
            break;
        case LLDebugToolActionLog: {
            title = LLLocalizedString(@"function.log");
        }
            break;
        case LLDebugToolActionCrash: {
            title = LLLocalizedString(@"function.crash");
        }
            break;
        case LLDebugToolActionAppInfo: {
            title = LLLocalizedString(@"function.app.info");
        }
            break;
        case LLDebugToolActionSandbox: {
            title = LLLocalizedString(@"function.sandbox");
        }
            break;
        case LLDebugToolActionScreenshot: {
            title = LLLocalizedString(@"function.screenshot");
        }
            break;
        case LLDebugToolActionConvenientScreenshot: {
            title = LLLocalizedString(@"function.convenient.screenshot");
        }
            break;
        case LLDebugToolActionHierarchy: {
            title = LLLocalizedString(@"function.hierarchy");
        }
            break;
        case LLDebugToolActionMagnifier: {
            title = LLLocalizedString(@"function.magnifier");
        }
            break;
        case LLDebugToolActionRuler: {
            title = LLLocalizedString(@"function.ruler");
        }
            break;
        case LLDebugToolActionWidgetBorder: {
            title = LLLocalizedString(@"function.widget.border");
        }
            break;
        case LLDebugToolActionHtml: {
            title = LLLocalizedString(@"function.html");
        }
            break;
        case LLDebugToolActionLocation: {
            title = LLLocalizedString(@"function.location");
        }
            break;
        case LLDebugToolActionShortCut: {
            title = LLLocalizedString(@"function.short.cut");
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
        case LLDebugToolActionShortCut: {
            imageName = kShortCutImageName;
        }
            break;
    }
    return imageName;
}

@end
