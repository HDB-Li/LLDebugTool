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

#import "LLBaseModel.h"

@interface LLCrashModel : LLBaseModel

/**
 * Crash Name
 */
@property (copy , nonatomic , readonly) NSString *name;

/**
 * Crash reason
 */
@property (copy , nonatomic , readonly) NSString *reason;

/**
 * Crash UserInfo
 */
@property (strong , nonatomic , readonly) NSDictionary *userInfo;

/**
 * Crash stack symbols
 */
@property (strong , nonatomic , readonly) NSArray <NSString *>*stackSymbols;

/**
 * Crash Date (yyyy-MM-dd HH:mm:ss)
 */
@property (copy , nonatomic , readonly) NSString *date;

/**
 * Custom User Identity
 */
@property (copy , nonatomic , readonly) NSString *userIdentity;

/**
 * App Infos
 */
@property (strong , nonatomic , readonly) NSArray *appInfos;

/**
 * App LaunchDate
 */
@property (copy , nonatomic , readonly) NSString *launchDate;

/**
 * Specail initial method
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 * Foolish initial method
 */
- (instancetype)initWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo stackSymbols:(NSArray *)stackSymbols date:(NSString *)date userIdentity:(NSString *)userIdentity appInfos:(NSArray *)appInfos launchDate:(NSString *)launchDate;

@end
