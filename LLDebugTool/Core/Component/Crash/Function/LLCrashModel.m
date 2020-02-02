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

#import "LLTool.h"

#import "NSDictionary+LL_Utils.h"
#import "NSObject+LL_Utils.h"
#import "NSString+LL_Utils.h"
#import "NSArray+LL_Utils.h"

@interface LLCrashModel ()

@property (strong, nonatomic) NSMutableArray <LLCrashSignalModel *>*signals;

@end

@implementation LLCrashModel

- (instancetype _Nonnull)initWithName:(NSString *_Nullable)name reason:(NSString *_Nullable)reason userInfo:(NSDictionary <NSString *, id>*_Nullable)userInfo stackSymbols:(NSArray <NSString *>*_Nullable)stackSymbols date:(NSString *_Nullable)date thread:(NSString *_Nullable)thread userIdentity:(NSString *_Nullable)userIdentity appInfos:(NSArray <NSArray <NSDictionary <NSString *,NSString *>*>*>*_Nullable)appInfos launchDate:(NSString *)launchDate {
    if (self = [super init]) {
        _name = [name copy];
        _reason = [reason copy];
        _userInfo = [userInfo copy];
        _stackSymbols = [stackSymbols copy];
        _date = [date copy];
        _thread = [thread copy];
        _userIdentity = [userIdentity copy];
        _appInfos = [appInfos copy];
        _launchDate = [launchDate copy];
        _signals = [[NSMutableArray alloc] init];
        _identity = [launchDate stringByAppendingString:[LLTool absolutelyIdentity]];
    }
    return self;
}

- (void)updateAppInfos:(NSArray <NSArray <NSDictionary <NSString *,NSString *>*>*>*)appInfos {
    _appInfos = [appInfos copy];
}

- (NSString *)storageIdentity {
    return self.identity;
}

- (BOOL)operationOnMainThread {
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[LLCrashModel] \n name:%@,\n reason:%@,\n userInfo:%@,\n stackSymbols:%@,\n date:%@,\n userIdentity:%@,\n appInfos:%@,\n launchDate:%@",self.name,self.reason,self.userInfo.LL_jsonString,self.stackSymbols.LL_jsonString,self.date,self.userIdentity,self.appInfos.LL_jsonString,self.launchDate];
}

@end
