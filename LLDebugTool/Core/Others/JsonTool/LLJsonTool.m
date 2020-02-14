//
//  LLJsonTool.m
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

#import "LLJsonTool.h"

@implementation LLJsonTool

+ (NSString *)formatJsonString:(NSString *)aString {
    
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([aString length] == 0) {
        return aString;
    }
    
    NSMutableString *targetString = [[NSMutableString alloc] init];
    NSString *last = @"";
    NSString *current = @"";
    NSInteger indent = 0;
    
    for (NSInteger i = 0; i < [aString length]; i++) {
        last = current;
        current = [aString substringWithRange:NSMakeRange(i, 1)];
        if ([current isEqualToString:@"{"] || [current isEqualToString:@"["]) {
            [targetString appendString:current];
            [targetString appendString:@"\r\n"];
            indent++;
            [self addBlankStringWithString:targetString indent:indent];
        } else if ([current isEqualToString:@"}"] || [current isEqualToString:@"]"]) {
            [targetString appendString:@"\r\n"];
            indent--;
            [self addBlankStringWithString:targetString indent:indent];
            [targetString appendString:current];
        } else if ([current isEqualToString:@","]) {
            [targetString appendString:current];
            if (![last isEqual:@"\\"]) {
                [targetString appendString:@"\r\n"];
                [self addBlankStringWithString:targetString indent:indent];
            }
        } else {
            [targetString appendString:current];
        }
    }
    return [targetString copy];
}

+ (NSMutableString *)addBlankStringWithString:(NSMutableString *)mutString indent:(NSInteger)indent {
    if (indent < 0) {
        return mutString;
    }
    for (NSInteger i = 0; i < indent; i++) {
        [mutString appendFormat:@"\t"];
    }
    return mutString;
}

@end
