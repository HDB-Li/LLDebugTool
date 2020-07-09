//
//  LLComponentDelegate.h
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

NS_ASSUME_NONNULL_BEGIN

@class LLComponentWindow;

typedef NSString *LLComponentDelegateKey NS_TYPED_ENUM;

FOUNDATION_EXTERN LLComponentDelegateKey const LLComponentDelegateRootViewControllerKey;

FOUNDATION_EXTERN LLComponentDelegateKey const LLComponentDelegateRootViewControllerNeedNavigationKey;

FOUNDATION_EXTERN LLComponentDelegateKey const LLComponentDelegateRootViewControllerPropertiesKey;

/// Component delegate.
@protocol LLComponentDelegate <NSObject>

/// Component did load.
/// @param data Extra data.
+ (BOOL)componentDidLoad:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data;

/// Component did finish.
/// @param data Extra data.
+ (BOOL)componentDidFinish:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data;

/// Base window.
+ (LLComponentWindow *_Nullable)baseWindow;

@optional

/// Base view controller class.
+ (Class)baseViewController;

/// Whether is support.
+ (BOOL)isValid;

/// Check data is valid.
/// @param data Data.
+ (NSDictionary<LLComponentDelegateKey, id> *_Nullable)verificationData:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data;

@end

NS_ASSUME_NONNULL_END
