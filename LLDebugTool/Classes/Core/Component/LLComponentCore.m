//
//  LLComponentCore.m
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

#import "LLComponentCore.h"

#import <objc/runtime.h>

@implementation LLComponentCore

- (id<LLEntryHelperDelegate>)entryHelper {
    return [self helperWithName:@"LLEntryHelper" selector:_cmd];
}

- (id<LLFeatureHelperDelegate>)featureHelper {
    return [self helperWithName:@"LLFeatureHelper" selector:_cmd];
}

- (id<LLSettingHelperDelegate>)settingHelper {
    return [self helperWithName:@"LLSettingHelper" selector:_cmd];
}

- (id<LLNetworkHelperDelegate>)networkHelper {
    return [self helperWithName:@"LLNetworkHelper" selector:_cmd];
}

- (id<LLLogHelperDelegate>)logHelper {
    return [self helperWithName:@"LLLogHelper" selector:_cmd];
}

- (id<LLCrashHelperDelegate>)crashHelper {
    return [self helperWithName:@"LLCrashHelper" selector:_cmd];
}

- (id<LLAppInfoHelperDelegate>)appInfoHelper {
    return [self helperWithName:@"LLAppInfoHelper" selector:_cmd];
}

- (id<LLSandboxHelperDelegate>)sandboxHelper {
    return [self helperWithName:@"LLSandboxHelper" selector:_cmd];
}

- (id<LLScreenshotHelperDelegate>)screenshotHelper {
    return [self helperWithName:@"LLScreenshotHelper" selector:_cmd];
}

- (id<LLHierarchyHelperDelegate>)hierarchyHelper {
    return [self helperWithName:@"LLHierarchyHelper" selector:_cmd];
}

- (id<LLMagnifierHelperDelegate>)magnifierHelper {
    return [self helperWithName:@"LLMagnifierHelper" selector:_cmd];
}

- (id<LLRulerHelperDelegate>)rulerHelper {
    return [self helperWithName:@"LLRulerHelper" selector:_cmd];
}

- (id<LLWidgetBorderHelperDelegate>)widgetBorderHelper {
    return [self helperWithName:@"LLWidgetBorderHelper" selector:_cmd];
}

- (id<LLHtmlHelperDelegate>)htmlHelper {
    return [self helperWithName:@"LLHtmlHelper" selector:_cmd];
}

- (id<LLLocationHelperDelegate>)locationHelper {
    return [self helperWithName:@"LLLocationHelper" selector:_cmd];
}

- (id<LLShortCutHelperDelegate>)shortCutHelper {
    return [self helperWithName:@"LLShortCutHelper" selector:_cmd];
}

#pragma mark - Primary
- (id)helperWithName:(NSString *)name selector:(SEL)aSelector {
    if (!name) {
        return nil;
    }
    Class cls = NSClassFromString(name);
    if (!cls) {
        return nil;
    }
    id _helper = objc_getAssociatedObject(self, aSelector);
    if (!_helper) {
        _helper = [[cls alloc] init];
        objc_setAssociatedObject(self, aSelector, _helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _helper;
}

@end
