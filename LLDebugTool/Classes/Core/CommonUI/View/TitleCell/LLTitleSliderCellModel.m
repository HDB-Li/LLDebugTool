//
//  LLTitleSliderCellModel.m
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

#import "LLTitleSliderCellModel.h"

#import "LLTitleSliderCell.h"

@implementation LLTitleSliderCellModel

#pragma mark - Public
+ (instancetype)modelWithTitle:(NSString *)title value:(CGFloat)value minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    return [[self alloc] initWithTitle:title value:value minValue:minValue maxValue:maxValue];
}

#pragma mark - Primary
- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    if (self = [super init]) {
        self.title = title;
        self.value = value;
        self.minValue = minValue;
        self.maxValue = maxValue;
        self.cellClass = NSStringFromClass(LLTitleSliderCell.class);
    }
    return self;
}

@end
