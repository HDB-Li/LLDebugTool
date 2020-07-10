//
//  LLComponentHelper.m
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

#import "LLComponentHelper.h"

#import "LLDebugTool.h"
#import "LLTool.h"

static LLDebugToolAction _currentAction;

@implementation LLComponentHelper

+ (LLDebugToolAction)currentAction {
    return _currentAction;
}

+ (NSString *)componentForAction:(LLDebugToolAction)action {
    NSDictionary *json = @{
        @(LLDebugToolActionEntry): @"LLEntryComponent",
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
        Class cls = NSClassFromString(component);
        if ([cls conformsToProtocol:@protocol(LLComponentDelegate)]) {
            return component;
        }
    }
    return nil;
}

+ (BOOL)executeAction:(LLDebugToolAction)action data:(NSDictionary<LLComponentDelegateKey, id> *)data {
    NSString *component = [self componentForAction:action];
    if (!component) {
        [LLTool log:[NSString stringWithFormat:@"executeAction unknown : %@", @(action)]];
        return NO;
    }
    Class cls = NSClassFromString(component);
    if ([cls respondsToSelector:@selector(componentDidLoad:)]) {
        if ([cls componentDidLoad:data]) {
            _currentAction = action;
            return YES;
        }
    }
    return NO;
}

+ (BOOL)finishAction:(LLDebugToolAction)action data:(NSDictionary<LLComponentDelegateKey, id> *)data {
    NSString *component = [self componentForAction:action];
    if (!component) {
        [LLTool log:[NSString stringWithFormat:@"finishAction unknown : %@", @(action)]];
        return NO;
    }
    Class cls = NSClassFromString(component);
    if ([cls respondsToSelector:@selector(componentDidFinish:)]) {
        return [cls componentDidFinish:data];
    }
    return NO;
}

@end
