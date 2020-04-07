//
//  LLTitleSliderCellModel.h
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

#import "LLTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLTitleSliderCellModel : LLTitleCellModel

/// Current value.
@property (nonatomic, assign) CGFloat value;

/// Min value.
@property (nonatomic, assign) CGFloat minValue;

/// Max value.
@property (nonatomic, assign) CGFloat maxValue;

/// Initial method.
/// @param title Title.
/// @param value Current value.
/// @param minValue Min value.
/// @param maxValue Max value.
+ (instancetype)modelWithTitle:(NSString *_Nullable)title value:(CGFloat)value minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

#pragma mark - UNAVAILABLE
/// Unavailable method.
/// @param title Title.
+ (instancetype)modelWithTitle:(NSString *_Nullable)title NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
