//
//  LLFeatureItemModel.m
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

#import "LLFeatureItemModel.h"

#import "LLComponentHelper.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLTool.h"

@implementation LLFeatureItemModel

- (instancetype)initWithAction:(LLDebugToolAction)action {
    if (self = [super init]) {
        _action = action;
        if ([[LLComponentHelper componentForAction:action] length] < 0) {
            return nil;
        }
        _imageName = [self imageNameFromAction:action];
        _title = [LLComponentHelper titleFromAction:action];
    }
    return self;
}

- (NSString *)imageNameFromAction:(LLDebugToolAction)action {
    NSDictionary *json = @{
        @(LLDebugToolActionEntry): @"",
        @(LLDebugToolActionFeature): @"",
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
