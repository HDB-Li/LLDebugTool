//
//  LLBaseModel.m
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
#import <objc/runtime.h>

@implementation LLBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *names = [[self class] getPropertyNames];
    for (NSString *name in names) {
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        NSArray *names = [[self class] getPropertyNames];
        for (NSString *name in names) {
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] alloc] init];
    NSArray *names = [[self class] getPropertyNames];
    for (NSString *name in names) {
        id value = [self valueForKey:name];
        [obj setValue:value forKey:name];
    }
    return obj;
}

+ (NSArray *)getPropertyNames {
    // Property count
    unsigned int count;
    // Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // Get names
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [array addObject:name];
        }
    }
    free(properties);
    return array;
}

@end
