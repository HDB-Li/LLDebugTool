//
//  LLCrashModel.h
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

#import "LLTableViewSelectableModel.h"

@class LLCrashSignalModel;

NS_ASSUME_NONNULL_BEGIN

/// Crash model.
@interface LLCrashModel : LLTableViewSelectableModel

/**
 * Crash Name
 */
@property (copy, nonatomic, readonly, nullable) NSString *name;

/**
 * Crash reason
 */
@property (copy, nonatomic, readonly, nullable) NSString *reason;

/**
 * Crash UserInfo
 */
@property (strong, nonatomic, readonly, nullable) NSDictionary<NSString *, id> *userInfo;

/**
 * Crash stack symbols
 */
@property (strong, nonatomic, readonly, nullable) NSArray<NSString *> *stackSymbols;

/**
 * Crash Date (yyyy-MM-dd HH:mm:ss)
 */
@property (copy, nonatomic, readonly, nullable) NSString *date;

/**
 * Thread description.
 */
@property (copy, nonatomic, readonly, nullable) NSString *thread;

/**
 * Custom User Identity
 */
@property (copy, nonatomic, readonly, nullable) NSString *userIdentity;

/**
 * App Infos
 */
@property (strong, nonatomic, readonly, nullable) NSString *appInfoDescription;

/**
 * App LaunchDate
 */
@property (copy, nonatomic, readonly) NSString *launchDate;

/**
 Model identity.
 */
@property (nonatomic, copy, readonly) NSString *identity;

/**
 * Init method
 */
- (instancetype _Nonnull)initWithName:(NSString *_Nullable)name reason:(NSString *_Nullable)reason userInfo:(NSDictionary<NSString *, id> *_Nullable)userInfo stackSymbols:(NSArray<NSString *> *_Nullable)stackSymbols date:(NSString *_Nullable)date thread:(NSString *_Nullable)thread userIdentity:(NSString *_Nullable)userIdentity appInfoDescription:(NSString *_Nullable)appInfoDescription launchDate:(NSString *)launchDate;

/**
 Update appInfo
 */
- (void)updateAppInfoDescription:(NSString *_Nullable)appInfoDescription;

@end

NS_ASSUME_NONNULL_END
