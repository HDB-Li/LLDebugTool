//
//  NSDictionary+LL_Utils.m
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

#import "NSDictionary+LL_Utils.h"

@implementation NSDictionary (LL_Utils)

- (NSString *)LL_jsonString {
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys) {
        if (![key isKindOfClass:[NSString class]]) {
            continue;
        }
        id value = self[key];
        if ([value isKindOfClass:[NSString class]]) {
            newDic[key] = value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            newDic[key] = value;
        } else if ([value isKindOfClass:[NSArray class]]) {
            newDic[key] = [value LL_jsonString];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            newDic[key] = [value LL_jsonString];
        } else if ([value isKindOfClass:[NSNull class]]) {
            newDic[key] = @"<Null>";
        } else {
            newDic[key] = [value description];
        }
    }

    return [newDic LL_safeJsonString];
}

- (NSDictionary *)LL_addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:self];
    [mut addEntriesFromDictionary:otherDictionary];
    return [mut copy];
}

- (NSString *)LL_displayString {
    if (self.allKeys.count == 0) {
        return nil;
    }
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSString *key in self) {
        [string appendFormat:@"%@ : %@\n", key, self[key]];
    }
    return [string copy];
}

- (id _Nullable)LL_objectForKey:(id)aKey targetClass:(Class)cls {
    id obj = self[aKey];
    if ([obj isKindOfClass:cls]) {
        return obj;
    }
    return nil;
}

#pragma mark - Primary
- (NSString *)LL_safeJsonString {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return jsonString;
    }
    return nil;
}

@end
