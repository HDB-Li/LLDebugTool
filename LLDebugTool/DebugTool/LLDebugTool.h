//
//  LLDebugTool.h
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
#import "LLConfig.h"

#ifndef LLSharedDebugTool
#define LLSharedDebugTool [LLDebugTool sharedTool]
#endif

@class LLWindow;

/**
 Control whether DebugTool is started.
 */
@interface LLDebugTool : NSObject

/**
 Suspension ball window.
 */
@property (nonatomic , strong , readonly) LLWindow *window;

/**
 Singleton to control debugTool.
 
 @return Singleton
 */
+ (instancetype)sharedTool;

/**
 Start working.
 */
- (void)startWorking;

/**
 Stop working.
 */
- (void)stopWorking;

/**
 Whether working or not.
 */
@property (nonatomic , assign , readonly) BOOL isWorking;

/**
 LLDebugTool's version.
 */
@property (nonatomic , copy , readonly) NSString *version;

/**
 Whether is Beta.
 */
@property (nonatomic , assign , readonly) BOOL isBetaVersion;

/**
 Automatic open debug view controller with index.
 */
- (void)showDebugViewControllerWithIndex:(NSInteger)index;

/**
 Print and save a log model with infos.
 
 @param file File name.
 @param function Function name.
 @param lineNo Line number.
 @param level Log level.
 @param onEvent Event,can filter by this.
 @param message Message.
 */
- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(int)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message, ... ;

@end
