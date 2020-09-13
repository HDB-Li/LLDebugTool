//
//  LLComponentCore.h
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

#import <Foundation/Foundation.h>

#import "LLAppInfoHelperDelegate.h"
#import "LLCrashHelperDelegate.h"
#import "LLEntryHelperDelegate.h"
#import "LLFeatureHelperDelegate.h"
#import "LLHierarchyHelperDelegate.h"
#import "LLHtmlHelperDelegate.h"
#import "LLLocationHelperDelegate.h"
#import "LLLogHelperDelegate.h"
#import "LLMagnifierHelperDelegate.h"
#import "LLNetworkHelperDelegate.h"
#import "LLResolutionHelperDelegate.h"
#import "LLRulerHelperDelegate.h"
#import "LLSandboxHelperDelegate.h"
#import "LLScreenshotHelperDelegate.h"
#import "LLSettingHelperDelegate.h"
#import "LLShortCutHelperDelegate.h"
#import "LLWidgetBorderHelperDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLComponentCore : NSObject

@property (nonatomic, strong, nullable, readonly) id<LLEntryHelperDelegate> entryHelper;

@property (nonatomic, strong, nullable, readonly) id<LLFeatureHelperDelegate> featureHelper;

@property (nonatomic, strong, nullable, readonly) id<LLSettingHelperDelegate> settingHelper;

@property (nonatomic, strong, nullable, readonly) id<LLNetworkHelperDelegate> networkHelper;

@property (nonatomic, strong, nullable, readonly) id<LLLogHelperDelegate> logHelper;

@property (nonatomic, strong, nullable, readonly) id<LLCrashHelperDelegate> crashHelper;

@property (nonatomic, strong, nullable, readonly) id<LLAppInfoHelperDelegate> appInfoHelper;

@property (nonatomic, strong, nullable, readonly) id<LLSandboxHelperDelegate> sandboxHelper;

@property (nonatomic, strong, nullable, readonly) id<LLScreenshotHelperDelegate> screenshotHelper;

@property (nonatomic, strong, nullable, readonly) id<LLHierarchyHelperDelegate> hierarchyHelper;

@property (nonatomic, strong, nullable, readonly) id<LLMagnifierHelperDelegate> magnifierHelper;

@property (nonatomic, strong, nullable, readonly) id<LLRulerHelperDelegate> rulerHelper;

@property (nonatomic, strong, nullable, readonly) id<LLWidgetBorderHelperDelegate> widgetBorderHelper;

@property (nonatomic, strong, nullable, readonly) id<LLHtmlHelperDelegate> htmlHelper;

@property (nonatomic, strong, nullable, readonly) id<LLLocationHelperDelegate> locationHelper;

@property (nonatomic, strong, nullable, readonly) id<LLShortCutHelperDelegate> shortCutHelper;

@property (nonatomic, strong, nullable, readonly) id<LLResolutionHelperDelegate> resolutionHelper;

@end

NS_ASSUME_NONNULL_END
