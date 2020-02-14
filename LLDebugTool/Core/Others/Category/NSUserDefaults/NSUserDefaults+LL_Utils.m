//
//  NSUserDefaults+LL_Utils.m
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

#import "NSUserDefaults+LL_Utils.h"

@implementation NSUserDefaults (LL_Utils)

+ (NSString *_Nullable)LL_stringForKey:(NSString *)aKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self getKey:aKey]];
}

+ (void)LL_setString:(NSString *)string forKey:(NSString *)aKey {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:[self getKey:aKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)LL_integerForKey:(NSString *)aKey {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[self getKey:aKey]];
}

+ (void)LL_setInteger:(NSInteger)value forKey:(NSString *)aKey {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:[self getKey:aKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber *)LL_numberForKey:(NSString *)aKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self getKey:aKey]];
}

+ (void)LL_setNumber:(NSNumber *)num forKey:(NSString *)aKey {
    [[NSUserDefaults standardUserDefaults] setObject:num forKey:[self getKey:aKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Primary
+ (NSString *)getKey:(NSString *)aKey {
    return [NSString stringWithFormat:@"LLDebugTool-%@",aKey];
}

@end
