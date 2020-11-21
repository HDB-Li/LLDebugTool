//
//  LLDebug.h
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

#ifndef LLDebug_h
#define LLDebug_h

// App Info
#if __has_include("LLAppInfo.h")
#import "LLAppInfo.h"
#elif __has_include("<LLAppInfo.h>")
#import <LLAppInfo.h>
#elif __has_include("<LLAppInfo/LLAppInfo.h>")
#import <LLAppInfo/LLAppInfo.h>
#endif

// Core
#if __has_include("LLCore.h")
#import "LLCore.h"
#elif __has_include("<LLCore.h>")
#import <LLCore.h>
#elif __has_include("<LLCore/LLCore.h>")
#import <LLCore/LLCore.h>
#endif

// Crash
#if __has_include("LLCrash.h")
#import "LLCrash.h"
#elif __has_include("<LLCrash.h>")
#import <LLCrash.h>
#elif __has_include("<LLCrash/LLCrash.h>")
#import <LLCrash/LLCrash.h>
#endif

// Entry
#if __has_include("LLEntry.h")
#import "LLEntry.h"
#elif __has_include("<LLEntry.h>")
#import <LLEntry.h>
#elif __has_include("<LLEntry/LLEntry.h>")
#import <LLEntry/LLEntry.h>
#endif

// Feature
#if __has_include("LLFeature.h")
#import "LLFeature.h"
#elif __has_include("<LLFeature.h>")
#import <LLFeature.h>
#elif __has_include("<LLFeature/LLFeature.h>")
#import <LLFeature/LLFeature.h>
#endif

// Hierarchy
#if __has_include("LLHierarchy.h")
#import "LLHierarchy.h"
#elif __has_include("<LLHierarchy.h>")
#import <LLHierarchy.h>
#elif __has_include("<LLHierarchy/LLHierarchy.h>")
#import <LLHierarchy/LLHierarchy.h>
#endif

// Html
#if __has_include("LLHtml.h")
#import "LLHtml.h"
#elif __has_include("<LLHtml.h>")
#import <LLHtml.h>
#elif __has_include("<LLHtml/LLHtml.h>")
#import <LLHtml/LLHtml.h>
#endif

// Location
#if __has_include("LLLocation.h")
#import "LLLocation.h"
#elif __has_include("<LLLocation.h>")
#import <LLLocation.h>
#elif __has_include("<LLLocation/LLLocation.h>")
#import <LLLocation/LLLocation.h>
#endif

// Log
#if __has_include("LLLog.h")
#import "LLLog.h"
#elif __has_include("<LLLog.h>")
#import <LLLog.h>
#elif __has_include("<LLLog/LLLog.h>")
#import <LLLog/LLLog.h>
#endif

// Magnifier
#if __has_include("LLMagnifier.h")
#import "LLMagnifier.h"
#elif __has_include("<LLMagnifier.h>")
#import <LLMagnifier.h>
#elif __has_include("<LLMagnifier/LLMagnifier.h>")
#import <LLMagnifier/LLMagnifier.h>
#endif

// Network
#if __has_include("LLNetwork.h")
#import "LLNetwork.h"
#elif __has_include("<LLNetwork.h>")
#import <LLNetwork.h>
#elif __has_include("<LLNetwork/LLNetwork.h>")
#import <LLNetwork/LLNetwork.h>
#endif

// Ruler
#if __has_include("LLRuler.h")
#import "LLRuler.h"
#elif __has_include("<LLRuler.h>")
#import <LLRuler.h>
#elif __has_include("<LLRuler/LLRuler.h>")
#import <LLRuler/LLRuler.h>
#endif

// Sandbox
#if __has_include("LLSandbox.h")
#import "LLSandbox.h"
#elif __has_include("<LLSandbox.h>")
#import <LLSandbox.h>
#elif __has_include("<LLSandbox/LLSandbox.h>")
#import <LLSandbox/LLSandbox.h>
#endif

// Screenshot
#if __has_include("LLScreenshot.h")
#import "LLScreenshot.h"
#elif __has_include("<LLScreenshot.h>")
#import <LLScreenshot.h>
#elif __has_include("<LLScreenshot/LLScreenshot.h>")
#import <LLScreenshot/LLScreenshot.h>
#endif

// Setting
#if __has_include("LLSetting.h")
#import "LLSetting.h"
#elif __has_include("<LLSetting.h>")
#import <LLSetting.h>
#elif __has_include("<LLSetting/LLSetting.h>")
#import <LLSetting/LLSetting.h>
#endif

// ShortCut
#if __has_include("LLShortCut.h")
#import "LLShortCut.h"
#elif __has_include("<LLShortCut.h>")
#import <LLShortCut.h>
#elif __has_include("<LLShortCut/LLShortCut.h>")
#import <LLShortCut/LLShortCut.h>
#endif

// Storage
#if __has_include("LLStorage.h")
#import "LLStorage.h"
#elif __has_include("<LLStorage.h>")
#import <LLStorage.h>
#elif __has_include("<LLStorage/LLStorage.h>")
#import <LLStorage/LLStorage.h>
#endif

// WidgetBorder
#if __has_include("LLWidgetBorder.h")
#import "LLWidgetBorder.h"
#elif __has_include("<LLWidgetBorder.h>")
#import <LLWidgetBorder.h>
#elif __has_include("<LLWidgetBorder/LLWidgetBorder.h>")
#import <LLWidgetBorder/LLWidgetBorder.h>
#endif

#endif /* LLDebug_h */
