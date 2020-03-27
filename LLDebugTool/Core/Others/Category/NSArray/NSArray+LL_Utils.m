//
//  NSArray+LL_Utils.m
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

#import "NSArray+LL_Utils.h"

#import "NSMutableArray+LL_Utils.h"

@implementation NSArray (LL_Utils)

- (NSString *)LL_jsonString {
    NSMutableArray *newArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]) {
            [newArray addObject:object];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [newArray addObject:object];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [newArray LL_addObject:[object LL_jsonString]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [newArray LL_addObject:[object LL_jsonString]];
        } else if ([object isKindOfClass:[NSNull class]]) {
            [newArray addObject:@"<Null>"];
        } else {
            [newArray LL_addObject:[object description]];
        }
    }
    return [newArray LL_SafeJsonString];
}

#pragma mark - Primary
- (NSString *)LL_SafeJsonString {
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
