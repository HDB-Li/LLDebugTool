//
//  NSUserDefaults+LL_Utils.h
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

/// NSUserDefaults utils.
@interface NSUserDefaults (LL_Utils)

/// Get string for key.
/// @param aKey Key.
+ (NSString *_Nullable)LL_stringForKey:(NSString *)aKey;

/// Set string for key.
/// @param string String
/// @param aKey Key.
+ (void)LL_setString:(NSString *)string forKey:(NSString *)aKey;

/// Get integer for key.
/// @param aKey Key
+ (NSInteger)LL_integerForKey:(NSString *)aKey;

/// Set integer for key.
/// @param value Integer
/// @param aKey Key.
+ (void)LL_setInteger:(NSInteger)value forKey:(NSString *)aKey;

/// Get number for key.
/// @param aKey Key.
+ (NSNumber *)LL_numberForKey:(NSString *)aKey;

/// Set number for key.
/// @param num Number
/// @param aKey Key.
+ (void)LL_setNumber:(NSNumber *)num forKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
