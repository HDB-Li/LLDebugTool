//
//  LLDebugToolMacros.h
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

#ifndef LLDebugToolMacros_h
#define LLDebugToolMacros_h

#if __has_include("LLDebugTool.h") || __has_include("<LLDebugTool.h>") || __has_include("<LLDebugTool / LLDebugTool.h>")

#if __has_include("LLDebugTool.h")
#import "LLDebugTool.h"
#elif __has_include("<LLDebugTool.h>")
#import <LLDebugTool.h>
#else
#import <LLDebugTool/LLDebugTool.h>
#endif

#define LLog(fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:nil message:(fmt, ##__VA_ARGS__)]
#define LLog_Event(event, fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:event message:(fmt, ##__VA_ARGS__)]
#define LLog_Alert(fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:nil message:(fmt, ##__VA_ARGS__)]
#define LLog_Alert_Event(event, fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:event message:(fmt, ##__VA_ARGS__)]
#define LLog_Warning(fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:nil message:(fmt, ##__VA_ARGS__)]
#define LLog_Warning_Event(event, fmt, ...) [[LLDebugTool sharedTool] logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:event message:(fmt, ##__VA_ARGS__)]
#define LLog_Error(fmt, ...) [[LLDebugTool sharedTool] errorLogInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:nil message:(fmt, ##__VA_ARGS__)]
#define LLog_Error_Event(event, fmt, ...) [[LLDebugTool sharedTool] errorLogInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ onEvent:event message:(fmt, ##__VA_ARGS__)]

#define LLDT [LLDebugTool sharedTool]
#define LLDT_CC [LLDT componentCore]
#define LLDT_CC_Entry [LLDT_CC entryHelper]
#define LLDT_CC_Setting [LLDT_CC settingHelper]
#define LLDT_CC_Feature [LLDT_CC featureHelper]
#define LLDT_CC_Network [LLDT_CC networkHelper]
#define LLDT_CC_Log [LLDT_CC logHelper]
#define LLDT_CC_Crash [LLDT_CC crashHelper]
#define LLDT_CC_AppInfo [LLDT_CC appInfoHelper]
#define LLDT_CC_Sandbox [LLDT_CC sandboxHelper]
#define LLDT_CC_Screenshot [LLDT_CC screenshotHelper]
#define LLDT_CC_Hierarchy [LLDT_CC hierarchyHelper]
#define LLDT_CC_Magnifier [LLDT_CC magnifierHelper]
#define LLDT_CC_Ruler [LLDT_CC rulerHelper]
#define LLDT_CC_WidgetBorder [LLDT_CC widgetBorderHelper]
#define LLDT_CC_Html [LLDT_CC htmlHelper]
#define LLDT_CC_Location [LLDT_CC locationHelper]
#define LLDT_CC_ShortCut [LLDT_CC shortCutHelper]

#else

#define LLog(fmt, ...) NSLog(fmt)
#define LLog_Event(event, fmt, ...) NSLog(fmt)
#define LLog_Alert(fmt, ...) NSLog(fmt)
#define LLog_Alert_Event(event, fmt, ...) NSLog(fmt)
#define LLog_Warning(fmt, ...) NSLog(fmt)
#define LLog_Warning_Event(event, fmt, ...) NSLog(fmt)
#define LLog_Error(fmt, ...) NSLog(fmt)
#define LLog_Error_Event(event, fmt, ...) NSLog(fmt)

#endif
/*
 // If you only use LLDebugTool in Debug environment, you can copy the following part to your PCH file to resolve most Release environment errors.
 
 #ifndef DEBUG
 #define LLog(fmt, ...) NSLog(fmt)
 #define LLog_Event(event, fmt, ...) NSLog(fmt)
 #define LLog_Alert(fmt, ...) NSLog(fmt)
 #define LLog_Alert_Event(event, fmt, ...) NSLog(fmt)
 #define LLog_Warning(fmt, ...) NSLog(fmt)
 #define LLog_Warning_Event(event, fmt, ...) NSLog(fmt)
 #define LLog_Error(fmt, ...) NSLog(fmt)
 #define LLog_Error_Event(event, fmt, ...) NSLog(fmt)
 #endif
 
 */

#endif /* LLDebugToolMacros_h */
