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
#import "LLTool.h"

@implementation LLFunctionItemModel

- (instancetype)initWithAction:(LLDebugToolAction)action {
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

- (LLComponent *)componentFromAction:(LLDebugToolAction)action {
    NSDictionary *json = @{
        @(LLDebugToolActionFunction): @"LLFunctionComponent",
        @(LLDebugToolActionSetting): @"LLSettingComponent",
        @(LLDebugToolActionNetwork): @"LLNetworkComponent",
        @(LLDebugToolActionLog): @"LLLogComponent",
        @(LLDebugToolActionCrash): @"LLCrashComponent",
        @(LLDebugToolActionAppInfo): @"LLAppInfoComponent",
        @(LLDebugToolActionSandbox): @"LLSandboxComponent",
        @(LLDebugToolActionScreenshot): @"LLScreenshotComponent",
        @(LLDebugToolActionConvenientScreenshot): @"LLConvenientScreenshotComponent",
        @(LLDebugToolActionHierarchy): @"LLHierarchyComponent",
        @(LLDebugToolActionMagnifier): @"LLMagnifierComponent",
        @(LLDebugToolActionRuler): @"LLRulerComponent",
        @(LLDebugToolActionWidgetBorder): @"LLWidgetBorderComponent",
        @(LLDebugToolActionHtml): @"LLHtmlComponent",
        @(LLDebugToolActionLocation): @"LLLocationComponent",
        @(LLDebugToolActionShortCut): @"LLShortCutComponent",
        @(LLDebugToolActionResolution): @"LLResolutionComponent"
    };
    NSString *component = json[@(action)];
    if (component) {
        return [[NSClassFromString(component) alloc] init];
    }
    [LLTool log:[NSString stringWithFormat:@"componentFromAction unknown : %@", @(action)]];
    return nil;
}

- (NSString *)titleFromAction:(LLDebugToolAction)action {
    NSDictionary *json = @{
        @(LLDebugToolActionFunction): LLLocalizedString(@"function.function"),
        @(LLDebugToolActionSetting): LLLocalizedString(@"function.setting"),
        @(LLDebugToolActionNetwork): LLLocalizedString(@"function.net"),
        @(LLDebugToolActionLog): LLLocalizedString(@"function.log"),
        @(LLDebugToolActionCrash): LLLocalizedString(@"function.crash"),
        @(LLDebugToolActionAppInfo): LLLocalizedString(@"function.app.info"),
        @(LLDebugToolActionSandbox): LLLocalizedString(@"function.sandbox"),
        @(LLDebugToolActionScreenshot): LLLocalizedString(@"function.screenshot"),
        @(LLDebugToolActionConvenientScreenshot): LLLocalizedString(@"function.convenient.screenshot"),
        @(LLDebugToolActionHierarchy): LLLocalizedString(@"function.hierarchy"),
        @(LLDebugToolActionMagnifier): LLLocalizedString(@"function.magnifier"),
        @(LLDebugToolActionRuler): LLLocalizedString(@"function.ruler"),
        @(LLDebugToolActionWidgetBorder): LLLocalizedString(@"function.widget.border"),
        @(LLDebugToolActionHtml): LLLocalizedString(@"function.html"),
        @(LLDebugToolActionLocation): LLLocalizedString(@"function.location"),
        @(LLDebugToolActionShortCut): LLLocalizedString(@"function.short.cut"),
        @(LLDebugToolActionResolution): LLLocalizedString(@"function.resolution")
    };
    NSString *title = json[@(action)];
    if (!title) {
        title = @"";
        [LLTool log:[NSString stringWithFormat:@"titleFromAction unknown : %@", @(action)]];
    }
    return title;
}

- (NSString *)imageNameFromAction:(LLDebugToolAction)action {
    NSDictionary *json = @{
        @(LLDebugToolActionFunction): @"",
        @(LLDebugToolActionSetting): @"",
        @(LLDebugToolActionNetwork): kNetworkImageName,
        @(LLDebugToolActionLog): kLogImageName,
        @(LLDebugToolActionCrash): kCrashImageName,
        @(LLDebugToolActionAppInfo): kAppImageName,
        @(LLDebugToolActionSandbox): kSandboxImageName,
        @(LLDebugToolActionScreenshot): kScreenshotImageName,
        @(LLDebugToolActionConvenientScreenshot): kScreenshotImageName,
        @(LLDebugToolActionHierarchy): kHierarchyImageName,
        @(LLDebugToolActionMagnifier): kMagnifierImageName,
        @(LLDebugToolActionRuler): kRulerImageName,
        @(LLDebugToolActionWidgetBorder): kWidgetBorderImageName,
        @(LLDebugToolActionHtml): kHtml5ImageName,
        @(LLDebugToolActionLocation): kLocationImageName,
        @(LLDebugToolActionShortCut): kShortCutImageName,
        @(LLDebugToolActionResolution): kResolutionImageName
    };
    NSString *imageName = json[@(action)];
    if (!imageName) {
        imageName = @"";
        [LLTool log:[NSString stringWithFormat:@"imageNameFromAction unknown : %@", @(action)]];
    }
    return imageName;
}

@end
