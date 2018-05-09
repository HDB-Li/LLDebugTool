//
//  LLCrashModel.m
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

#import "LLCrashModel.h"
#import "NSString+LL_Utils.h"
#import "LLAppHelper.h"

@interface LLCrashModel ()

@end

@implementation LLCrashModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _name = dictionary[@"name"];
        _reason = dictionary[@"reason"];
        _userInfo = dictionary[@"userInfo"];
        _stackSymbols = dictionary[@"stackSymbols"];
        _date = dictionary[@"date"];
        _userIdentity = dictionary[@"userIdentity"];
        _appInfos = dictionary[@"appInfos"];
        _launchDate = [[LLAppHelper sharedHelper] launchDate];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo stackSymbols:(NSArray *)stackSymbols date:(NSString *)date userIdentity:(NSString *)userIdentity appInfos:(NSArray *)appInfos launchDate:(NSString *)launchDate {
    if (self = [super init]) {
        _name = [name length] ? name : nil;
        _reason = [reason length] ? reason : nil;
        _userInfo = userInfo.allKeys.count ? userInfo : nil;
        _stackSymbols = stackSymbols.count ? stackSymbols : nil;
        _date = [date length] ? date : nil;
        _userIdentity = [userIdentity length] ? userIdentity : nil;
        _appInfos = [appInfos count] ? appInfos : nil;
        _launchDate = launchDate;
    }
    return self;
}

@end
