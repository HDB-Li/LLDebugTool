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
    id<LLEntryHelperDelegate> _entryHelper = [self helperWithName:@"LLEntryHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_ENTRY
    if (!_entryHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _entryHelper;
}

- (id<LLFeatureHelperDelegate>)featureHelper {
    id<LLFeatureHelperDelegate> _featureHelper = [self helperWithName:@"LLFeatureHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_FEATURE
    if (!_featureHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _featureHelper;
}

- (id<LLSettingHelperDelegate>)settingHelper {
    id<LLSettingHelperDelegate> _settingHelper = [self helperWithName:@"LLSettingHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_SETTING
    if (!_settingHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _settingHelper;
}

- (id<LLNetworkHelperDelegate>)networkHelper {
    id<LLNetworkHelperDelegate> _networkHelper = [self helperWithName:@"LLNetworkHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_NETWORK
    if (!_networkHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _networkHelper;
}

- (id<LLLogHelperDelegate>)logHelper {
    id<LLLogHelperDelegate> _logHelper = nil;
#ifdef LLDEBUGTOOL_LOG
    _logHelper = [self helperWithName:@"LLLogHelper" selector:_cmd];
    if (!_logHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#else
    _logHelper = [self helperWithName:@"LLSimpleLogHelper" selector:_cmd];
#endif
    return _logHelper;
}

- (id<LLCrashHelperDelegate>)crashHelper {
    id<LLCrashHelperDelegate> _crashHelper = [self helperWithName:@"LLCrashHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_CRASH
    if (!_crashHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _crashHelper;
}

- (id<LLAppInfoHelperDelegate>)appInfoHelper {
    id<LLAppInfoHelperDelegate> _appInfoHelper = [self helperWithName:@"LLAppInfoHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_APP_INFO
    if (!_appInfoHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _appInfoHelper;
}

- (id<LLSandboxHelperDelegate>)sandboxHelper {
    id<LLSandboxHelperDelegate> _sandboxHelper = [self helperWithName:@"LLSandboxHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_SANDBOX
    if (!_sandboxHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _sandboxHelper;
}

- (id<LLScreenshotHelperDelegate>)screenshotHelper {
    id<LLScreenshotHelperDelegate> _screenshotHelper = [self helperWithName:@"LLScreenshotHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_SCREENSHOT
    if (!_screenshotHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _screenshotHelper;
}

- (id<LLHierarchyHelperDelegate>)hierarchyHelper {
    id<LLHierarchyHelperDelegate> _hierarchyHelper = [self helperWithName:@"LLHierarchyHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_HIERARCHY
    if (!_hierarchyHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _hierarchyHelper;
}

- (id<LLMagnifierHelperDelegate>)magnifierHelper {
    id<LLMagnifierHelperDelegate> _magnifierHelper = [self helperWithName:@"LLMagnifierHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_MAGNIFIER
    if (!_magnifierHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _magnifierHelper;
}

- (id<LLRulerHelperDelegate>)rulerHelper {
    id<LLRulerHelperDelegate> _rulerHelper = [self helperWithName:@"LLRulerHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_RULER
    if (!_rulerHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _rulerHelper;
}

- (id<LLWidgetBorderHelperDelegate>)widgetBorderHelper {
    id<LLWidgetBorderHelperDelegate> _widgetBorderHelper = [self helperWithName:@"LLWidgetBorderHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_WIDGET_BORDER
    if (!_widgetBorderHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _widgetBorderHelper;
}

- (id<LLHtmlHelperDelegate>)htmlHelper {
    id<LLHtmlHelperDelegate> _htmlHelper = [self helperWithName:@"LLHtmlHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_WIDGET_BORDER
    if (!_htmlHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _htmlHelper;
}

- (id<LLLocationHelperDelegate>)locationHelper {
    id<LLLocationHelperDelegate> _locationHelper = [self helperWithName:@"LLLocationHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_LOCATION
    if (!_locationHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _locationHelper;
}

- (id<LLShortCutHelperDelegate>)shortCutHelper {
    id<LLShortCutHelperDelegate> _shortCutHelper = [self helperWithName:@"LLShortCutHelper" selector:_cmd];
#ifdef LLDEBUGTOOL_SHORT_CUT
    if (!_shortCutHelper) {
        NSString *message = [NSString stringWithFormat:@"%@ is not exist.", NSStringFromSelector(_cmd)];
        NSAssert(NO, message);
    }
#endif
    return _shortCutHelper;
}

- (id<LLResolutionHelperDelegate>)resolutionHelper {
    return (id<LLResolutionHelperDelegate>)[self helperWithName:@"LLResolutionHelper" selector:_cmd];
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
