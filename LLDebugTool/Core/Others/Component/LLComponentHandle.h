//
//  LLComponentHandle.h
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

#import "LLComponentDelegate.h"
#import "LLDebugConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLComponentHandle : NSObject

/// Current action.
+ (LLDebugToolAction)currentAction;

/// Whether the action is available.
/// @param action Action.
+ (NSString *_Nullable)componentForAction:(LLDebugToolAction)action;

/// Title for action.
/// @param action Action.
+ (NSString *)titleFromAction:(LLDebugToolAction)action;

/// Execute action if availabled.
/// @param action Action.
/// @param data Extra data.
+ (BOOL)executeAction:(LLDebugToolAction)action data:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data;

/// Finish action if availabled.
/// @param action Action.
/// @param data Extra data.
+ (BOOL)finishAction:(LLDebugToolAction)action data:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data;

@end

NS_ASSUME_NONNULL_END
