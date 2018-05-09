//
//  LLTool.m
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

#import "LLTool.h"
#import "LLConfig.h"

static LLTool *_instance = nil;

@interface LLTool ()

@property (nonatomic , strong) NSDateFormatter *dateFormatter;

@property (nonatomic , strong) NSDateFormatter *dayDateFormatter;

@property (nonatomic , strong) NSDateFormatter *staticDateFormatter;

@end

@implementation LLTool
{
    unsigned long long _absolutelyIdentity;
}

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLTool alloc] init];
    });
    return _instance;
}

- (NSString *)absolutelyIdentity {
    @synchronized (self) {
        _absolutelyIdentity++;
        return [NSString stringWithFormat:@"%lld",_absolutelyIdentity];
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string {
    return [self.dateFormatter dateFromString:string];
}

- (NSString *)dayStringFromDate:(NSDate *)date {
    return [self.dayDateFormatter stringFromDate:date];
}

- (NSDate *)staticDateFromString:(NSString *)string {
    return [self.staticDateFormatter dateFromString:string];
}

+ (UIView *)lineView:(CGRect)frame superView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor lightGrayColor];
    if (LLCONFIG_CUSTOM_COLOR) {
        view.backgroundColor = LLCONFIG_TEXT_COLOR;
    }
    if (superView) {
        [superView addSubview:view];
    }
    return view;
}

#pragma mark - Lazy load
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = [LLConfig sharedConfig].dateFormatter;
    }
    return _dateFormatter;
}

- (NSDateFormatter *)dayDateFormatter {
    if (!_dayDateFormatter) {
        _dayDateFormatter = [[NSDateFormatter alloc] init];
        _dayDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dayDateFormatter;
}

- (NSDateFormatter *)staticDateFormatter {
    if (!_staticDateFormatter) {
        _staticDateFormatter = [[NSDateFormatter alloc] init];
        _staticDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _staticDateFormatter;
}

@end
