//
//  LLFormatterTool.m
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

#import "LLFormatterTool.h"

#import "LLDebugConfig.h"

static LLFormatterTool *_instance = nil;

@interface LLFormatterTool ()

@property (nonatomic, strong) NSDictionary *formatters;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@property (nonatomic, strong) NSNumberFormatter *locationFormatter;

@end

@implementation LLFormatterTool

#pragma mark - Public
+ (NSString *)stringFromDate:(NSDate *)date style:(FormatterToolDateStyle)style {
    return [[self shared] stringFromDate:date style:style];
}

+ (NSDate *)dateFromString:(NSString *)string style:(FormatterToolDateStyle)style {
    return [[self shared] dateFromString:string style:style];
}

+ (NSString *)formatNumber:(NSNumber *)number {
    return [[self shared] formatNumber:number];
}

+ (NSString *)formatLocation:(NSNumber *)number {
    return [[self shared] formatLocation:number];
}

#pragma mark - Primary
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLFormatterTool alloc] init];
    });
    return _instance;
}

- (NSString *)stringFromDate:(NSDate *)date style:(FormatterToolDateStyle)style {
    if (!date) {
        return nil;
    }
    NSDateFormatter *formatter = self.formatters[@(style)];
    if (formatter) {
        return [formatter stringFromDate:date];
    }
    return nil;
}

- (NSDate *)dateFromString:(NSString *)string style:(FormatterToolDateStyle)style {
    NSDateFormatter *formatter = self.formatters[@(style)];
    if (formatter) {
        return [formatter dateFromString:string];
    }
    return nil;
}

- (NSString *)formatNumber:(NSNumber *)number {
    return [self.numberFormatter stringFromNumber:number];
}

- (NSString *)formatLocation:(NSNumber *)number {
    return [self.locationFormatter stringFromNumber:number];
}

#pragma mark - Getters and setters
- (NSDictionary *)formatters {
    if (!_formatters) {
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = [LLDebugConfig shared].dateFormatter;

        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        dateFormatter2.dateFormat = @"yyyy-MM-dd";

        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
        dateFormatter3.dateFormat = @"yyyy-MM-dd HH:mm:ss";

        _formatters = @{ @(FormatterToolDateStyle1): dateFormatter1,
                         @(FormatterToolDateStyle2): dateFormatter2,
                         @(FormatterToolDateStyle3): dateFormatter3 };
    }
    return _formatters;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter.maximumFractionDigits = 2;
        _numberFormatter.usesGroupingSeparator = NO;
    }
    return _numberFormatter;
}

- (NSNumberFormatter *)locationFormatter {
    if (!_locationFormatter) {
        _locationFormatter = [[NSNumberFormatter alloc] init];
        _locationFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _locationFormatter.maximumFractionDigits = 6;
        _locationFormatter.usesGroupingSeparator = NO;
    }
    return _locationFormatter;
}

@end
